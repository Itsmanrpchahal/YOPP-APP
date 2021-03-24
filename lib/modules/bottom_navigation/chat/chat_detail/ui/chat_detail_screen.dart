import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailto/mailto.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:yopp/helper/app_color/app_gradients.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/helper/firebase_constants.dart';

import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_message.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_service.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/bloc/chat_bloc.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/bloc/chat_event.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/bloc/chat_state.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/ui/reciever_message_widget.dart';
import 'package:yopp/modules/_common/report/report_form.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/ui/sender_message_widget.dart';
import 'package:yopp/modules/bottom_navigation/users_profile/ui/users_profile_screen.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/firebase_profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';
import 'package:yopp/widgets/progress_indicator/jumping_dot_progress_indicator.dart';
import 'package:yopp/widgets/textfield/chat_input.dart';

import 'chat_detail_app_bar.dart';
import 'time_message_widget.dart';

class ChatDetailScreen extends StatefulWidget {
  static Route route(ChatDescription chatDescription) {
    return FadeRoute(
      builder: (context) => BlocProvider<ChatBloc>(
        create: (BuildContext context) => ChatBloc(
          FirebaseChatService(),
          chatDescription.chatRoomId,
          FirebaseProfileService(),
        ),
        child: ChatDetailScreen(
          chatDescription: chatDescription,
        ),
      ),
    );
  }

  final ChatDescription chatDescription;
  const ChatDetailScreen({Key key, this.chatDescription}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with WidgetsBindingObserver {
  String currentUserId;
  String otherUserId;

  StreamSubscription<Event> onlineSubscription;

  bool otherUserIsOnline = false;
  bool iAmTyping = false;
  bool otherUserIsTyping = false;

  List<ChatMessage> chatMessages = [];

  RefreshController _refreshController = RefreshController();
  ScrollController _scrollController = new ScrollController();

  StreamSubscription typingSubscription;
  StreamSubscription otherUserSubscription;
  UserProfile otherUserProfile;
  bool disableChat = false;

  @override
  void dispose() {
    print("dispose");
    typingSubscription?.cancel();
    onlineSubscription?.cancel();
    otherUserSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void initState() {
    print("Users");
    print(widget?.chatDescription?.users ?? "NA");
    currentUserId = FirebaseAuth.instance.currentUser.uid;

    if (currentUserId == widget.chatDescription.user2Id) {
      otherUserId = widget.chatDescription.user1Id;
    } else {
      otherUserId = widget.chatDescription.user2Id;
    }

    observeOtherUserProfile(otherUserId);
    WidgetsBinding.instance.addObserver(this);
    BlocProvider.of<ChatBloc>(context)
        .add(LoadInitialMessageEvent(widget.chatDescription.chatRoomId));

    checkForOtherUserTyping(otherUserId);
    observeUserOnlineStatus(otherUserId);

    if (widget?.chatDescription?.users?.length != null &&
        widget.chatDescription.users.length < 2) {
      print(" disableChat = true;");
      disableChat = true;
    }

    super.initState();
  }

  observeOtherUserProfile(String uid) {
    otherUserSubscription = FirebaseConstants.userCollectionRef
        .doc(uid)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        if (mounted) {
          setState(() {
            otherUserProfile = UserProfile.fromJson(event.data());
            if (otherUserProfile.status != UserStatus.active) {
              disableChat = true;
            }
            if (otherUserProfile.blocked.contains(currentUserId)) {
              disableChat = true;
            }
            if (otherUserProfile.blockedBy.contains(currentUserId)) {
              disableChat = true;
            }
          });
        }
      }
    });
  }

