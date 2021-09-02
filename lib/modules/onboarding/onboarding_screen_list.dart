import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../screens.dart';
import 'onboarding_model.dart';
import 'onboarding_screen.dart';

class OnboardingScreens extends StatefulWidget {
  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final List<OnboardingModel> model = [
    OnboardingModel("onboarding0", "Find Your Local Practise Partner",
        ["Looking for a practise partner?", " Find yours now!"]),
    OnboardingModel("onboarding1", "Compatible Experience Levels", [
      "Looking for someone to practise with? Find different experience levels right for you."
    ]),
    OnboardingModel("onboarding2", "Easily Meet & Practise", [
      "Discover, Chat, Meet & Practise What You Love.",
      " It’s as easy as that!"
    ]),
  ];

  int _currentScreen = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final inAnimation =
            Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                .animate(animation);
        final outAnimation =
            Tween<Offset>(begin: Offset(-0.5, 0.0), end: Offset(0.0, 0.0))
                .animate(animation);

        if (child.key == ValueKey(_currentScreen.toString())) {
          return SlideTransition(
            position: inAnimation,
            child: child,
          );
        } else {
          return SlideTransition(
            position: outAnimation,
            child: child,
          );
        }
      },
      child: OnBoardingScreen(
        key: Key(_currentScreen.toString()),
        index: _currentScreen,
        assetName:
            "assets/onboarding/" + model[_currentScreen].fileName + ".png",
        title: model[_currentScreen].title,
        descriptions: model[_currentScreen].descriptions,
        onNext: () => showNextScreen(),
        onSkip: () => _goToAuthScreen(),
      ),
    );
  }

  void showNextScreen() {
    if (_currentScreen < model.length - 1) {
      setState(() {
        _currentScreen += 1;
      });
    } else {
      _goToAuthScreen();
    }
  }

  void _goToAuthScreen() {
    Navigator.of(context).pushNamed(AuthScreen.routeName);
  }
}
