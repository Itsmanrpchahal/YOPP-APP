import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';
import 'package:yopp/modules/_common/ui/version.dart';
import 'package:yopp/modules/authentication/bloc/authenication_state.dart';
import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
import 'package:yopp/modules/authentication/bloc/authentication_event.dart';
import 'package:yopp/modules/bottom_navigation/activity/activity_screen.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_bloc.dart';
import 'package:yopp/modules/bottom_navigation/bloc/bottom_nav_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_state.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';
import 'package:yopp/modules/screens.dart';
import 'package:yopp/widgets/icons/circular_profile_icon.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

Widget buildDrawerListItem({
  @required BuildContext context,
  @required String name,
  @required String imageName,
  @required Function onTap,
}) {
  return ListTile(
    contentPadding: EdgeInsets.only(left: 32),
    leading: Image.asset(
      'assets/icons/' + imageName + ".png",
      fit: BoxFit.scaleDown,
      height: 24,
      width: 14,
    ),
    title: Transform.translate(
      offset: Offset(-30, 0),
      child: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
    ),
    onTap: onTap,
  );
}

buildDrawer(BuildContext context) {
  return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
    final name = state.userProfile?.name?.toUpperCase() ?? "";
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        print("Log Out");
        print(state.status);
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
            ProgressHud.of(context).dismiss();
            break;
        }
      },
      child: Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: AppColors.lightGreen,
          child: Column(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: <Widget>[
                  DrawerHeader(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProfileIcon(
                              imageUrl: state?.userProfile?.avatar ?? "",
                              gender:
                                  state?.userProfile?.gender ?? Gender.male),
                          SizedBox(height: 24),
                          Text(
                            name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreen,
                    ),
                  ),
                  buildDrawerListItem(
                      context: context,
                      imageName: "account",
                      name: "ACCOUNT",
                      onTap: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<BottomNavBloc>(context)
                            .add(BottomNavEvent(
                          navOption: BottomNavOption.profile,
                          tabOption: TabBarOption.first,
                        ));
                      }),
                  // buildDrawerListItem(
                  //     context: context,
                  //     imageName: "wallet",
                  //     name: "PREMIUM",
                  //     onTap: () {}),
                  buildDrawerListItem(
                      context: context,
                      imageName: "notification",
                      name: "NOTIFICATIONS",
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(ActivityScreen.routeName);
                      }),
                  buildDrawerListItem(
                      context: context,
                      imageName: "connection",
                      name: "CONNECTIONS",
                      onTap: () {
                        Navigator.of(context).pop();
                        BlocProvider.of<BottomNavBloc>(context)
                            .add(BottomNavEvent(
                          navOption: BottomNavOption.connections,
                          tabOption: TabBarOption.third,
                        ));
                      }),
                  buildDrawerListItem(
                      context: context,
                      imageName: "settings",
                      name: "SETTINGS",
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(SettingsScreen.routeName);
                      }),
                  buildDrawerListItem(
                      context: context,
                      imageName: "logout",
                      name: "LOG OUT",
                      onTap: () {
                        BlocProvider.of<AuthBloc>(context, listen: false)
                            .add(AuthLogoutRequestedEvent());
                      }),
                ],
              ),
              Spacer(),
              VersionText(
                color: Colors.white,
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  });
}
