import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/ui/chat_detail_app_bar.dart';

import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_bloc.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_event.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_state.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/bottom_navigation/discover/ui/discover_profile_widget.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_event.dart';

import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connections_bloc.dart';
import 'package:yopp/modules/bottom_navigation/users_profile/ui/users_profile_screen.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

class DiscoverPage extends StatefulWidget {
  final Function onRefresh;

  const DiscoverPage({
    Key key,
    @required this.onRefresh,
  }) : super(key: key);
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  RefreshController refreshController;
  @override
  void initState() {
    print("_DiscoverPageState");

    refreshController = RefreshController();

    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _crossAxisSpacing = 24, _mainAxisSpacing = 24;
    int _crossAxisCount = 2;
    double screenWidth = MediaQuery.of(context).size.width;

    var width = (screenWidth - ((_crossAxisCount + 1) * _crossAxisSpacing)) /
        _crossAxisCount;

    var height = width + 100;
    var _aspectRatio = width / height;

    return BlocConsumer<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: _mainAxisSpacing, vertical: _mainAxisSpacing),
          child: SmartRefresher(
            controller: refreshController,
            enablePullUp: state.data.length > 0,
            onRefresh: () {
              refreshController.refreshCompleted();
              widget.onRefresh();
            },
            onLoading: () {
              print("onloading");
              context.read<DiscoverBloc>().add(LoadMoreDiscoveredUserEvent());
            },
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: _mainAxisSpacing,
                    crossAxisCount: _crossAxisCount,
                    crossAxisSpacing: _crossAxisSpacing,
                    childAspectRatio: _aspectRatio,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return DiscoveredUserCard(
                        width: width,
                        userProfile: state.data.elementAt(index),
                      );
                    },
                    childCount: state?.data?.length ?? 0,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                  padding: EdgeInsets.only(bottom: 60),
                  child: context.watch<DiscoverBloc>().state.status ==
                          DiscoverServiceStatus.loadingAnotherPage
                      ? Center(child: CircularProgressIndicator())
                      : Container(),
                )),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        switch (state.status) {
          case DiscoverServiceStatus.initial:
            break;
          case DiscoverServiceStatus.noLocation:
            break;
          case DiscoverServiceStatus.loading:
            break;
          case DiscoverServiceStatus.loaded:
            refreshController.loadComplete();
            break;
          case DiscoverServiceStatus.loadingFailed:
            refreshController.loadFailed();
            break;
          case DiscoverServiceStatus.loadingAnotherPage:
            break;
          case DiscoverServiceStatus.loadedAnotherPage:
            refreshController.loadComplete();

            break;
          case DiscoverServiceStatus.loadingAnotherPageFailed:
            refreshController.loadFailed();
            break;
        }
      },
    );
  }
}

class DiscoveredUserCard extends StatelessWidget {
  final DiscoveredUserData userProfile;
  const DiscoveredUserCard({
    Key key,
    @required this.width,
    @required this.userProfile,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    var sportName = "Looking for ";

    if (userProfile?.selectedInterest != null) {
      sportName += userProfile.selectedInterest?.subCategory != null
          ? userProfile.selectedInterest.subCategory
          : userProfile.selectedInterest?.category != null
              ? userProfile.selectedInterest?.category
              : userProfile.selectedInterest?.interest ?? "";
      sportName += " partners.";
    }

    var genderAndAge = '';
    if (userProfile.gender != null) {
      genderAndAge = userProfile.gender.name.toUpperCase();
    }

    if (userProfile.age != null) {
      genderAndAge += ", " + userProfile.age.toString();
    }

    return Container(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userProfile?.online != null
                        ? userProfile.online
                            ? "online"
                            : "offline"
                        : "",
                    style: TextStyle(fontSize: 10, color: AppColors.green),
                  ),
                  Text(
                    (userProfile.distance / 1000).toStringAsFixed(0) +
                        "km away",
                    style: TextStyle(fontSize: 10, color: AppColors.green),
                  ),
                ],
              )),
          DiscoverProfileWidget(
            userProfile: userProfile,
            height: width,
            width: width,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(UserProfileScreen.route(
                                userId: userProfile.uid,
                                userProfile: null,
                              ));
                            },
                            child: Text((userProfile?.name ?? ""),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyle(
                                    color: AppColors.green, fontSize: 16))),
                      ),
                      SizedBox(height: 2),
                      Text(
                        genderAndAge,
                        maxLines: 1,
                        style: TextStyle(color: AppColors.green, fontSize: 12),
                      ),
                      SizedBox(height: 2),
                      Text(
                        sportName,
                        maxLines: 2,
                        style: TextStyle(color: AppColors.green, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 4),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleIconButton(
                      radius: 12,
                      onPressed: () => _goToChatDetail(context, userProfile),
                      icon: Center(
                        child: SvgPicture.asset(
                          'assets/icons/chat.svg',
                          fit: BoxFit.contain,
                          color: AppColors.lightGreen,
                          height: 10,
                          width: 10,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Chat",
                      style: TextStyle(color: AppColors.green, fontSize: 9),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _goToChatDetail(
      BuildContext context, DiscoveredUserData discoveredUser) {
    context.read<ConnectionsBloc>().add(AddConnectionEvent(
          user: context.read<ProfileBloc>().state.userProfile,
          otherUser: AddConnectionData(
            avatar: discoveredUser.avatar,
            id: discoveredUser.id,
            name: discoveredUser.name,
            uid: discoveredUser.uid,
            selectedInterest: discoveredUser.getSelectedInterestDescription(),
            gender: discoveredUser.gender,
          ),
        ));
  }
}
