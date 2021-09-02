import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yopp/modules/authentication/bloc/authentication_service.dart';
import 'package:yopp/modules/authentication/login/bloc/login_event.dart';
import 'package:yopp/modules/authentication/login/bloc/login_model.dart';
import 'package:yopp/modules/authentication/login/bloc/login_state.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._service, this._profileService)
      : super(LoginState(status: LoginStatus.inital));

  final BaseAuthService _service;
  final ProfileService _profileService;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginInitialEvent) {
      final model = await getSavedLogin();
      if (model == null) {
        yield state.copyWith(email: "", password: "", rememberMe: false);
      } else {
        yield state.copyWith(
            email: model.email, password: model.password, rememberMe: true);
      }
    }

    if (event is LoginInitiateEvent) {
      try {
        yield state.copyWith(
            status: LoginStatus.loading, message: "Signing In");

        if (event.remember) {
          await saveLogin(
              LoginModel(email: event.email, password: event.password));
        } else {
          await forgetSavedLogin();
        }

        final userCredential =
            await _service.signIn(event.email, event.password);
        final authUser = userCredential.user;

        if (authUser == null) {
          yield state.copyWith(
              status: LoginStatus.faliure, message: "User not found.");
        } else {
          FirebaseCrashlytics.instance.setUserIdentifier(authUser?.uid ?? "NA");

          final userProfile = await _profileService.updateProfile(
              UserProfile(uid: authUser.uid, status: UserStatus.active));
          final interests = await _profileService.loadInterestOptions();

          if (authUser.phoneNumber == null || authUser.phoneNumber.isEmpty) {
            yield state.copyWith(
              status: LoginStatus.optPending,
              userProfile: userProfile,
              interests: interests,
            );
          } else if (userProfile.gender == null) {
            yield state.copyWith(
              status: LoginStatus.genderPending,
              userProfile: userProfile,
              interests: interests,
            );
          } else if (userProfile.age == null) {
            yield state.copyWith(
              status: LoginStatus.birthYearPending,
              userProfile: userProfile,
              interests: interests,
            );
          } else if (userProfile.selectedInterest == null) {
            yield state.copyWith(
              status: LoginStatus.abilityPending,
              userProfile: userProfile,
              interests: interests,
            );
          } else {
            yield state.copyWith(
                status: LoginStatus.success,
                userProfile: userProfile,
                interests: interests,
                message: "Success");
          }
        }
      } catch (error) {
        FirebaseCrashlytics.instance.log("LoginInitiateEvent");
        FirebaseCrashlytics.instance.setCustomKey("email", event.email);
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: error));

        yield state.copyWith(
            status: LoginStatus.faliure, message: error.toString());
      }
    }
  }

  Future<void> saveLogin(LoginModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rememberPassword', loginModelToJson(model));
  }

  Future<LoginModel> getSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("rememberPassword");
    if (data != null) {
      return loginModelFromJson(data);
    } else {
      return null;
    }
  }

  Future<void> forgetSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("rememberPassword");
  }
}
