import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yopp/modules/_common/models/location_permission_status.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/enable_location/bloc/location_service.dart';

import 'discover_location_event.dart';
import 'discover_location_state.dart';

class DiscoverLocationBloc
    extends Bloc<DiscoverLocationEvent, DiscoverLocationState> {
  final ProfileService service;
  final PreferenceService _preferenceService;

  DiscoverLocationBloc(this.service, this._preferenceService)
      : super(DiscoverLocationState(
            status: DisoverLocationServiceStatus.none, message: ""));

  @override
  Stream<DiscoverLocationState> mapEventToState(
      DiscoverLocationEvent event) async* {
    if (event is CheckLocationPermission) {
      try {
        yield state.copyWith(
            status: DisoverLocationServiceStatus.checking,
            message: "Checking Location Service.");

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (serviceEnabled == false) {
          yield state.copyWith(
              status: DisoverLocationServiceStatus.checkSuccess,
              permission: LocationPermissionStatus.serviceDisabled,
              message: "Location Service is not enabled.");
        } else {
          LocationPermission permission = await Geolocator.checkPermission();

          yield state.copyWith(
              status: DisoverLocationServiceStatus.checkSuccess,
              permission: mapLocationPermission(permission),
              message: "Location permission " + permission.toString());
        }
      } catch (e) {
        print("CheckLocationEnabled:" + e);
        yield state.copyWith(
            status: DisoverLocationServiceStatus.failed, message: e.toString());
      }
    }

    if (event is UpdateLocationEvent) {
      try {
        yield state.copyWith(
            status: DisoverLocationServiceStatus.checking,
            message: "Updating Location.");

        Position location = await LocationService.determinePosition();
        Address address =
            await LocationService.getAddressFromPosition(location);
        yield state.copyWith(
            status: DisoverLocationServiceStatus.saving,
            message: "Saving Position.");

        await service.saveAddress(address);

        yield state.copyWith(
            status: DisoverLocationServiceStatus.saved,
            message: "Position Saved.");
      } catch (e) {
        print(e.toString());
        yield state.copyWith(
            status: DisoverLocationServiceStatus.failed, message: e.toString());
      }
    }

    if (event is UpdateIfLocationChanged) {
      try {
        yield state.copyWith(
            status: DisoverLocationServiceStatus.checking,
            message: "Checking Location Service.");

        Position location = await LocationService.determinePosition();

        final user = await _preferenceService.getUserProfile();

        final movement = Geolocator.distanceBetween(
            location.latitude,
            location.longitude,
            user.address.coordinates.latitude,
            user.address.coordinates.longitude);
        //if movement is greater than 5 kilometers
        if (movement > 5000) {
          Address address =
              await LocationService.getAddressFromPosition(location);
          yield state.copyWith(
              status: DisoverLocationServiceStatus.saving,
              message: "Updating Location.");

          await service.saveAddress(address);

          yield state.copyWith(
              status: DisoverLocationServiceStatus.saved,
              message: "Location Updated.");
        } else {
          yield state.copyWith(
              status: DisoverLocationServiceStatus.locatedInSameArea,
              message: movement.toString());
        }
      } catch (e) {
        FirebaseCrashlytics.instance.log("CheckIfLocationUpdated");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            status: DisoverLocationServiceStatus.failed, message: e.toString());
      }
    }
    yield state;
  }

  LocationPermissionStatus mapLocationPermission(
    LocationPermission permission,
  ) {
    LocationPermissionStatus status;
    switch (permission) {
      case LocationPermission.denied:
        status = LocationPermissionStatus.denied;
        break;
      case LocationPermission.deniedForever:
        status = LocationPermissionStatus.deniedForever;
        break;
      case LocationPermission.whileInUse:
        status = LocationPermissionStatus.allowed;
        break;
      case LocationPermission.always:
        status = LocationPermissionStatus.allowed;
        break;
    }
    return status;
  }
}
