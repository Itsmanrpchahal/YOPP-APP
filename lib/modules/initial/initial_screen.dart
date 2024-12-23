import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_color/app_colors.dart';

import 'package:yopp/modules/authentication/bloc/authenication_state.dart';
import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
import 'package:yopp/modules/authentication/bloc/authentication_event.dart';

import 'package:yopp/modules/initial/splash_screen.dart';

import 'package:yopp/modules/screens.dart';
import 'package:yopp/widgets/body/full_gradient_scaffold.dart';
import 'package:yopp/widgets/buttons/rounded_button.dart';
import 'package:yopp/widgets/progress_hud/progress_hud.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget initalScreen;
    return ProgressHud(
        child: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
      print(state.status);
      print(state.message);
      switch (state.status) {
        case AuthStatus.checking:
          initalScreen = SplashSceen();
          break;

        case AuthStatus.unauthenticated:
          initalScreen = OnboardingScreens();
          break;

        case AuthStatus.optPending:
          initalScreen = OtpScreen(
              countryCode: state.user.countryCode,
              phoneNumber: state.user.phone);
          break;

        case AuthStatus.genderPending:
          initalScreen = GenderSelectScreen();
          break;

        case AuthStatus.locationPending:
          initalScreen = EnableLocationScreen();
          break;

        case AuthStatus.birthYearPending:
          print("Check:BirthYear from Initial Screen from Auth");
          initalScreen = SelectYearScreen();
          break;

        case AuthStatus.abilityPending:
          initalScreen = new BottomNavigationScreen(
            userProfile: state.user,
            interests: state.interestList,
          );
          break;

        case AuthStatus.profilePending:
          initalScreen = new BottomNavigationScreen(
            userProfile: state.user,
            interests: state.interestList,
          );

          break;

        case AuthStatus.authenticated:
          initalScreen = new BottomNavigationScreen(
            userProfile: state.user,
            interests: state.interestList,
          );
          break;

        case AuthStatus.error:
          initalScreen = AuthCheckingErrorWidget(title: state.message);
          break;

        case AuthStatus.updating:
          break;
      }

      return initalScreen;
    }, listener: (context, state) async {
      ProgressHud.of(context).dismiss();
      switch (state.status) {
        case AuthStatus.checking:
          break;

        case AuthStatus.unauthenticated:
          break;

        case AuthStatus.optPending:
          break;

        case AuthStatus.genderPending:
          break;

        case AuthStatus.locationPending:
          break;

        case AuthStatus.birthYearPending:
          break;

        case AuthStatus.abilityPending:
          break;

        case AuthStatus.profilePending:
          break;

        case AuthStatus.authenticated:
          break;

        case AuthStatus.error:
          await ProgressHud.of(context)
              .showErrorAndDismiss(text: state.message);

          break;

        case AuthStatus.updating:
          break;
      }
    }));
  }
}

class AuthCheckingErrorWidget extends StatelessWidget {
  final String title;
  const AuthCheckingErrorWidget({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FullGradientScaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.all(30),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 16,
            ),
            RaisedRoundedButton(
                titleText: "Try Again",
                titleStyle: TextStyle(color: Colors.white),
                backgroundColor: AppColors.green,
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context, listen: false)
                      .add(AuthStatusRequestedEvent());
                }),
            RaisedRoundedButton(
                titleText: "Cancel",
                titleStyle: TextStyle(color: Colors.white),
                backgroundColor: AppColors.orange,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  BlocProvider.of<AuthBloc>(context, listen: false)
                      .add(AuthStatusRequestedEvent());
                }),
          ],
        ),
      ),
    ));
  }
}
