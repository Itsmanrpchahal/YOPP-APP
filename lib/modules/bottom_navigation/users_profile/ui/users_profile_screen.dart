import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/api_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_state.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/about/ability_listview.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_state.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connections_bloc.dart';

import 'package:yopp/modules/bottom_navigation/users_profile/bloc/user_profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/users_profile/bloc/user_profile_state.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';
import 'package:yopp/widgets/buttons/circle_icon_button.dart';
import 'package:yopp/widgets/buttons/error_and_retry_widget.dart';

import 'package:yopp/widgets/icons/profile_icon.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class UserProfileScreen extends StatefulWidget {
  static Route route({
    Key key,
    @required String userId,
    UserProfile userProfile,
  }) {
    return FadeRoute(
      builder: (_) => BlocProvider<UserProfileBloc>(
        create: (BuildContext context) => UserProfileBloc(
          APIProfileService(),
        ),
        child: UserProfileScreen(
          userId: userId,
          userProfile: userProfile,
        ),
      ),
    );
  }

  UserProfileScreen({
    Key key,
    @required this.userId,
    this.userProfile,
    this.selectedSportName,
  }) : super(key: key);

  final String userId;
  final UserProfile userProfile;
  final String selectedSportName;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfile profile;

  @override
  void initState() {
    profile = widget.userProfile;

    checkForUserUpdate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkForUserUpdate() {
    BlocProvider.of<UserProfileBloc>(context, listen: false)
        .add(LoadUserProfileEvent(userId: widget.userId));
  }

  void setupChat(BuildContext context) {
    final currentUser = context.read<ProfileBloc>().state.userProfile;
    context.read<ConnectionsBloc>().add(AddConnectionEvent(
          otherUser: AddConnectionData(
            avatar: profile.avatar,
            id: profile.id,
            name: profile.name,
            uid: profile.uid,
            selectedInterest: profile.getSelectedInterestDescription(),
            gender: profile.gender,
          ),
          user: currentUser,
        ));
  }

  @override
  Widget build(BuildContext context) {
    print("user_profile_screen_build");
    return ProgressHud(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: new DefaultAppBar(
          context: context,
          titleText: "Profile",
        ),
        body: MultiBlocListener(
            listeners: [
              BlocListener<ConnectionsBloc, ConnectionsState>(
                listener: (context, state) async {
                  print("bottomNav:");
                  print(state.serviceStatus);
                  ProgressHud.of(context).dismiss();
                  switch (state.serviceStatus) {
                    case ConnectionServiceStatus.initial:
                      break;

                    case ConnectionServiceStatus.creatingConnection:
                      ProgressHud.of(context).showLoading(text: state.message);
                      break;

                    case ConnectionServiceStatus.readyForChat:
                      break;

                    case ConnectionServiceStatus.connectionFailed:
                      await ProgressHud.of(context)
                          .showErrorAndDismiss(text: state.message);
                      break;

                    case ConnectionServiceStatus.loading:
                      break;
                    case ConnectionServiceStatus.loaded:
                      break;
                    case ConnectionServiceStatus.loadingFailed:
                      break;
                    case ConnectionServiceStatus.loadingMore:
                      break;

                    case ConnectionServiceStatus.loadedMore:
                      break;

                    case ConnectionServiceStatus.loadingMoreFailed:
                      break;

                    case ConnectionServiceStatus.deleting:
                      break;
                    case ConnectionServiceStatus.deleted:
                      break;
                    case ConnectionServiceStatus.deletingFailed:
                      break;
                  }
                },
              ),
              BlocListener<UserProfileBloc, UserProfileState>(
                listener: (context, state) async {
                  ProgressHud.of(context).dismiss();
                  switch (state.status) {
                    case ProfileServiceStatus.none:
                      break;
                    case ProfileServiceStatus.loading:
                      ProgressHud.of(context)
                          .show(ProgressHudType.loading, state.message);
                      break;
                    case ProfileServiceStatus.loadingFailed:
                      await ProgressHud.of(context)
                          .showAndDismiss(ProgressHudType.error, state.message);
                      break;
                    case ProfileServiceStatus.loaded:
                      if (mounted) {
                        setState(() {
                          profile = state.userProfile;
                        });
                      }
                      break;
                    case ProfileServiceStatus.updating:
                      break;
                    case ProfileServiceStatus.updated:
                      break;
                    case ProfileServiceStatus.deleting:
                      break;
                    case ProfileServiceStatus.deleted:
                      break;
                    case ProfileServiceStatus.updateFailed:
                      break;
                    case ProfileServiceStatus.deleteFailed:
                      break;
                    case ProfileServiceStatus.updatedAndAddSportPending:
                      break;
                  }
                },
              ),
            ],
            child: profile != null
                ? _buildBody(context)
                : RetryWidget(
                    onRetry: () => checkForUserUpdate(),
                  )),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildProfileImageSection(context,
            imageUrl: profile?.avatar,
            name: profile?.name,
            gender: profile?.gender,
            subtitle: "PLAYS ${profile?.interests?.length ?? 0} SPORTS",
            height: MediaQuery.of(context).size.height / 3),
        Expanded(child: _buildInfoSection(context, profile)),
        Container(
          padding: EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 16),
          child: FlatButton(
            height: 50,
            onPressed: () => setupChat(context),
            color: AppColors.lightGreen,
            child: Text(
              "Start Chatting",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  _buildProfileImageSection(
    BuildContext context, {
    String imageUrl,
    String name,
    Gender gender,
    String subtitle,
    double height = 200,
  }) {
    return Container(
      height: height,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: height,
            child: Hero(
              tag: widget.userId,
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
                Text(name ?? "Add Name",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
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
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleIconButton(
                        radius: 20,
                        onPressed: () => setupChat(context),
                        icon: Center(
                          child: SvgPicture.asset(
                            "assets/icons/chat.svg",
                            color: AppColors.green,
                            fit: BoxFit.scaleDown,
                            height: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Chat",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  _buildProfileRow({
    @required int height,
    @required int age,
    @required Interest selectedInterest,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              height == null
                  ? _buildTitleTextWidget("")
                  : _buildTitleTextWidget(height.toString() + " cm"),
              SizedBox(height: 4),
              _buildSubtitleTextWidget("Height"),
            ],
          ),
          Column(
            children: [
              age == null
                  ? _buildTitleTextWidget("")
                  : _buildTitleTextWidget(age.toString()),
              SizedBox(height: 4),
              _buildSubtitleTextWidget("Age"),
            ],
          ),
          Column(
            children: [
              selectedInterest == null
                  ? _buildTitleTextWidget("")
                  : _buildTitleTextWidget(selectedInterest?.skill?.name ?? ""),
              SizedBox(height: 4),
              _buildSubtitleTextWidget("Skill Level"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitySection(
    BuildContext context,
    List<Interest> interests,
    Interest selectedInterest,
  ) {
    return Container(
      child: AbilityListView(
        editable: false,
        interests: interests ?? [],
        selectedInterest: selectedInterest,
        onAddingNewSport: () {},
      ),
    );
  }

  _buildSubtitleTextWidget(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.green,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  _buildTitleTextWidget(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.green,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, UserProfile profile) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            profile?.about ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.normal,
            ),
          ),
          _buildProfileRow(
              height: profile?.height,
              age: profile?.age,
              selectedInterest: profile?.selectedInterest),
          _buildAbilitySection(
              context, profile.interests, profile?.selectedInterest),
        ],
      ),
    );
  }
}
