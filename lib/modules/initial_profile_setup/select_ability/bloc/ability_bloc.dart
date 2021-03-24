import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/_common/bloc/base_state.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';

import 'ability_event.dart';

class EditAbilityBloc extends Bloc<EditAblityEvent, BaseState> {
  final ProfileService _service;
  final PreferenceService _preferenceService;

  EditAbilityBloc(this._service, this._preferenceService)
      : super(BaseState.inital());

  @override
  Stream<BaseState> mapEventToState(EditAblityEvent event) async* {
    if (event is SaveSelectedAbilityEvent) {
      try {
        yield BaseState.loading(message: "Saving");
        final userProfile = await _preferenceService.getUserProfile();

        await _service.saveAndSetSelectedSportAcitivy(
          userProfile: userProfile,
          sport: event.userSport,
          height: event.height,
          weight: event.weight,
        );

        yield BaseState.success(message: "Saved");
      } catch (e) {
        FirebaseCrashlytics.instance.log("SaveSelectedAbilityEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield BaseState.failure(message: e.toString());
      }
    }

    if (event is SaveAbilityEvent) {
      try {
        yield BaseState.loading(message: "Saving");

        await _service.saveSportAcitivy(
          sport: event.userSport,
          height: event.height,
          weight: event.weight,
        );

        yield BaseState.success(message: "Saved");
      } catch (e) {
        FirebaseCrashlytics.instance.log("SaveAbilityEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield BaseState.failure(message: e.toString());
      }
    }
    yield state;
  }
}
