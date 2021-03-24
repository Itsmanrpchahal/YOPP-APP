import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeago/timeago.dart' as TimeAgo;

import 'package:yopp/helper/app_color/app_gradients.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/ui/chat_detail_screen.dart';
import 'package:yopp/modules/bottom_navigation/chat/chatlist/bloc/chat_list_bloc.dart';
import 'package:yopp/modules/bottom_navigation/chat/chatlist/bloc/chat_list_event.dart';
import 'package:yopp/modules/bottom_navigation/chat/chatlist/bloc/chat_list_state.dart';
import 'package:yopp/modules/bottom_navigation/bottom_nav_page.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

import 'package:yopp/widgets/icons/circular_profile_icon.dart';

import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
import 'package:yopp/widgets/textfield/searchBar.dart';

import '../../bottom_nav_appBar.dart';

class ChatListScreen extends StatefulWidget {
  static const routeName = '/chat_list';

  ChatListScreen({
    Key key,
  }) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;
  Timer timeAgoTimer;
  List<ChatDescription> filteredChatHistory = [];
  List<ChatDescription> chatHistory = [];
  String currentUserId = "";

  void filterChatHistory(String fitlerWith) {
    filteredChatHistory = chatHistory.where((chatDescription) {
      var otherUserName = "";
      if (currentUserId == chatDescription.user1Id) {
        otherUserName = chatDescription.user2Name;
      } else {
        otherUserName = chatDescription.user1Name;
      }

      return otherUserName.toLowerCase().contains(fitlerWith.toLowerCase());
    }).toList();
    setState(() {});
  }

  @override
  void initState() {
    print("ChatList Screen init");
    currentUserId = FirebaseAuth.instance.currentUser.uid;
    BlocProvider.of<ChatHistoryBloc>(context).add(GetChatHistoryEvent(null));
    startTimeAgoUpdateTimer();
    super.initState();
  }

  @override
  void dispose() {
    print("ChatList Screen dispose");
    timeAgoTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("ChatList:" + state.toString());
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print("cancel timer");
      timeAgoTimer?.cancel();
    }
    if (state == AppLifecycleState.resumed) {
      if (!timeAgoTimer.isActive) {
        startTimeAgoUpdateTimer();
        print("resumed timer");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BottomNavPage(
      enableGradient: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Hexcolor("#222222"),
        extendBody: true,
        appBar: BottomNavAppBar(
          context: context,
          title: Text(
            "Chats",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        body: BlocListener<ChatHistoryBloc, ChatHistoryState>(
          listener: (context, state) {
            setState(() {
              chatHistory = state.history;
              filteredChatHistory = state.history;
            });
          },
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildSearchSection(context),
        Expanded(
          child: ClipPath(
              clipper: HalfCurveClipper(),
              child: Container(child: _buildChatList(context))),
        ),
      ],
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Divider(
            color: Colors.white24,
            height: 2,
          ),
          SizedBox(
            height: 8,
          ),
          SearchBar(onChange: (value) {
            filterChatHistory(value);
          }),
        ],
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: AppGradients.backgroundGradient),
        child: filteredChatHistory.length == 0
            ? _buildNoChatHistoryWidget(context)
            : ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: filteredChatHistory.length,
                itemBuilder: (context, index) {
                  ChatDescription item = filteredChatHistory[index];
                  return _buildChatListItem(
                      context: context, chatDescription: item, index: index);
                }));
  }

  Widget _buildChatListItem({
    BuildContext context,
    ChatDescription chatDescription,
    int index,
  }) {
    final currentTime = DateTime.now();

    var imageUrl = "";
    var name = "";
    var gender = Gender.male;

    if (currentUserId == chatDescription.user1Id) {
      imageUrl = chatDescription.user2Profile;
      name = chatDescription.user2Name;
      gender = chatDescription.user2Gender;
    } else {
      imageUrl = chatDescription.user1Profile;
      name = chatDescription.user1Name;
      gender = chatDescription.user1Gender;
    }

    final usersForMessage = chatDescription.lastMessage.users;
    String message;
    if (usersForMessage.contains(currentUserId)) {
      message = chatDescription.lastMessage.message;
    } else {
      message = "You deleted a message.";
    }

    final timeDifference =
        currentTime.difference(chatDescription.lastMessage.timeStamp);
    final timeAgo = TimeAgo.format(
      currentTime.subtract(timeDifference),
      locale: 'en_short',
    );

    return GestureDetector(
      onTap: () => _showChatDetail(context, chatDescription),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.3,
              secondaryActions: <Widget>[
                IconSlideAction(
                  // caption: 'Delete',
                  color: Colors.black12,
                  // icon: Icons.delete,
                  iconWidget: Row(
                    children: [
                      Container(width: 2, color: Colors.white),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () =>
                      _deleteChatRoom(context, chatDescription.chatRoomId),
                ),
              ],
              child: Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    ActiveCircularProfileIcon(
                      imageUrl: imageUrl,
                      isOnline: false,
                      gender: gender,
                    ),
                    SizedBox(height: 4),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildChatInfoWidget(
                        chatDescription.sportName,
                        name ?? "",
                        timeAgo,
                        message,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              indent: 60,
              thickness: 2,
              color: Colors.white30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInfoWidget(
      String sportName, String name, String timeAgo, String message) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  timeAgo,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Text(
            message,
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          SizedBox(height: 4),
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              sportName ?? "",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  _showChatDetail(BuildContext context, ChatDescription chatDescription) {
    Navigator.of(context).push(ChatDetailScreen.route(chatDescription));
  }

  _buildNoChatHistoryWidget(BuildContext context) {
    return Center(
      child: Text(
        "No Chat History",
        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _deleteChatRoom(BuildContext context, String chatRoomId) {
    BlocProvider.of<ChatHistoryBloc>(context)
        .add(RemoveSelfFromChatRoomEvent(chatRoomId));
  }

  void startTimeAgoUpdateTimer() {
    print("startTimeAgoUpdateTimer");
    timeAgoTimer?.cancel();
    timeAgoTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      print("Timer updated");
      if (mounted) {
        setState(() {});
      }
    });
  }
}