import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/bottom_navigation/activity/activity_screen.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_bloc.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_event.dart';
import 'package:yopp/modules/bottom_navigation/filter/filter_dialog.dart';

import 'package:yopp/modules/bottom_navigation/profile/pages/about/about_page.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connections_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/connections_page.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/search_page.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/state.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';
import 'package:yopp/widgets/buttons/circle_icon_button.dart';
import 'package:yopp/widgets/buttons/error_and_retry_widget.dart';

import 'package:yopp/widgets/icons/profile_icon.dart';
import 'package:yopp/widgets/image/image_picker_service.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';
import 'pages/about/name_bottom_sheet.dart';
import 'pages/connections/bloc/connection_event.dart';

class ProfileScreen extends StatefulWidget {
  static Route route({
    Key key,
    @required String userId,
    @required TabController profileTabController,
  }) {
    return FadeRoute(
        builder: (_) => ProfileScreen(
              key: key,
              userId: userId,
              profileTabController: profileTabController,
            ));
  }

  ProfileScreen({
    Key key,
    @required this.userId,
    @required this.profileTabController,
  }) : super(key: key);
  final String userId;

  final TabController profileTabController;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool showWelcomeDialog = true;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    print("profile init");

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkForUserUpdate(BuildContext context) {
    if (widget.profileTabController.index == 0) {
      print("checkForUserUpdate");
      BlocProvider.of<ProfileBloc>(context, listen: false)
          .add(LoadUserProfileEvent(userId: widget.userId));
    }
  }

  void checkForConnectionUpdate(BuildContext context) {
    if (widget.profileTabController.index == 2) {
      print("refresh Connection");
      context.read<ConnectionsBloc>().add(LoadConnectionEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ProgressHud(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: new MenuAppBar(
            context: context,
            titleText: "Profile",
          ),
          body: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    final toolBarSectionHeight = (MediaQuery.of(context).size.height / 3);
    final tabBarHeight = 70.0;

    return BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) async {
      print(state.status);
      ProgressHud.of(context)?.dismiss();
      switch (state.status) {
        case ProfileServiceStatus.none:
          break;
        case ProfileServiceStatus.loading:
          ProgressHud.of(context)?.showLoading(text: state.message);
          break;
        case ProfileServiceStatus.loaded:
          break;
        case ProfileServiceStatus.updating:
          ProgressHud.of(context).showLoading(text: state.message);
          break;
        case ProfileServiceStatus.updated:
          await ProgressHud.of(context)
              ?.showSuccessAndDismiss(text: state.message);
          break;
        case ProfileServiceStatus.deleting:
          ProgressHud.of(context)?.showLoading(text: state.message);
          break;
        case ProfileServiceStatus.deleted:
          await ProgressHud.of(context)
              ?.showSuccessAndDismiss(text: state.message);
          break;
        case ProfileServiceStatus.loadingFailed:
          await ProgressHud.of(context)
              ?.showErrorAndDismiss(text: state.message);
          break;
        case ProfileServiceStatus.updateFailed:
          await ProgressHud.of(context)
              ?.showErrorAndDismiss(text: state.message);
          break;
        case ProfileServiceStatus.deleteFailed:
          await ProgressHud.of(context)
              ?.showErrorAndDismiss(text: state.message);
          break;
        case ProfileServiceStatus.updatedAndAddSportPending:
          await ProgressHud.of(context)
              ?.showSuccessAndDismiss(text: state.message);
          break;
      }
    }, builder: (context, state) {
      if (state.status == ProfileServiceStatus.loadingFailed) {
        return RetryWidget(
          onRetry: () => checkForUserUpdate(context),
        );
      }
      return NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, value) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                floating: false,
                shadowColor: Colors.black12,
                toolbarHeight: 0,
                expandedHeight: 0,
                bottom: PreferredSize(
                  preferredSize: Size(
                      double.infinity, tabBarHeight + toolBarSectionHeight),
                  child: Container(
                    height: toolBarSectionHeight + tabBarHeight,
                    padding: EdgeInsets.zero,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        _buildProfileImageSection(context,
                            height: toolBarSectionHeight,
                            imageUrl: state.userProfile?.avatar,
                            gender: state.userProfile?.gender,
                            name: state?.userProfile?.name,
                            subtitle:
                                "PLAYS ${state?.userProfile?.interests?.length ?? 0} SPORTS"),
                        _buildTabBar(
                            context: context,
                            tabHeight: tabBarHeight,
                            userHeight: state.userProfile?.height?.toInt(),
                            connectionCount: state?.connectionCount ?? 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: widget.profileTabController,
          children: [
            AboutPage(
              onPullToRefresh: () {
                checkForUserUpdate(context);
              },
            ),
            SearchPage(),
            ConnectionsPage(
              onPullToRefresh: () {
                checkForConnectionUpdate(context);
              },
            ),
          ],
        ),
      );
    });
  }

  _addNewInterest(BuildContext context) async {
    final availableInterest =
        BlocProvider.of<ProfileBloc>(context, listen: false)
            .state
            .interestOptions;

    final interestToBeUpdate = await InterestDialog.show(
      context,
      availableInterests: availableInterest,
      interest: null,
    );

    if (interestToBeUpdate != null) {
      context
          .read<ProfileBloc>()
          .add(AddNewInterestEvent(interest: interestToBeUpdate));
    }
  }

  _choosePhoto(BuildContext context) async {
    final uncroppedImageFile = await ImagePickerService.getImage(context);
    if (uncroppedImageFile == null) {
      return;
    }

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: uncroppedImageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      setState(() {
        BlocProvider.of<ProfileBloc>(context).add(
            UpdateUserProfileEvent(profile: UserProfile(), image: croppedFile));
      });
    }
  }

