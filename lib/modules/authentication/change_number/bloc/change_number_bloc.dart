import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/_common/base_view_model.dart';
import 'package:yopp/modules/authentication/change_number/bloc/change_number_event.dart';
import 'package:yopp/modules/authentication/change_number/bloc/change_number_state.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

class ChangeNumberBloc extends Bloc<ChangeNumberEvent, ChangeNumberState> {
  final ProfileService _service;

  ChangeNumberBloc(this._service) : super(ChangeNumberState());

  @override
  Stream<ChangeNumberState> mapEventToState(ChangeNumberEvent event) async* {
    if (event is UpdateNumberEvent) {
      try {
        yield state.copyWith(
            status: ServiceStatus.loading, message: "Updating");

        final profile = UserProfile(
          uid: FirebaseAuth.instance.currentUser.uid,
          countryCode: event.countryCode,
          phone: event.phoneNumber,
        );
        await _service.updateProfile(profile);

        yield state.copyWith(
          status: ServiceStatus.success,
          message: "Updated",
          phoneNumber: event.phoneNumber,
          countryCode: event.countryCode,
        );
      } catch (e) {
        yield state.copyWith(
            status: ServiceStatus.failure,
            message: "Failed to Send Otp " + e.toString());
      }
    }

    yield state;
  }
}
