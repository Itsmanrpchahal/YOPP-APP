import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/ability_list_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/ablitiy_list_state.dart';

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';

class AbilityListBloc extends Bloc<AbilityListEvent, AbilityListState> {
  final ProfileService service;
  final PreferenceService preferenceService;

  AbilityListBloc(
    this.service,
    this.preferenceService,
  ) : super(AbilityListState(
            status: AbilityListStatus.none, message: "", sports: []));

  @override
  Stream<AbilityListState> mapEventToState(AbilityListEvent event) async* {
    if (event is GetAbilityListEvent) {
      try {
        yield state.copyWith(
            status: AbilityListStatus.loading, message: "Loading");
        final result = await service.getUserSports(event.userId);

        yield state.copyWith(
          status: AbilityListStatus.loaded,
          message: "Success",
          sports: result,
        );
      } catch (e) {
        FirebaseCrashlytics.instance.log("GetAbilityListEvent");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));
        yield state.copyWith(
            status: AbilityListStatus.failure, message: e.toString());
      }
    }

    if (event is SelectSportAbilityEvent) {
      try {
        yield state.copyWith(
            status: AbilityListStatus.loading, message: "Selecting");
        final userProfile = await preferenceService.getUserProfile();
        yield state.copyWith(
            status: AbilityListStatus.selecting, message: "Selecting");
        await service.setSelectedSport(
          sport: event.sport,
          userProfile: userProfile,
        );

        yield state.copyWith(
            status: AbilityListStatus.selected, message: "Selected");
      } catch (e) {
        FirebaseCrashlytics.instance.log("SelectSportAbilityEvent");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            status: AbilityListStatus.failure, message: e.toString());
      }
    }

    if (event is DeleteSportAbilityEvent) {
      try {
        yield state.copyWith(
            status: AbilityListStatus.deleting, message: "Deleting");
        await service.removeSportActivity(event.sportName);
        yield state.copyWith(
            status: AbilityListStatus.deleted, message: "Deleted");
      } catch (e) {
        FirebaseCrashlytics.instance.log("DeleteSportAbilityEvent");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            status: AbilityListStatus.failure, message: e.toString());
      }
    }
  }
}
