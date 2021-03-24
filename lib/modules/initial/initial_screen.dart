import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
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
            initalScreen = SelectActivityScreen(
                isInitialSetupScreen: SelectAbilityEnum.initialSetup);
            break;

          case AuthStatus.profilePending:
            initalScreen = EditProfileScreen(
              isInitialSetupScreen: true,
              profile: state.user,
            );
            break;

          case AuthStatus.authenticated:
            initalScreen = BottomNavigationScreen(
              userProfile: state.user,
            );
            break;

          case AuthStatus.error:
            initalScreen = AuthCheckingErrorWidget(
              title: state.message,
            );
            break;

          case AuthStatus.updating:
            break;
        }

        return initalScreen;
      }),
    );
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
            Text(title),
            RaisedRoundedButton(
                titleText: "Try Again",
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(AuthStatusRequestedEvent());
                })
          ],
        ),
      ),
    ));
  }
}
