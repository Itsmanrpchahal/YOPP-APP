import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/modules/_common/models/database.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';

import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

import 'authenication_state.dart';
import 'authentication_event.dart';
import 'authentication_service.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthState> {
  AuthBloc(this._service, this._profileService, this._notificationService,
      this._preferenceService)
      : super(AuthState());

  final BaseAuthService _service;
  final ProfileService _profileService;
  final NotificationService _notificationService;
  final PreferenceService _preferenceService;

  @override
  Stream<AuthState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthStatusRequestedEvent) {
      try {
        yield state.copyWith(status: AuthStatus.checking);
        final authUser = await _service.getCurrentUser();

        if (authUser == null) {
          yield state.copyWith(status: AuthStatus.unauthenticated);
        } else if (authUser.phoneNumber == null ||
            authUser.phoneNumber.isEmpty) {
          yield state.copyWith(status: AuthStatus.unauthenticated);
        } else {
          final userProfile =
              await _profileService.getupdateProfile(authUser.uid);
          print("userProfile:" + userProfile?.toJson().toString());
          if (userProfile == null) {
            await _service.signOut();
            yield state.copyWith(status: AuthStatus.unauthenticated);
          } else if (userProfile.status == UserStatus.deleted ||
              userProfile.gender == null ||
              // userProfile.address == null ||
              userProfile.age == null ||
              userProfile.selectedSport == null) {
            yield state.copyWith(status: AuthStatus.unauthenticated);
          } else {
            yield state.copyWith(
                status: AuthStatus.authenticated, user: userProfile);
          }
        }
      } catch (e) {
        FirebaseCrashlytics.instance.log("AuthStatusRequestedEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));
        yield state.copyWith(status: AuthStatus.error, message: e.toString());
      }
    }

    if (event is AuthLogoutRequestedEvent) {
      try {
        yield state.copyWith(
            status: AuthStatus.updating, message: "Logging Out");
        await _notificationService.deleteNotificationToken();
        final uid = FirebaseAuth.instance.currentUser.uid;
        await OnlineStatusDatabase.updateUserPresence(uid, false);
        await _service.signOut();
        await _preferenceService.setUserProfile(null);

        yield state.copyWith(status: AuthStatus.unauthenticated);
      } catch (e) {
        FirebaseCrashlytics.instance.log("AuthLogoutRequestedEvent");
        FirebaseCrashlytics.instance
            .setCustomKey("uid", FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));
        yield state.copyWith(status: AuthStatus.error, message: e.toString());
      }
    }

    if (event is PauseAccountRequestedEvent) {
      try {
        yield state.copyWith(
            status: AuthStatus.updating, message: "Pausing Account");
        final userProfile = UserProfile(status: UserStatus.paused);

        await _profileService.updateProfile(userProfile);

        add(AuthLogoutRequestedEvent());
      } catch (e) {
        FirebaseCrashlytics.instance.log("PauseAccountRequestedEvent");
        FirebaseCrashlytics.instance
            .setCustomKey("uid", FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));
        yield state.copyWith(message: e.toString());
      }
    }

    if (event is DeleteAccountRequestedEvent) {
      try {
        yield state.copyWith(
            status: AuthStatus.updating, message: "Deleting Account");
        final uid = FirebaseAuth.instance.currentUser.uid;
        await _profileService.deleteProfile(uid);

        await _service.deleteAccount(null, event.reason);

        add(AuthLogoutRequestedEvent());
      } catch (e) {
        FirebaseCrashlytics.instance.log("DeleteAccountRequestedEvent");
        FirebaseCrashlytics.instance
            .setCustomKey("uid", FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(message: e.toString());
      }
    }

    if (event is SuccessfullyLogedInEvent) {
      yield state.copyWith(
          status: AuthStatus.authenticated, user: event.userProfile);
    }
  }
}
