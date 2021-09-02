import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/models/location_permission_status.dart';

enum LocationServiceStatus {
  none,
  checking,
  checkSuccess,

  saving,
  saved,
  failed
}

class LocationState extends Equatable {
  final LocationServiceStatus status;
  final LocationPermissionStatus permission;

  final String message;

  LocationState({this.status, this.message, this.permission});

  LocationState copyWith({
    LocationServiceStatus status,
    String message,
    LocationPermissionStatus permission,
  }) {
    return LocationState(
      status: status ?? this.status,
      message: message ?? this.message,
      permission: permission ?? this.permission,
    );
  }

  @override
  List<Object> get props => [status, message, permission];
}
