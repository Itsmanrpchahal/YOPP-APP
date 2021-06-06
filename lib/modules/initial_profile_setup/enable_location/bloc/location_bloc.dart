import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yopp/modules/_common/models/location_permission_status.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/enable_location/bloc/location_event.dart';
import 'package:yopp/modules/initial_profile_setup/enable_location/bloc/location_service.dart';
import 'package:yopp/modules/initial_profile_setup/enable_location/bloc/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final ProfileService service;

  LocationBloc(
    this.service,
  ) : super(LocationState(status: LocationServiceStatus.none, message: ""));

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is CheckLocationPermission) {
      try {
        yield state.copyWith(
            status: LocationServiceStatus.checking,
            message: "Checking Location Service.");

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (serviceEnabled == false) {
          yield state.copyWith(
              status: LocationServiceStatus.checkSuccess,
              permission: LocationPermissionStatus.serviceDisabled,
              message: "Location Service is not enabled.");
        } else {
          LocationPermission permission = await Geolocator.checkPermission();

          yield state.copyWith(
              status: LocationServiceStatus.checkSuccess,
              permission: mapLocationPermission(permission),
              message: "Location permission " + permission.toString());
        }
      } catch (e) {
        print("CheckLocationEnabled:" + e);
        yield state.copyWith(
            status: LocationServiceStatus.failed, message: e.toString());
      }
    }

    if (event is SaveLocationEvent) {
      try {
        yield state.copyWith(
            status: LocationServiceStatus.checking,
            message: "Checking Location Update.");

        Position location = await LocationService.determinePosition();
        Address address =
            await LocationService.getAddressFromPosition(location);
        yield state.copyWith(
            status: LocationServiceStatus.saving, message: "Saving Position.");

        await service.saveAddress(address);

        yield state.copyWith(
            status: LocationServiceStatus.saved, message: "Position Saved.");
      } catch (e) {
        print(e.toString());
        yield state.copyWith(
            status: LocationServiceStatus.failed, message: e.toString());
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
