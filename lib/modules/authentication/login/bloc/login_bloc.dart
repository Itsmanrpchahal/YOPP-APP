import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yopp/modules/authentication/bloc/authentication_service.dart';
import 'package:yopp/modules/authentication/login/bloc/login_event.dart';
import 'package:yopp/modules/authentication/login/bloc/login_model.dart';
import 'package:yopp/modules/authentication/login/bloc/login_state.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._service, this._profileService, this._preferenceService)
      : super(LoginState(status: LoginStatus.inital));

  final BaseAuthService _service;
  final ProfileService _profileService;
  final PreferenceService _preferenceService;

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
          final userProfile =
              await _profileService.getupdateProfile(authUser.uid);
          await _preferenceService.setUserProfile(userProfile);

          if (userProfile.status == UserStatus.paused) {
            await _profileService
                .updateProfile(UserProfile(status: UserStatus.active));
          }

          if (authUser.phoneNumber == null || authUser.phoneNumber.isEmpty) {
            yield state.copyWith(
                status: LoginStatus.optPending, userProfile: userProfile);
          } else if (userProfile.gender == null) {
            yield state.copyWith(
                status: LoginStatus.genderPending, userProfile: userProfile);
          } else if (userProfile.age == null) {
            yield state.copyWith(
                status: LoginStatus.birthYearPending, userProfile: userProfile);
          } else if (userProfile.selectedSport == null) {
            yield state.copyWith(
                status: LoginStatus.abilityPending, userProfile: userProfile);
          } else {
            yield state.copyWith(
                status: LoginStatus.success,
                userProfile: userProfile,
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
