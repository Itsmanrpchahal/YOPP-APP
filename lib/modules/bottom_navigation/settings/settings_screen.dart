import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/authentication/bloc/authenication_state.dart';
import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
import 'package:yopp/modules/authentication/bloc/authentication_event.dart';
import 'package:yopp/modules/bottom_navigation/settings/my_data/my_data_screen.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/notification_screen.dart';
import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/about_screen.dart';

import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/privacy_policy_screen.dart';

import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/terms_of_use_screen.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/firebase_profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/activity_suggestions_screen.dart';

import 'package:yopp/widgets/app_bar/transparent_appbar_with_cross.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

import '../../screens.dart';
import '../bottom_nav_appBar.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showSportSuggestions = false;

  @override
  void initState() {
    super.initState();

    FirebaseProfileService().getupdateProfile(null).then(
      (profile) {
        if (profile?.userType != null &&
            profile.userType.toLowerCase() == "admin") {
          setState(() {
            showSportSuggestions = true;
          });
        }
      },
    );
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
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            ProgressHud.of(context).dismiss();
            switch (state.status) {
              case AuthStatus.updating:
                ProgressHud.of(context)
                    .show(ProgressHudType.loading, state.message);
                break;
              case AuthStatus.unauthenticated:
                Navigator.of(context).popUntil((route) => route.isFirst);
                break;
              case AuthStatus.error:
                ProgressHud.of(context)
                    .showAndDismiss(ProgressHudType.error, state.message);
                break;
              default:
                break;
            }
          },
          child: _buildBody(context),
        ));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: ClipPath(
        clipper: HalfCurveClipper(),
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Hexcolor("#F2F2F2")),
            padding: EdgeInsets.only(left: 30, right: 30, top: 30),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Text(
                  "Settings",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 36),
                ),
                SizedBox(height: 20),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () => _showPreferenceScreen(context),
                  leading: CircleIconButton(
                    radius: 22,
                    onPressed: () => {},
                    icon: SvgPicture.asset(
                      "assets/icons/settings.svg",
                      color: AppColors.orange,
                      fit: BoxFit.none,
                    ),
                  ),
                  title: Text(
                    "Filter's search",
                    style: TextStyle(
                      color: Hexcolor("#222222"),
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ),
                Divider(indent: 75, thickness: 1),
                ListTile(
                  onTap: () =>
                      Navigator.of(context).push(NotificationScreen.route),
                  contentPadding: EdgeInsets.zero,
                  leading: CircleIconButton(
                    radius: 22,
                    onPressed: () => {},
                    icon: SvgPicture.asset(
                      "assets/icons/notification.svg",
                      color: AppColors.orange,
                      fit: BoxFit.none,
                    ),
                  ),
                  title: Text(
                    "Push Notifications",
                    style: TextStyle(
                        color: Hexcolor("#222222"),
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  // trailing: CupertinoSwitch(
                  //   onChanged: (value) {},
                  //   value: true,
                  // ),
                ),
                Divider(indent: 75, thickness: 1),
                ListTile(
                  onTap: () => _showActivityScreen(context),
                  contentPadding: EdgeInsets.zero,
                  leading: CircleIconButton(
                    radius: 22,
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/icons/activity.svg",
                      color: AppColors.orange,
                      fit: BoxFit.none,
                    ),
                  ),
                  title: Text(
                    "Notifications",
                    style: TextStyle(
                        color: Hexcolor("#222222"),
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ),
                Divider(indent: 75, thickness: 1),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    showSportSuggestions
                        ? InkWell(
                            onTap: () => _showSportSuggestion(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Sports Suggestions",
                                style: TextStyle(
                                    color: Hexcolor("#222222"),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                            ),
                          )
                        : Container(),
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).push(AboutScreen.route),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "About",
                          style: TextStyle(
                              color: Hexcolor("#222222"),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).push(PrivacyPolicyScreen.route),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                              color: Hexcolor("#222222"),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).push(TermsofUseScreen.route),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Terms of Use",
                          style: TextStyle(
                              color: Hexcolor("#222222"),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          Navigator.of(context).push(MyDataScreen.route),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "My Data",
                          style: TextStyle(
                              color: Hexcolor("#222222"),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _logOut(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                              color: Hexcolor("#222222"),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Version 1.0.3",
                          style: TextStyle(
                              color: Hexcolor("#AAAAAA"),
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  _showPreferenceScreen(BuildContext context) {
    Navigator.of(context).pushNamed(PreferenceSettingScreen.routeName);
  }

  _showActivityScreen(BuildContext context) {
    Navigator.of(context).pushNamed(ActivityScreen.routeName);
  }

  _logOut(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequestedEvent());
  }

  _showSportSuggestion(BuildContext context) {
    Navigator.of(context).push(ActivitySuggestionsScreen.route);
  }
}
