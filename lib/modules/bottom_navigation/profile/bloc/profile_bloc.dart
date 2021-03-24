import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_state.dart';

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService service;
  final PreferenceService _preferenceService;
  ProfileBloc(this.service, this._preferenceService)
      : super(ProfileState.inital());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetUserProfile) {
      try {
        yield ProfileState.loading(message: "Loading");
        final userInfo = await service.getupdateProfile(event.userId);
        await _preferenceService.setUserProfile(userInfo);

        yield ProfileState.loaded(
          profile: userInfo,
          message: "",
        );
      } catch (e) {
        FirebaseCrashlytics.instance.log("GetUserProfile");
        FirebaseCrashlytics.instance.log(event.userId);

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        print(e.toString());
        yield ProfileState.failure(message: e.toString());
      }
    }
  }
}
