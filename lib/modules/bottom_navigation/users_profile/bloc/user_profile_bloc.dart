import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/users_profile/bloc/user_profile_state.dart';

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';

class UserProfileBloc extends Bloc<ProfileEvent, UserProfileState> {
  final ProfileService service;
  final PreferenceService _preferenceService;
  UserProfileBloc(this.service, this._preferenceService)
      : super(UserProfileState.inital());

  @override
  Stream<UserProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetUserProfile) {
      try {
        yield UserProfileState.loading(message: "Loading");
        final otherUserInfo = await service.getupdateProfile(event.userId);
        final sports = await service.getUserSports(event.userId);
        final userInfo = await _preferenceService.getUserProfile();

        var distance = "";

        if (userInfo.address != null && otherUserInfo.address != null) {
          final result = Geolocator.distanceBetween(
                userInfo.address.coordinates.latitude,
                userInfo.address.coordinates.longitude,
                otherUserInfo.address.coordinates.latitude,
                otherUserInfo.address.coordinates.longitude,
              ) ~/
              1000;

          distance = result.toString() + " Km away";
        }

        yield UserProfileState.loaded(
          profile: otherUserInfo,
          sports: sports,
          distance: distance,
          message: "",
        );
      } catch (e) {
        FirebaseCrashlytics.instance.log("UserProfileBloc.GetUserProfile");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance.log(event.userId);

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield UserProfileState.failure(message: e.toString());
      }
    }
  }
}
