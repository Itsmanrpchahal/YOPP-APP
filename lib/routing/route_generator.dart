import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/acitvity_service.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity_bloc.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_service.dart';
import 'package:yopp/modules/initial/initial_screen.dart';
import 'package:yopp/routing/transitions.dart';
import '../modules/screens.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return FadeRoute(builder: (_) => InitialScreen());

      case AuthScreen.routeName:
        return FadeRoute(builder: (_) => AuthScreen());

      case RegisterScreen.routeName:
        return FadeRoute(builder: (_) => RegisterScreen());

      case ForgetPasswordScreen.routeName:
        return FadeRoute(builder: (_) => ForgetPasswordScreen());

      case GenderSelectScreen.routeName:
        return FadeRoute(builder: (_) => GenderSelectScreen());

      case SelectYearScreen.routeName:
        return FadeRoute(builder: (_) => SelectYearScreen());

      case ActivityScreen.routeName:
        return FadeRoute(
          builder: (_) => BlocProvider<ActivityBloc>(
            create: (BuildContext context) => ActivityBloc(
                service: FirebaseActivityService(),
                chatService: FirebaseChatService()),
            child: ActivityScreen(),
          ),
        );

      // case SelectCategoryScreen.routeName:
      //   return FadeRoute(builder: (_) => SelectCategoryScreen());

      //  case SelectAbilityScreen.routeName:
      //   return FadeRoute(builder: (_) => SelectAbilityScreen());
      case SetupCompleteScreen.routeName:
        return FadeRoute(builder: (_) => SetupCompleteScreen());

      // case BottomNavigationScreen.routeName:
      //   return FadeRoute(builder: (_) => BottomNavigationScreen());

      case SettingsScreen.routeName:
        return FadeRoute(builder: (_) => SettingsScreen());

      // case ChatDetailScreen.routeName:
      //   return FadeRoute(builder: (_) => ChatDetailScreen());

      case PreferenceSettingScreen.routeName:
        return FadeRoute(builder: (_) => PreferenceSettingScreen());

      default:
        return FadeRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('No route defined for ${settings.name}'),
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("GO BACK"))
                    ]),
                  ),
                ));
    }
  }
}
