import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/app_constants.dart';

import 'package:yopp/modules/initial_profile_setup/birth_year/bloc/birth_year_event.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';

import 'birth_year_state.dart';

class BirthYearBloc extends Bloc<BirthYearEvent, BirthYearState> {
  BirthYearBloc(this._service) : super(BirthYearState());
  final ProfileService _service;

  @override
  Stream<BirthYearState> mapEventToState(BirthYearEvent event) async* {
    if (event is BirthYearSelectionEvent) {
      try {
        yield state.copyWith(
            status: BirthYearServiceStatus.updating, message: "Updating");
        final currentYear = DateTime.now().year;

        if (currentYear - event.year > PreferenceConstants.maxAgeValue) {
          yield state.copyWith(
              status: BirthYearServiceStatus.failure,
              message: "Age should be less than equal to " +
                  PreferenceConstants.maxAgeValue.toInt().toString());
        } else if (currentYear - event.year >=
            PreferenceConstants.underAgeValue) {
          await _service.saveDOB(event.year);
          yield state.copyWith(
              status: BirthYearServiceStatus.success, message: "Updated");
        } else {
          yield state.copyWith(
              status: BirthYearServiceStatus.underAgeAlert,
              message: event.year.toString());
        }
        yield state;
      } catch (error) {
        yield state.copyWith(
            status: BirthYearServiceStatus.failure, message: error.toString());
      }
    }

    if (event is UnderAgePermissionEvent) {
      try {
        yield state.copyWith(
            status: BirthYearServiceStatus.updating, message: "Updating");
        final currentYear = DateTime.now().year;

        if (currentYear - event.year > PreferenceConstants.maxAgeValue) {
          yield state.copyWith(
              status: BirthYearServiceStatus.failure,
              message: "Age should be less than equal to " +
                  PreferenceConstants.maxAgeValue.toInt().toString());
        } else if (currentYear - event.year >=
            PreferenceConstants.minAgeValue) {
          await _service.saveDOB(event.year);
          yield state.copyWith(
              status: BirthYearServiceStatus.success, message: "Updated");
        } else {
          yield state.copyWith(
              status: BirthYearServiceStatus.failure,
              message: "Age should be greater than equal to " +
                  PreferenceConstants.minAgeValue.toInt().toString());
        }
        yield state;
      } catch (error) {
        yield state.copyWith(
            status: BirthYearServiceStatus.failure, message: error.toString());
      }
    }
    yield state;
  }
}