  _buildProfileImageSection(BuildContext context,
      {String imageUrl,
      String name,
      Gender gender,
      String subtitle,
      double height = 200}) {
    return InkWell(
      onTap: () {
        _choosePhoto(context);
      },
      child: Container(
        height: height,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: height,
              child: Hero(
                tag: "ProfileAvatar",
                child: ProfileIcon(
                  imageUrl: imageUrl,
                  gender: gender,
                ),
              ),
            ),
            Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.transparent]),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      NameBottomSheet.show(context, name);
                    },
                    child: Text(name ?? "Add Name",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                  ),
                  SizedBox(height: 8),
                  Text(subtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 16),
                child: CircleIconButton(
                  radius: 22,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(ActivityScreen.routeName),
                  icon: SvgPicture.asset(
                    "assets/icons/notification.svg",
                    color: AppColors.green,
                    fit: BoxFit.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTabBar(
      {BuildContext context,
      double tabHeight,
      int userHeight,
      int connectionCount = 0}) {
    return Container(
      height: tabHeight,
      child: TabBar(
        controller: widget.profileTabController,
        onTap: (index) {
          print(index);
          if (index == 2) {
            context
                .read<BottomNavBloc>()
                .add(BottomNavEvent(navOption: BottomNavOption.connections));
          } else {
            context
                .read<BottomNavBloc>()
                .add(BottomNavEvent(navOption: BottomNavOption.profile));
          }

          print(index);
        },
        indicatorWeight: 1,
        tabs: [
          Container(
            height: tabHeight,
            padding: EdgeInsets.only(top: 10, bottom: 0),
            child: Tab(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Text(
                  userHeight == null ? "" : userHeight.toString() + "cm",
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 18,
                  ),
                )),
                Expanded(
                  child: Text(
                    "ABOUT",
                    style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            )),
          ),
          Container(
            height: tabHeight,
            padding: EdgeInsets.only(top: 10, bottom: 0),
            child: Tab(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: BlocBuilder<SearchRangeBloc, SearchRangeState>(
                        builder: (context, state) {
                      return Text(
                        state.searchRanges.elementAt(state.selectedId).name,
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }),
                  ),

                  //
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      "Search",
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
          Container(
            height: tabHeight,
            padding: EdgeInsets.only(top: 10, bottom: 0),
            child: Tab(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Container(
                  child: Text(
                    connectionCount.toString(),
                    style: TextStyle(
                      color: AppColors.green,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
                Expanded(
                  child: Container(
                    child: Text(
                      "Connections",
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
