import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yopp/modules/_common/models/location_permission_status.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/enable_location/bloc/location_service.dart';

import 'discover_location_event.dart';
import 'discover_location_state.dart';

class DiscoverLocationBloc
    extends Bloc<DiscoverLocationEvent, DiscoverLocationState> {
  final ProfileService service;

  DiscoverLocationBloc(
    this.service,
  ) : super(DiscoverLocationState(
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

        final updatedUser =
            await service.updateProfile(UserProfile(address: address));

        yield state.copyWith(
            status: DisoverLocationServiceStatus.saved,
            userProfile: updatedUser,
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
            message: "UpdateIfLocationChanged.");

        Position location = await LocationService.determinePosition();

        final movement = Geolocator.distanceBetween(
          location.latitude,
          location.longitude,
          event.usersLastLocation.coordinates.last,
          event.usersLastLocation.coordinates.first,
        );
        // if movement is greater than 5 kilometers
        if (movement > 5000) {
          print(location.toJson().toString());
          print(event.usersLastLocation.coordinates.toString());
          print("movement:" + movement.toString());
          Address address =
              await LocationService.getAddressFromPosition(location);
          yield state.copyWith(
              status: DisoverLocationServiceStatus.saving,
              message: "Updating Location.");

          final updatedUser = await service.saveAddress(address);

          yield state.copyWith(
              status: DisoverLocationServiceStatus.saved,
              userProfile: updatedUser,
              message: "Location Updated.");
        } else {
          yield state.copyWith(
              status: DisoverLocationServiceStatus.locatedInSameArea,
              message: movement.toString());
        }
      } catch (e) {
        FirebaseCrashlytics.instance.log("CheckIfLocationUpdated");

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
