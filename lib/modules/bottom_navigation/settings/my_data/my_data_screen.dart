import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yopp/helper/app_color/color_helper.dart';
import 'package:yopp/modules/authentication/bloc/authenication_state.dart';
import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
import 'package:yopp/modules/authentication/bloc/authentication_event.dart';
import 'package:yopp/modules/bottom_navigation/settings/my_data/delete_account_screen.dart';
import 'package:yopp/routing/transitions.dart';

import 'package:yopp/widgets/app_bar/transparent_appbar_with_cross.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/buttons/gradient_check_button.dart';
import 'package:yopp/widgets/buttons/rounded_button.dart';
import 'package:yopp/widgets/custom_clipper/half_curve_clipper.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class MyDataScreen extends StatelessWidget {
  static Route get route {
    return FadeRoute(
      builder: (context) => MyDataScreen(),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Data",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 36),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: _buildBodyDetail(context)),
                ),
                SizedBox(height: 16),
              ],
            )),
      ),
    );
  }

  Widget _buildBodyDetail(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 30, bottom: 30, left: 0, right: 0),
      children: [
        Center(
          child: GradientCircleButton(
            onPressed: () {},
            icon: Icons.pause,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 32, bottom: 16),
          child: Text(
            "PAUSE MY ACCOUNT",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Hexcolor("##212121").withOpacity(0.77)),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 32, bottom: 16),
          child: Text(
            "Need a break? If you’d like to keep you account but not be shown to others. Please pause your account instead. You can can come back Anytime and turn this off in the settings.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Hexcolor("#757575").withOpacity(0.77),
            ),
          ),
        ),
        SizedBox(height: 30),
        GradientButton(
          child: Text(
            "PAUSE MY ACCOUNT",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => _pauseAccount(context),
        ),
        SizedBox(height: 30),
        RaisedRoundedButton(
          titleText: "LOGOUT",
          onPressed: () => _logOut(context),
        ),
        SizedBox(height: 30),
        Center(
          child: Image.asset(
            'assets/icons/appIcon.png',
            height: 100,
            width: 100,
            colorBlendMode: BlendMode.lighten,
          ),
        ),
        Center(
          child: Text(
            "Version 1.0.3",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        FlatButton(
            onPressed: () => _showDeleteAccount(context),
            child: Text(
              "Delete My Account",
              style: TextStyle(color: Hexcolor("#E0DDDD")),
            )),
      ],
    );
  }

  void _pauseAccount(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(PauseAccountRequestedEvent());
  }

  void _showDeleteAccount(BuildContext context) {
    Navigator.of(context).push(DeleteAccountScreen.route);
  }

  void _logOut(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(AuthLogoutRequestedEvent());
  }
}