  observeUserOnlineStatus(String uid) {
    onlineSubscription = FirebaseConstants.onlineStatusDatabaseRef
        .child(uid)
        .onValue
        .listen((event) {
      if (event.snapshot != null) {
        print("Status Updated:" + event.snapshot.value.toString());
        if (mounted) {
          setState(() {
            otherUserIsOnline = event.snapshot.value["presence"];
          });
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("Chat Detail:" + state.toString());
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      updateTyping(context, false);
      typingSubscription?.pause();
    }
    if (state == AppLifecycleState.resumed) {
      typingSubscription?.resume();
      if (iAmTyping) {
        updateTyping(context, iAmTyping);
      }

      print("resumed");
    }
  }

  loadPreviousMessages() {
    BlocProvider.of<ChatBloc>(context).add(LoadPreviousMessageEvent());
  }

  void checkForOtherUserTyping(String userId) {
    typingSubscription?.cancel();
    typingSubscription = FirebaseConstants.chatCollectionRef
        .doc(widget.chatDescription.chatRoomId)
        .collection("isTyping")
        .doc(userId)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        final typing = Typing.fromJson(event.data());
        print(typing.value);
        if (mounted) {
          setState(() {
            print(typing.value);
            otherUserIsTyping = typing.value;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        updateTyping(context, false);
        return true;
      },
      child: ProgressHud(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Hexcolor("#222222"),
          extendBody: true,
          appBar: ChatDetailAppBar(
            context: context,
            titleText: otherUserProfile?.name ?? "",
            imageUrl: otherUserProfile?.avatar,
            isOnline: otherUserIsOnline,
            heroTag: otherUserId,
            gender: otherUserProfile?.gender,
            onBack: () {
              updateTyping(context, false);
            },
            onBlockUser: () =>
                _blockUser(id: otherUserProfile.id, uid: otherUserProfile.uid),
            onReportUser: () => {
              Navigator.of(context).push(
                ReportScreen.route(
                  reportTo: otherUserProfile.id,
                  title: "Chat: " + widget.chatDescription.chatRoomId,
                ),
              )
            },
            onProfileTap: () async {
              if (otherUserProfile.blocked.contains(currentUserId)) {
                return;
              }
              if (otherUserProfile.blockedBy.contains(currentUserId)) {
                return;
              }

              if (otherUserProfile.status == UserStatus.active) {
                updateTyping(context, false);
                await Navigator.of(context).push(UserProfileScreen.route(
                    userId: otherUserId,
                    userProfile: otherUserProfile,
                    selectedSportName: widget.chatDescription?.sportName));
                if (iAmTyping) {
                  updateTyping(context, true);
                }
              }
            },
          ),
          body: BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (mounted) {
                setState(() {
                  chatMessages = state.chatMessages;
                });
              }

              ProgressHud.of(context).dismiss();
              switch (state.status) {
                case ChatStatus.initial:
                  break;
                case ChatStatus.loadingInitial:
                  ProgressHud.of(context)
                      .show(ProgressHudType.loading, state.serviceMessage);
                  break;
                case ChatStatus.loadingInitialSuccess:
                  ProgressHud.of(context)
                      .show(ProgressHudType.success, state.serviceMessage);
                  scrollToBottom();

                  break;
                case ChatStatus.failure:
                  _refreshController.refreshCompleted();
                  ProgressHud.of(context).showAndDismiss(
                      ProgressHudType.error, state.serviceMessage);
                  break;
                case ChatStatus.loadingPrevious:
                  break;
                case ChatStatus.observingNew:
                  break;
                case ChatStatus.loadingPreviousSuccess:
                  _refreshController.refreshCompleted();
                  break;
                case ChatStatus.observedNew:
                  scrollToBottom();
                  break;
                case ChatStatus.deleting:
                  ProgressHud.of(context)
                      .show(ProgressHudType.loading, state.serviceMessage);
                  break;
                case ChatStatus.deleted:
                  break;
                case ChatStatus.blocking:
                  ProgressHud.of(context)
                      .show(ProgressHudType.loading, state.serviceMessage);
                  break;
                case ChatStatus.blocked:
                  ProgressHud.of(context).showAndDismiss(
                      ProgressHudType.success, state.serviceMessage);
                  break;
              }
            },
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  void scrollToBottom() {
    if (mounted) {
      setState(() {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
        );
      });
    }
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: ClipPath(
        clipper: HalfCurveClipper(),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildChatList(context),
            disableChat
                ? _buildLeftChatText(context)
                : _buildChatInputField(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    var padding = 80 + MediaQuery.of(context).viewPadding.bottom;
    padding += otherUserIsTyping ? 40 : 0;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: padding,
      ),
      decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
      child: SmartRefresher(
        enablePullDown: true, //previousMessageMayBePresent,
        header: ClassicHeader(
          textStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          releaseIcon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          refreshingIcon: CupertinoTheme(
            data: CupertinoTheme.of(context)
                .copyWith(brightness: Brightness.dark),
            child: CupertinoActivityIndicator(),
          ),
          idleText: "Pull to Load More",
          releaseText: "Release to Load More",
          completeText: "Loading Completed",
          refreshingText: "Loading",
        ),
        onRefresh: () => loadPreviousMessages(),
        controller: _refreshController,
        child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            reverse: false,
            controller: _scrollController,
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                    onLongPress: () =>
                        _showChatMessageOptions(context, chatMessages[index]),
                    child: _chatItem(index)),
              );
            }),
      ),
    );
  }

  Widget _chatItem(index) {
    final chatMessage = chatMessages[index];
    if (chatMessage.type.toLowerCase() == "timestamp") {
      return TimeMessageWidget(
        message: chatMessage.message,
      );
    }
    if (chatMessage.type.toLowerCase() == "text") {
      if (chatMessage.sender == currentUserId) {
        return SentMessageWidget(
          message: chatMessage.message,
        );
      } else {
        return RecievedMessageWidget(
          message: chatMessage.message,
          imageUrl: otherUserProfile?.avatar,
          gender: otherUserProfile?.gender,
        );
      }
    }
    return Container();
  }

  _buildChatInputField(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        otherUserIsTyping && otherUserIsOnline
            ? Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    JumpingDotsProgressIndicator(
                      color: Colors.white,
                      size: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6, bottom: 4),
                      child: Text(
                        (otherUserProfile?.name ?? "Other memeber") +
                            " is typing...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            : Container(),
        ClipPath(
          clipper: HalfCurveClipper(customRadius: 40),
          child: Container(
            height: 80,
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ChatInputField(
              setIsTyping: (value) {
                iAmTyping = value;
                updateTyping(context, value);
              },
              onTrailingAction: (message) {
                sendTextMessage(context, message);
              },
            ),
          ),
        )
      ],
    );
  }

