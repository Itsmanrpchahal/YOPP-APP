import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/authentication/bloc/authentication_bloc.dart';
import 'package:yopp/modules/authentication/bloc/authentication_service.dart';

import 'package:yopp/modules/authentication/otp/bloc/otp_bloc.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_bloc.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_service.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_bloc.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_service.dart';
import 'package:yopp/modules/bottom_navigation/matched/bloc/matched_bloc.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_bloc.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/ability_list_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_bloc.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_service.dart';
import 'package:yopp/modules/initial_profile_setup/birth_year/bloc/birth_year_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/edit_profile_bloc.dart';

import 'package:yopp/modules/initial_profile_setup/select_ability/bloc/ability_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender_bloc.dart';

import 'package:yopp/routing/route_generator.dart';

import 'package:flutter/services.dart';
import 'package:yopp/widgets/keyboard_manager/keboard_manager.dart';
import 'package:firebase_core/firebase_core.dart';

import 'modules/authentication/bloc/authentication_bloc.dart';
import 'modules/authentication/bloc/authentication_event.dart';
import 'modules/authentication/forget_password/bloc/forget_bloc.dart';
import 'modules/bottom_navigation/chat/chatlist/bloc/chat_list_bloc.dart';
import 'modules/bottom_navigation/discover/bloc/discover_location_bloc.dart';
import 'modules/initial_profile_setup/edit_profile/bloc/firebase_profile_service.dart';

import 'package:flutter/foundation.dart' show kDebugMode;

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    // Handle Crashlytics enabled status when not in Debug,
    // e.g. allow your users to opt-in to crash reporting.
  }
// Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Restrict App to Potrait Mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(
                AuthService(),
                FirebaseProfileService(),
                FirebaseNotificationService(),
                SharedPreferenceService())
              ..add(AuthStatusRequestedEvent()),
          ),
          BlocProvider<RegisterBloc>(
              create: (BuildContext context) => RegisterBloc(
                    AuthService(),
                    FirebaseProfileService(),
                    SharedPreferenceService(),
                  )),
          BlocProvider<OtpBloc>(create: (BuildContext context) => OtpBloc()),
          BlocProvider<ForgotBloc>(
              create: (BuildContext context) => ForgotBloc(AuthService())),
          BlocProvider<GenderBloc>(
            create: (BuildContext context) => GenderBloc(
              FirebaseProfileService(),
            ),
          ),
          BlocProvider<BirthYearBloc>(
              create: (BuildContext context) =>
                  BirthYearBloc(FirebaseProfileService())),
          BlocProvider<EditAbilityBloc>(
              create: (BuildContext context) => EditAbilityBloc(
                  FirebaseProfileService(), SharedPreferenceService())),
          BlocProvider<ProfileBloc>(
              create: (BuildContext context) => ProfileBloc(
                    FirebaseProfileService(),
                    SharedPreferenceService(),
                  )),
          BlocProvider<EditProfileBloc>(
              create: (BuildContext context) =>
                  EditProfileBloc(FirebaseProfileService())),
          BlocProvider<DiscoverLocationBloc>(
              create: (BuildContext context) => DiscoverLocationBloc(
                  FirebaseProfileService(), SharedPreferenceService())),
          BlocProvider<AbilityListBloc>(
              create: (BuildContext context) => AbilityListBloc(
                    FirebaseProfileService(),
                    SharedPreferenceService(),
                  )),
          BlocProvider<DiscoverBloc>(
            create: (BuildContext context) => DiscoverBloc(
              ApiDiscoverService(),
              FirebaseProfileService(),
              SharedPreferenceService(),
            ),
          ),
          BlocProvider<MatchedBloc>(
              create: (BuildContext context) =>
                  MatchedBloc(FirebaseChatService())),
          BlocProvider<ChatHistoryBloc>(
              create: (BuildContext context) =>
                  ChatHistoryBloc(FirebaseChatService())),
          BlocProvider<PreferenceBloc>(
              create: (BuildContext context) =>
                  PreferenceBloc(SharedPreferenceService())),
        ],
        child: KeyboardManager(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            title: 'YOPP',
            theme: ThemeData(
              fontFamily: "Euphemia",
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: TextTheme(
                headline1: TextStyle(
                    fontSize: 113,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -1.5),
                headline2: TextStyle(
                    fontSize: 71,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.5),
                headline3: TextStyle(fontSize: 56, fontWeight: FontWeight.w700),
                headline4: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25),
                //title
                headline5: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                //navigation title
                headline6: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.15),
                subtitle1: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.15),
                subtitle2: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1),
                bodyText1: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5),
                bodyText2: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25),
                button: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.25),
                caption: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.4),
                overline: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5),
              ),
            ),
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        ));
  }
}
