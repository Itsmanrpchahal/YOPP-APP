import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';

import 'package:yopp/modules/bottom_navigation/profile/ability_listview.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_state.dart';
import 'package:yopp/modules/bottom_navigation/users_profile/utility.dart';
import 'package:yopp/modules/bottom_navigation/users_profile/bloc/user_profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/users_profile/bloc/user_profile_state.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/firebase_profile_service.dart';

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/routing/transitions.dart';
import 'package:yopp/widgets/app_bar/transparent_appbar.dart';

import 'package:yopp/widgets/body/gradient_scaffold.dart';

import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
import 'package:yopp/widgets/icons/profile_icon.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class UserProfileScreen extends StatefulWidget {
  static Route route({
    Key key,
    @required String userId,
    UserProfile userProfile,
    @required String selectedSportName,
  }) {
    return FadeRoute(
      builder: (_) => BlocProvider<UserProfileBloc>(
        create: (BuildContext context) => UserProfileBloc(
            FirebaseProfileService(), SharedPreferenceService()),
        child: UserProfileScreen(
          userId: userId,
          userProfile: userProfile,
          selectedSportName: selectedSportName,
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
  UserSport selectedSport;

  String distance = "";
  List<UserSport> sports = [];

  @override
  void initState() {
    profile = widget.userProfile;

    checkForUserUpdate();
    super.initState();
  }

  void checkForUserUpdate() {
    BlocProvider.of<UserProfileBloc>(context)
        .add(GetUserProfile(userId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: ProfileScaffold(
          titleText: "My Profile",
          ratio: 0.5,
          appBar: TransparentAppBar(
            context: context,
          ),
          firstHalfBackground: _buildImage(context),
          firstHalf: Container(
            height: double.infinity,
          ),
          secondHalf: _buildSecondHalfSection(context)),
    );
  }

  _buildImage(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Hero(
        tag: widget.userId,
        child: ProfileIcon(
          imageUrl: profile?.avatar,
          gender: profile?.gender,
        ),
      ),
    );
  }

  _buildSecondHalfSection(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: _buildInfoSection(context)),
          _buildAbilitySection(context),
        ],
      ),
    );
  }

  Widget _buildAbilitySection(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 4;
    return ClipPath(
      clipper: HalfCurveClipper(),
      child: Container(
        height: height,
        child: AbilityListView(
          editable: false,
          sports: sports,
          selectedSport: widget?.selectedSportName ?? "",
          onAddingNewSport: null,
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          ProgressHud.of(context).dismiss();
          switch (state.status) {
            case ProfileServiceStatus.initial:
              break;
            case ProfileServiceStatus.loading:
              ProgressHud.of(context)
                  .show(ProgressHudType.loading, state.message);
              break;
            case ProfileServiceStatus.failure:
              ProgressHud.of(context)
                  .showAndDismiss(ProgressHudType.error, state.message);
              break;
            case ProfileServiceStatus.loaded:
              if (mounted) {
                final sportsFound = state.sports.where(
                    (element) => element.name == widget.selectedSportName);
                if (sportsFound != null && sportsFound.length > 0) {
                  print(sportsFound.length);
                  selectedSport = sportsFound.first;
                }

                setState(() {
                  profile = state.userProfile;
                  sports = state.sports;
                  distance = state.distance;
                });
              }

              break;
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.zero,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RichText(
                          text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              text: profile?.name != null
                                  ? profile.name + ", "
                                  : "",
                              children: [
                                TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  text: profile?.gender == Gender.male
                                      ? "M - "
                                      : "F - ",
                                ),
                                TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  text: profile?.age?.toString() ?? "",
                                ),
                              ]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          (distance ?? ""),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          getUserSkillLevel(
                            profile: profile,
                            selectedSport: selectedSport,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      iconSize: 50,
                      icon: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        child: Icon(
                          CupertinoIcons.chat_bubble_2_fill,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      onPressed: () => _goBackToChat(context))
                ],
              ),
              SizedBox(height: 8),
              Divider(
                color: Colors.white.withOpacity(0.3),
                thickness: 2,
              ),
              SizedBox(height: 8),
              Text(
                (profile?.about != null && profile.about.isNotEmpty)
                    ? profile?.about
                    : "",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ));
  }

  _goBackToChat(BuildContext context) {
    Navigator.of(context).pop();
  }
}
