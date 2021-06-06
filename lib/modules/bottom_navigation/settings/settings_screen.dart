import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/ui/version.dart';
import 'package:yopp/modules/authentication/bloc/authenication_state.dart';
import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_bloc.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_event.dart';
import 'package:yopp/modules/bottom_navigation/block_user/blocked_users_screen.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/settings/my_data/my_data_screen.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/notification_screen.dart';
import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/about_screen.dart';
import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/faq_page.dart';

import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/privacy_policy_screen.dart';

import 'package:yopp/modules/bottom_navigation/settings/settings_pages.dart/terms_of_use_screen.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/activity_suggestion_screen.dart';
import 'package:yopp/widgets/app_bar/default_app_bar.dart';

import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  String getPercentageComplete(BuildContext context) {
    int completedCount = 0;
    List<String> notCompleted = [];
    final user = context.watch<ProfileBloc>().state.userProfile;

    if (user?.avatar != null) {
      completedCount += 1;
    } else {
      notCompleted.add("Avatar");
    }

    if (user?.name != null) {
      completedCount += 1;
    } else {
      notCompleted.add("Name");
    }

    if (user?.about != null) {
      completedCount += 1;
    } else {
      notCompleted.add("About");
    }

    if (user?.height != null) {
      completedCount += 1;
    } else {
      notCompleted.add("Height");
    }

    if (user?.dob != null) {
      completedCount += 1;
    } else {
      notCompleted.add("DOB");
    }

    if (user?.selectedInterest != null) {
      completedCount += 1;
    } else {
      notCompleted.add("Sport");
    }

    final percentage = (completedCount * 100) / 6;
    return "${percentage.toInt()}% Completed";
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHud(
      child: Scaffold(
          extendBodyBehindAppBar: false,
          backgroundColor: Colors.white,
          appBar: new DefaultAppBar(context: context, titleText: "SETTINGS"),
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
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
                  await ProgressHud.of(context)
                      .showAndDismiss(ProgressHudType.error, state.message);
                  break;
                default:
                  break;
              }
            },
            child: _buildBody(context),
          )),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 30, right: 30, top: 30),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            _buildHeader("ACCOUNT"),
            _buildListTile(
                imageName: "phone",
                title: "PROFILE SETTINGS",
                subtitle: getPercentageComplete(context),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  context.read<BottomNavBloc>().add(BottomNavEvent(
                      navOption: BottomNavOption.profile,
                      tabOption: TabBarOption.first));
                }),
            _buildListTile(
              imageName: "lock",
              title: "MY DATA",
              subtitle: "",
              onTap: () => Navigator.of(context).push(MyDataScreen.route),
            ),
            _buildListTile(
                imageName: "notification",
                title: "PUSH NOTIFICATION",
                subtitle: "",
                onTap: () {
                  Navigator.of(context).push(NotificationScreen.route);
                }),
            Divider(thickness: 1),
            SizedBox(height: 16),
            _buildHeader("PRIVACY"),
            _buildListTile(
              imageName: "flag",
              title: "ABOUT",
              subtitle: "Info",
              onTap: () => Navigator.of(context).push(AboutScreen.route),
            ),
            _buildListTile(
              imageName: "flag",
              title: "PRIVACY POLICY",
              subtitle: "Info",
              onTap: () =>
                  Navigator.of(context).push(PrivacyPolicyScreen.route),
            ),
            _buildListTile(
              imageName: "flag",
              title: "TERMS OF USE",
              subtitle: "Info",
              onTap: () => Navigator.of(context).push(TermsofUseScreen.route),
            ),
            _buildListTile(
              imageName: "flag",
              title: "BLOCKED USERS",
              subtitle: "Manage",
              onTap: () =>
                  Navigator.of(context).push(BlockedUsersScreen.route()),
            ),
            Divider(thickness: 1),
            SizedBox(height: 16),
            _buildHeader("Support"),
            _buildListTile(
              imageName: "info",
              title: "FAQs",
              subtitle: "Have Questions?",
              onTap: () => Navigator.of(context).push(FaqPage.route),
            ),
            _buildListTile(
              imageName: "flag",
              title: "CONTACT",
              subtitle: "Contact Us",
              onTap: () => launchMailto(),
            ),
            _buildListTile(
              imageName: "flag",
              title: "REQUEST A SPORT",
              subtitle: "Sport Missing?",
              onTap: () =>
                  Navigator.of(context).push(ActivitySuggestionScreen.route),
            ),
            SizedBox(height: 16),
            VersionText(),
            SizedBox(height: 32),
          ],
        ));
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(color: AppColors.green, fontSize: 12),
      ),
    );
  }

  Widget _buildListTile({
    @required String imageName,
    @required String title,
    @required String subtitle,
    @required Function onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        'assets/icons/' + imageName + ".png",
        fit: BoxFit.scaleDown,
        color: AppColors.darkGrey,
        height: 14,
        width: 14,
      ),
      title: Transform.translate(
        offset: Offset(-30, -4),
        child: Text(
          title ?? "",
          maxLines: 2,
          style: TextStyle(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.w400,
              fontSize: 16),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subtitle ?? "",
            maxLines: 4,
            textAlign: TextAlign.right,
            style: TextStyle(
                color: AppColors.darkGrey,
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 16,
          )
        ],
      ),
      onTap: onTap,
    );
  }

  launchMailto() async {
    final mailtoLink = Mailto(
      to: ['info@yopp.com.au'],
      subject: 'Support',
      body: '',
    );
    // Convert the Mailto instance into a string.
    // Use either Dart's string interpolation
    // or the toString() method.
    await launch('$mailtoLink');
  }
}
