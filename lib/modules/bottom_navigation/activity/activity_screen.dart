import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/modules/bottom_navigation/activity/bloc/activity.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity_bloc.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity_event.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity_state.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/ui/chat_detail_screen.dart';

import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';

import 'package:yopp/widgets/icons/circular_profile_icon.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class ActivityScreen extends StatefulWidget {
  static const routeName = "activity";

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<ChatActivity> activities = [];
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    loadLatestActivities(context);
    super.initState();
  }

  loadLatestActivities(BuildContext context) {
    BlocProvider.of<ActivityBloc>(context, listen: false)
        .add(GetLatestActivityList());
  }

  loadPreviousActivities(BuildContext context) {
    BlocProvider.of<ActivityBloc>(context, listen: false)
        .add(GetPreviousActivityList());
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
        appBar: new DefaultAppBar(
          context: context,
          titleText: "Notifications",
        ),
        body: BlocListener<ActivityBloc, ActivityState>(
          listener: (context, state) async {
            ProgressHud.of(context).dismiss();
            switch (state.status) {
              case ActivityStatus.initial:
                break;
              case ActivityStatus.loadingInitial:
                ProgressHud.of(context)
                    .show(ProgressHudType.loading, state.serviceMessage);
                break;
              case ActivityStatus.loadingPrevious:
                ProgressHud.of(context)
                    .show(ProgressHudType.loading, state.serviceMessage);
                break;
              case ActivityStatus.loadingInitialSuccess:
                break;
              case ActivityStatus.loadingPreviousSuccess:
                _refreshController.refreshCompleted();
                _refreshController.loadComplete();
                break;
              case ActivityStatus.replying:
                ProgressHud.of(context)
                    .show(ProgressHudType.loading, state.serviceMessage);
                break;
              case ActivityStatus.replied:
                await ProgressHud.of(context).showAndDismiss(
                    ProgressHudType.success, state.serviceMessage);
                loadLatestActivities(context);
                break;
              case ActivityStatus.failed:
                _refreshController.refreshCompleted();
                break;
            }

            setState(() {
              activities = state.activities;
              
            });
          },
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Expanded(child: _buildActivityList(context)),
          ],
        ));
  }

  Widget _buildActivityList(BuildContext context) {
    if (activities.isEmpty) {
      return _buildNoDataBackground(context);
    }
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: false,
      footer: ClassicFooter(
        textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        idleIcon: Icon(
          Icons.refresh,
          color: Colors.black,
        ),
        loadingIcon: CupertinoActivityIndicator(),
        idleText: "Pull to Load More",
        failedText: "Failed to Load More",
        noDataText: "No Data",
        canLoadingText: "Release to Load More",
        loadingText: "Loading",
      ),
      onRefresh: () {
        print("onRefresh");
      },
      onLoading: () => loadPreviousActivities(context),
      // onTwo1Level: () {
      //   print("two level");
      // },
      controller: _refreshController,
      child: ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];

            return GestureDetector(
              onTap: () {
                _showChatDetail(context, activity.chatDescription);
              },
              child: _buildInitalActivityItem(
                context: context,
                activity: activity,
              ),
            );
          }),
    );
  }

  Widget _buildInitalActivityItem({
    @required BuildContext context,
    @required ChatActivity activity,
  }) {
    final currentUserId = FirebaseAuth.instance.currentUser.uid;

    var otherUserName = "";
    var imageUrl = "";

    Gender gender;

    if (currentUserId == activity.chatDescription.user1Id) {
      otherUserName = activity.chatDescription.user2Name;
      imageUrl = activity.chatDescription.user2Profile;
      gender = activity.chatDescription.user2Gender;
    } else {
      otherUserName = activity.chatDescription.user1Name;
      imageUrl = activity.chatDescription.user1Profile;
      gender = activity.chatDescription.user1Gender;
    }

    var message = activity.chatDescription.lastMessage.message;
    var name;

    if (activity.chatDescription.lastMessage.sender.toLowerCase() == "admin") {
      name = otherUserName;
    } else if (activity.chatDescription.lastMessage.sender == currentUserId) {
      final usersForMessage = activity.chatDescription.lastMessage.users;
      if (usersForMessage.contains(currentUserId)) {
        name = "You sent a message to " + otherUserName;
        message = activity.chatDescription.lastMessage.message;
      } else {
        name = otherUserName;
        message = "You deleted a message.";
      }
    } else {
      name = otherUserName + " sent you a message!";
    }

    // final currentTime = DateTime.now();
    // final timeDifference =
    //     currentTime.difference(activity.chatDescription.lastMessage.timeStamp);
    // final timeAgo = TimeAgo.format(
    //   currentTime.subtract(timeDifference),
    //   locale: 'en_short',
    // );

    var timeDescription = "";

    timeDescription = DateFormat.yMd()
        .add_jm()
        .format(activity.chatDescription.lastMessage.timeStamp);
    return Container(
      margin: EdgeInsets.only(left: 32, right: 32, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 16,
                      spreadRadius: 0)
                ]),
            child: Padding(
              padding: EdgeInsets.only(top: 12, right: 8, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildProfileIcon(
                          imageUrl,
                          gender,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              name == null
                                  ? Container()
                                  : Text(
                                      name ?? "",
                                      style: TextStyle(
                                          color: AppColors.green,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                              SizedBox(height: 4),
                              Text(
                                message,
                                maxLines: 2,
                                softWrap: true,
                                style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 48),
                    child: FlatButton(
                      height: 20,
                      minWidth: 60,
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          _showChatDetail(context, activity.chatDescription),
                      child: Text(
                        "CHAT",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 10),
                      ),
                      color: AppColors.lightGreen,
                      textColor: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            timeDescription,
            style: TextStyle(
              color: AppColors.green,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileIcon(String imageUrl, Gender gender) {
    return Transform.translate(
      offset: Offset(-14, 0),
      child: CircularProfileIconWithShadow(
        imageUrl: imageUrl,
        gender: gender,
        size: 40,
      ),
    );
  }

  _buildNoDataBackground(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: Offset(0, -60),
        child: Text(
          "No Activity Notification Available",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _showChatDetail(BuildContext context, ChatDescription chatDescription) {
    print("_showChatDetail");
    Navigator.of(context).push(ChatDetailScreen.route(
      chatRoomId: chatDescription.chatRoomId,
      chatDescription: chatDescription,
    ));
  }
}
