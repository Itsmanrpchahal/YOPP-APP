import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:timeago/timeago.dart' as TimeAgo;

import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity_bloc.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity_event.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity_state.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/ui/chat_detail_screen.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

import 'package:yopp/widgets/app_bar/transparent_appbar_with_cross.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/icons/circular_profile_icon.dart';

import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
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
    BlocProvider.of<ActivityBloc>(context).add(GetLatestActivityList());
  }

  loadPreviousActivities(BuildContext context) {
    BlocProvider.of<ActivityBloc>(context).add(GetPreviousActivityList());
  }

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
      extendBodyBehindAppBar: false,
      appBar: TransparentAppBarWithCrossAction(
        context: context,
        onPressed: () {
          Navigator.of(context).pop();
        },
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
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: ClipPath(
        clipper: HalfCurveClipper(),
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Hexcolor("#F2F2F2")),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeading(context),
                SizedBox(height: 20),
                Expanded(child: _buildActivityList(context)),
              ],
            )),
      ),
    );
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
      onTwoLevel: () {
        print("two level");
      },
      controller: _refreshController,
      child: ListView.builder(
          padding: EdgeInsets.only(top: 20),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];

            return GestureDetector(
              onTap: () {
                _showChatDetail(context, activity.chatDescription);
              },
              child: _buildInitalActivityItem(
                  context: context, activity: activity),
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

    final currentTime = DateTime.now();
    final timeDifference =
        currentTime.difference(activity.chatDescription.lastMessage.timeStamp);
    final timeAgo = TimeAgo.format(
      currentTime.subtract(timeDifference),
      locale: 'en_short',
    );

    return Container(
      margin: EdgeInsets.only(left: 18, right: 18, bottom: 8),
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 40),
                blurRadius: 60,
                spreadRadius: 0)
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16, top: 12, right: 8, bottom: 12),
        child: Column(
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
                                    color: Hexcolor("#222222"),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                              ),
                        SizedBox(height: 4),
                        Text(
                          message,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            activity.chatDescription.sportName ?? "",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          timeAgo,
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileIcon(String imageUrl, Gender gender) {
    return Container(
      height: 60,
      width: 60,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          CircularProfileIcon(
            imageUrl: imageUrl,
            gender: gender,
            size: 60,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Transform.translate(
              offset: Offset(8, 8),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.green,
                  child: Icon(
                    CupertinoIcons.chat_bubble_2_fill,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildHeading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Notifications",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 36),
          ),
        ],
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
    Navigator.of(context).push(ChatDetailScreen.route(chatDescription));
  }
}
