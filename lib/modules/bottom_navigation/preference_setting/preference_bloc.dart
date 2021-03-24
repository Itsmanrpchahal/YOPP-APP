import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_event.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_state.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  final PreferenceService service;
  PreferenceBloc(this.service)
      : super(
          PreferenceState(
              ageRange: RangeValues(
                PreferenceConstants.defaultStartAgeValue,
                PreferenceConstants.defaultEndAgeValue,
              ),
              heightRange: RangeValues(
                PreferenceConstants.defaultStartHeightValue,
                PreferenceConstants.defaultEndHeightValue,
              ),
              locationRange: PreferenceConstants.defaultLocationRangeValue,
              gender: Gender.any,
              skillLevel: SkillLevel.all,
              serviceMessage: "",
              userProfile: null,
              serviceStatus: PreferenceStatus.none),
        );

  @override
  Stream<PreferenceState> mapEventToState(PreferenceEvent event) async* {
    if (event is ResetPreferenceEvent) {
      try {
        yield state.copyWith(
            serviceMessage: "Resetting",
            serviceStatus: PreferenceStatus.loading);

        await service.setAgeRange(
          RangeValues(
            PreferenceConstants.defaultStartAgeValue,
            PreferenceConstants.defaultEndAgeValue,
          ),
        );

        await service.setHeightRange(
          RangeValues(
            PreferenceConstants.defaultStartHeightValue,
            PreferenceConstants.defaultEndHeightValue,
          ),
        );

        await service
            .setLocationRange(PreferenceConstants.defaultLocationRangeValue);

        await service.setGender(null);
        await service.setSkillLevel(null);
        await service.setUserProfile(null);

        yield state.copyWith(
          serviceMessage: "Successful",
          serviceStatus: PreferenceStatus.updated,
        );
      } catch (e) {
        FirebaseCrashlytics.instance.log("ResetPreferenceEvent");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            serviceMessage: e.toString(),
            serviceStatus: PreferenceStatus.failure);
      }
    }

    if (event is UpdatePreferenceEvent) {
      try {
        yield state.copyWith(
            serviceMessage: "Updating",
            serviceStatus: PreferenceStatus.loading);

        if (event.ageRange != null) {
          await service.setAgeRange(event.ageRange);
        }

        if (event.distance != null) {
          await service.setLocationRange(event.distance);
        }

        yield state.copyWith(
          serviceMessage: "Successful",
          serviceStatus: PreferenceStatus.updated,
        );
      } catch (e) {
        FirebaseCrashlytics.instance.log("UpdatePreferenceEvent");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            serviceMessage: e.toString(),
            serviceStatus: PreferenceStatus.failure);
      }
    }

    if (event is GetPreferenceEvent) {
      try {
        yield state.copyWith(
            serviceMessage: "Loading", serviceStatus: PreferenceStatus.loading);

        final ageRange = await service.getAgeRange();
        final heightRange = await service.getHeightRange();
        final locationRange = await service.getLocationRange();
        final gender = await service.getGender();
        final skillLevel = await service.getSkillLevel();
        final user = await service.getUserProfile();

        if (user != null) {
          print("SelectedUser : " + user.toJson().toString());
        }

        yield state.copyWith(
          serviceMessage: "Successful",
          serviceStatus: PreferenceStatus.loaded,
          ageRange: ageRange,
          heightRange: heightRange,
          distance: locationRange,
          gender: gender,
          skillLevel: skillLevel,
          userProfile: user,
        );
      } catch (e) {
        FirebaseCrashlytics.instance.log("GetPreferenceEvent");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            serviceMessage: e.toString(),
            serviceStatus: PreferenceStatus.failure);
      }
    }
  }
}
