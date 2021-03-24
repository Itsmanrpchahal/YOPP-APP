import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_bloc.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_event.dart';

import 'package:yopp/modules/bottom_navigation/profile/ability_listview.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_state.dart';
import 'package:yopp/modules/bottom_navigation/bottom_nav_page.dart';

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

import 'package:yopp/modules/screens.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/body/gradient_scaffold.dart';

import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
import 'package:yopp/widgets/icons/profile_icon.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import '../bottom_nav_appBar.dart';
import 'bloc/ability_list_bloc.dart';
import 'bloc/ability_list_event.dart';
import 'bloc/ablitiy_list_state.dart';
import 'bloc/profile_event.dart';

class ProfileScreen extends StatefulWidget {
  static Route route({
    Key key,
    @required String userId,
    @required UserProfile profile,
  }) {
    return FadeRoute(
        builder: (_) => ProfileScreen(
              key: key,
              userId: userId,
              profile: profile,
            ));
  }

  ProfileScreen({
    Key key,
    @required this.userId,
    @required this.profile,
  }) : super(key: key);
  final String userId;
  final UserProfile profile;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  UserProfile profile;
  List<UserSport> sports = [];

  @override
  void initState() {
    print("profile");

    checkForSportsUpdate(context);
    if (widget.profile != null) {
      profile = widget.profile;
    }
    checkForUserUpdate(context);

    super.initState();
  }

  void checkForUserUpdate(BuildContext context) {
    print("checkForUserUpdate");
    BlocProvider.of<ProfileBloc>(context)
        .add(GetUserProfile(userId: widget.userId));
  }

  void checkForSportsUpdate(BuildContext context) {
    print("checkForSportsUpdate");
    BlocProvider.of<AbilityListBloc>(context)
        .add(GetAbilityListEvent(userId: widget.userId));
  }

  void requestDiscoverUser() {
    print("requestDiscoverUser");
    BlocProvider.of<DiscoverBloc>(context).add(DiscoverUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BottomNavPage(
      enableGradient: false,
      child: ProfileScaffold(
        titleText: "My Profile",
        ratio: 0.5,
        appBar: BottomNavAppBar(
          context: context,
        ),
        firstHalfBackground: _buildImage(context),
        firstHalf: Container(
          height: double.infinity,
        ),
        secondHalf: _buildSecondHalfSection(context),
      ),
    );
  }

  _buildImage(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 60),
      child: Hero(
        tag: "ProfileAvatar",
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
          Expanded(
            child: _buildInfoSection(context),
          ),
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
        child: BlocListener<AbilityListBloc, AbilityListState>(
            child: AbilityListView(
              sports: sports ?? [],
              selectedSport: profile?.selectedSport?.name ?? "",
              onAddingNewSport: () {},
            ),
            listener: (context, state) {
              print("Profile ablitity:" + state.status.toString());
              switch (state.status) {
                case AbilityListStatus.none:
                  break;
                case AbilityListStatus.loading:
                  break;
                case AbilityListStatus.loaded:
                  if (mounted) {
                    setState(() {
                      sports = state.sports;
                    });
                  }
                  break;
                case AbilityListStatus.deleting:
                  break;
                case AbilityListStatus.deleted:
                  checkForSportsUpdate(context);
                  break;

                case AbilityListStatus.failure:
                  break;
                case AbilityListStatus.selecting:
                  break;
                case AbilityListStatus.selected:
                  checkForUserUpdate(context);

                  break;
              }
            }),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) async {
          print("Profile :" + state.status.toString());
          ProgressHud.of(context).dismiss();
          switch (state.status) {
            case ProfileServiceStatus.initial:
              break;
            case ProfileServiceStatus.loading:
              ProgressHud.of(context)
                  .show(ProgressHudType.loading, state.message);
              break;
            case ProfileServiceStatus.failure:
              await ProgressHud.of(context)
                  .showAndDismiss(ProgressHudType.error, state.message);
              break;
            case ProfileServiceStatus.loaded:
              if (mounted) {
                setState(() {
                  profile = state.userProfile;
                });
              }
              requestDiscoverUser();

              break;
          }
        },
        child: profile == null
            ? Container()
            : Container(
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
                                        text: (profile?.age?.toString() ?? ""),
                                      ),
                                    ]),
                              ),
                              SizedBox(height: 8),
                              profile.address == null
                                  ? Container()
                                  : Text(
                                      (profile?.address?.subAdminArea ?? "") +
                                          ", " +
                                          (profile?.address?.adminArea ?? "") +
                                          ", " +
                                          (profile?.address?.countryName ?? ""),
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              profile?.selectedSport?.heightRequired == false
                                  ? Container()
                                  : Column(
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Height - ${profile?.height?.toInt()} cm",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                              profile?.selectedSport?.skillLevel == null
                                  ? Container()
                                  : Column(
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Skill Level - ${profile.selectedSport.skillLevel.name}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                              profile?.selectedSport?.weightRequired == false
                                  ? Container()
                                  : Column(
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Weight - ${profile?.weight?.toInt()} kg",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                              profile?.selectedSport?.belt == null
                                  ? Container()
                                  : Column(
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Belt - ${profile.selectedSport.belt}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                              profile?.selectedSport?.handicap == null
                                  ? Container()
                                  : Column(
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "Handicap - ${profile.selectedSport.handicap}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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
                                Icons.edit,
                                size: 20,
                              ),
                            ),
                            onPressed: () => _showEditProfile(context))
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
                          : DefaultText.ABOUT_USER,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ));
  }

  _showEditProfile(BuildContext context) async {
    await Navigator.of(context).push(EditProfileScreen.route(profile, false));
  }
}
