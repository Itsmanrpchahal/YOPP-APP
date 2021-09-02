import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/edit_profile_event.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/edit_profile_state.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileService _profileService;

  EditProfileBloc(
    this._profileService,
  ) : super(EditProfileState());

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is GetUpdatedUserProfile) {
      try {
        yield state.copyWith(
            status: EditProfileStatus.initial, message: "Loading");
        final userInfo = await _profileService.loadProfile(event.userId);

        yield state.copyWith(
            status: EditProfileStatus.loaded,
            userProfile: userInfo,
            message: "");
      } catch (e) {
        FirebaseCrashlytics.instance.log("GetUpdatedUserProfile");

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));
        yield state.copyWith(
            status: EditProfileStatus.failure, message: e.toString());
      }
    }

    if (event is UpdateUserProfileEvent) {
      try {
        yield state.copyWith(
            status: EditProfileStatus.updating, message: "Updating");

        var data = event.profile.copyWith(status: UserStatus.active);

        if (event.image != null) {
          final photoUrl =
              await _profileService.uploadProfilePhoto(event.image);
          data = data.copyWith(avatar: photoUrl);
        }

        await _profileService.updateProfile(data);

        yield state.copyWith(
            status: EditProfileStatus.updated,
            userProfile: data,
            message: "Updated");
      } catch (e) {
        yield state.copyWith(
            status: EditProfileStatus.failure, message: e.toString());
      }
    }
  }
}
