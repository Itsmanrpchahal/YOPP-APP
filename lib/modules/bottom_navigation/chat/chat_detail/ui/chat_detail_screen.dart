import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailto/mailto.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

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
import 'package:yopp/modules/bottom_navigation/profile/bloc/api_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connections_bloc.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/progress_hud/progress_hud.dart';
import 'package:yopp/widgets/progress_indicator/jumping_dot_progress_indicator.dart';
import 'package:yopp/widgets/textfield/chat_input.dart';

import 'chat_detail_app_bar.dart';
import 'time_message_widget.dart';

class ChatDetailScreen extends StatefulWidget {
  static Route route({
    @required ChatDescription chatDescription,
    @required String chatRoomId,
  }) {
    return FadeRoute(
      builder: (context) => BlocProvider<ChatBloc>(
        create: (BuildContext context) => ChatBloc(
          FirebaseChatService(),
          chatRoomId,
          APIProfileService(),
        ),
        child: ChatDetailScreen(
          chatDescription: chatDescription,
          chatRoomId: chatRoomId,
        ),
      ),
    );
  }

  final ChatDescription chatDescription;
  final String chatRoomId;

  const ChatDetailScreen({
    Key key,
    @required this.chatDescription,
    @required this.chatRoomId,
  }) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with WidgetsBindingObserver {
  StreamSubscription<Event> onlineSubscription;

  bool otherUserIsOnline = false;
  bool iAmTyping = false;
  bool otherUserIsTyping = false;

  RefreshController _refreshController;
  ScrollController _scrollController;

  StreamSubscription typingSubscription;

  UserProfile otherUserProfile;
  String otherUserId;

  @override
  void dispose() {
    print("dispose ChatDetailScreen");
    _scrollController.dispose();
    _refreshController.dispose();
    typingSubscription?.cancel();
    onlineSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  loadPreviousMessages() {
    BlocProvider.of<ChatBloc>(context, listen: false)
        .add(LoadPreviousMessageEvent());
  }

  @override
  void initState() {
    super.initState();
    print("initState ChatDetailScreen");
    _refreshController = new RefreshController();
    _scrollController = new ScrollController();
    WidgetsBinding.instance.addObserver(this);

    setupChatRoom(widget?.chatDescription);
  }

  void setupChatRoom(ChatDescription chatRoom) {
    if (chatRoom != null) {
      if (FirebaseAuth.instance.currentUser.uid == chatRoom.user2Id) {
        observeOtherUser(chatRoom.user1Id);
        BlocProvider.of<ChatBloc>(context, listen: false).add(
            LoadInitialMessageEvent(
                chatRoomId: chatRoom.chatRoomId,
                otherUserId: chatRoom.user1Id));
      } else {
        observeOtherUser(chatRoom.user2Id);
        BlocProvider.of<ChatBloc>(context, listen: false).add(
            LoadInitialMessageEvent(
                chatRoomId: chatRoom.chatRoomId,
                otherUserId: chatRoom.user2Id));
      }
    }
  }

  void observeOtherUser(String userId) {
    otherUserId = userId;
    checkForOtherUserTyping(userId);
    observeUserOnlineStatus(userId);
  }

  void observeUserOnlineStatus(String uid) {
    onlineSubscription = FirebaseConstants.onlineStatusDatabaseRef
        .child(uid)
        .onValue
        .listen((event) {
      if (event?.snapshot?.value != null) {
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
    }
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
        print("onWillPop");
        updateTyping(context, false);

        return true;
      },
      child: ProgressHud(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          extendBody: true,
          appBar: ChatDetailAppBar(
            context: context,
            titleText: "CHAT",
            onBlockUser: () => _blockUser(
              friendId: otherUserProfile?.id,
              myId: context.read<ProfileBloc>().state.userProfile.id,
              chatRoomId: widget.chatDescription.chatRoomId,
            ),
            onReportUser: () => {
              Navigator.of(context).push(
                ReportScreen.route(
                  reportTo: otherUserProfile?.id,
                  title: "Chat: " + widget.chatDescription.chatRoomId,
                ),
              )
            },
          ),
          body: BlocConsumer<ChatBloc, ChatState>(
            builder: (context, state) {
              return _buildBody(context, state);
            },
            listener: (context, state) async {
              ProgressHud.of(context).dismiss();

              switch (state.status) {
                case ChatStatus.initial:
                  break;
                case ChatStatus.loadingInitial:
                  ProgressHud.of(context)
                      .show(ProgressHudType.loading, state.serviceMessage);
                  break;
                case ChatStatus.loadingInitialSuccess:
                  otherUserProfile = state.otherUser;
                  if (widget.chatDescription == null) {
                    setupChatRoom(state.chatRoom);
                  }
                  scrollToBottom();

                  break;
                case ChatStatus.failure:
                  _refreshController.refreshCompleted();
                  await ProgressHud.of(context).showAndDismiss(
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
                  await ProgressHud.of(context).showAndDismiss(
                      ProgressHudType.success, state.serviceMessage);
                  context.read<ConnectionsBloc>().add(LoadConnectionEvent());
                  Navigator.of(context).pop();
                  break;
              }
            },
          ),
        ),
      ),
    );
  }

  void scrollToBottom() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn,
        );
      });

      // });
    }
  }

  Widget _buildBody(
    BuildContext context,
    ChatState state,
  ) {
    return Container(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _buildChatList(context, state.chatMessages),
          ((state.chatRoom?.blockedBy != null &&
                      state.chatRoom.blockedBy.isNotEmpty) ||
                  state.chatRoom?.connectionEndedBy != null)
              ? _buildLeftChatText(context, state)
              : _buildChatInputField(context, state),
        ],
      ),
    );
  }

  Widget _buildChatList(BuildContext context, List<ChatMessage> chatMessages) {
    var padding = 80 + MediaQuery.of(context).viewPadding.bottom;
    padding += otherUserIsTyping ? 40 : 0;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: padding,
      ),
      child: SmartRefresher(
        enablePullDown: true, //previousMessageMayBePresent,
        header: ClassicHeader(
          textStyle:
              TextStyle(color: AppColors.green, fontWeight: FontWeight.bold),
          releaseIcon: Icon(
            Icons.refresh,
            color: AppColors.green,
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
                    child: _chatMessageWidget(chatMessages[index])),
              );
            }),
      ),
    );
  }

  Widget _chatMessageWidget(ChatMessage chatMessage) {
    if (chatMessage.type.toLowerCase() == "timestamp") {
      return TimeMessageWidget(
        message: chatMessage.message,
      );
    }
    if (chatMessage.type.toLowerCase() == "text") {
      if (chatMessage.sender == FirebaseAuth.instance.currentUser.uid) {
        return SentMessageWidget(
          message: chatMessage.message,
        );
      } else {
        return RecievedMessageWidget(
          isOnline: otherUserIsOnline,
          message: chatMessage.message,
          imageUrl: otherUserProfile?.avatar,
          gender: otherUserProfile?.gender,
        );
      }
    }
    return Container();
  }

  _buildChatInputField(
    BuildContext context,
    ChatState state,
  ) {
    return Container(
      child: Column(
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
                        color: AppColors.green,
                        size: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6, bottom: 4),
                        child: Text(
                          (otherUserProfile?.name ?? "Other memeber") +
                              " is typing...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          Container(
            height: 80,
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, -4))
                ]),
            child: ChatInputField(
              setIsTyping: (value) {
                iAmTyping = value;
                updateTyping(context, value);
              },
              onTrailingAction: (message) {
                sendTextMessage(
                  context: context,
                  message: message,
                  chatRoom: state.chatRoom,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void sendTextMessage({
    @required BuildContext context,
    @required String message,
    @required ChatDescription chatRoom,
  }) {
    BlocProvider.of<ChatBloc>(context, listen: false).add(PostChatMessageEvent(
      message,
      "TEXT",
      chatRoom,
    ));
  }

  void updateTyping(BuildContext context, bool value) {
    BlocProvider.of<ChatBloc>(context, listen: false).add(
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
    BlocProvider.of<ChatBloc>(context, listen: false)
        .add(RemoveMessageForSelfEvent(message.messageId));
  }

  Widget _buildLeftChatText(BuildContext context, ChatState state) {
    print("_buildLeftChatText");
    print(state.chatRoom.connectionEndedBy);
    print(state.chatRoom.blockedBy);
    return Container(
      height: 80,
      width: double.infinity,
      color: AppColors.green,
      child: Center(
        child: Text(
            (otherUserProfile?.name ?? "Other user") +
                " is not available for chat.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }

  void _blockUser({
    @required String friendId,
    @required String myId,
    @required String chatRoomId,
  }) {
    BlocProvider.of<ChatBloc>(context, listen: false).add(BlockUserEvent(
      friendId: friendId,
      myId: myId,
      chatRoomId: chatRoomId,
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