  void sendTextMessage(BuildContext context, String message) {
    BlocProvider.of<ChatBloc>(context).add(PostChatMessageEvent(
      message,
      "TEXT",
      widget.chatDescription,
    ));
  }

  void updateTyping(BuildContext context, bool value) {
    BlocProvider.of<ChatBloc>(context).add(
        UpdateTypingEvent(Typing(value: value, timeStamp: DateTime.now())));
  }

  _showChatMessageOptions(BuildContext context, ChatMessage message) async {
    final delete = await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(8.0),
          height: 160,
          child: Column(
            children: <Widget>[
              ListTile(
                onTap: () => Navigator.of(context).pop("Delete"),
                leading: Icon(Icons.delete_forever),
                title: Text('Delete'),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop(null);
                },
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );

    if (delete != null) {
      _deleteMessage(context, message);
    }
  }

  _deleteMessage(BuildContext context, ChatMessage message) {
    BlocProvider.of<ChatBloc>(context)
        .add(RemoveMessageForSelfEvent(message.messageId));
  }

  Widget _buildLeftChatText(BuildContext context) {
    final users = widget.chatDescription.users;
    if (users != null) {
      if (users.contains(otherUserId)) {
      } else {
        return Container(
          height: 50,
          child: Text(
              (otherUserProfile?.name ?? "Other memeber") + " left the chat.",
              style: TextStyle(
                color: Colors.white60,
              )),
        );
      }
    }
    return Container();
  }

  void _blockUser({
    @required String id,
    @required String uid,
  }) {
    BlocProvider.of<ChatBloc>(context).add(BlocUserEvent(
      id: id,
      uid: uid,
    ));
  }

  void launchMailto(String subject) async {
    final mailtoLink = Mailto(
      to: [AppConstant.helpEmail],
      subject: subject,
      body: '',
    );

    await launch('$mailtoLink');
  }
}
