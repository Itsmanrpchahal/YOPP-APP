import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/countries_list.dart';

import 'package:yopp/modules/authentication/bloc/authentication_service.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_event.dart';
import 'package:yopp/modules/authentication/sign_up/bloc/register_state.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

class RegisterBloc extends Bloc<RegisterScreenEvent, RegisterState> {
  RegisterBloc(
    this._service,
    this._profileService,
    this._preferenceService,
  ) : super(RegisterState());

  final BaseAuthService _service;
  final ProfileService _profileService;
  final PreferenceService _preferenceService;

  @override
  Stream<RegisterState> mapEventToState(RegisterScreenEvent event) async* {
    UserProfile profile;
    if (event is RegisterEvent) {
      try {
        yield state.copyWith(
            status: RegisterStatus.loading, message: "Signing up");
        final userCredential =
            await _service.signUp(event.email, event.password);

        profile = UserProfile(
          uid: userCredential.user.uid,
          name: event.name,
          email: userCredential.user.email,
          countryCode: event.countryCode,
          phone: event.phone,
          status: UserStatus.pending,
        );

        final updatedProfile = await _profileService.addUserProfile(profile);
        await _preferenceService.setUserProfile(updatedProfile);

        yield state.copyWith(
            status: RegisterStatus.success,
            phoneNumber: event.phone,
            countryCode: event.countryCode,
            message: "Success");
      } catch (error) {
        FirebaseCrashlytics.instance.log("RegisterEvent");
        FirebaseCrashlytics.instance.log(profile.toJson.toString());
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: error));

        yield state.copyWith(
          status: RegisterStatus.faliure,
          message: error.toString(),
        );
      }
    }

    if (event is GotCountryNameEvent) {
      try {
        final country = countryList.where((element) {
          return event.countryName == element.name ||
              event.countryName == element.isoCode ||
              event.countryName == element.iso3Code;
        })?.first;

        yield state.copyWith(
            status: RegisterStatus.countryDialCodeLoaded,
            countryCode: country?.phoneCode,
            message: "Success");
      } catch (error) {
        yield state;
      }
    }
  }
}
