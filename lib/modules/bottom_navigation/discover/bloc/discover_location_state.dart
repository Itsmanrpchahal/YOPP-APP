import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/models/location_permission_status.dart';

enum DisoverLocationServiceStatus {
  none,
  checking,
  checkSuccess,

  locationChanged,
  locatedInSameArea,

  saving,
  saved,
  failed
}

class DiscoverLocationState extends Equatable {
  final DisoverLocationServiceStatus status;
  final LocationPermissionStatus permission;

  final String message;

  DiscoverLocationState({this.status, this.message, this.permission});

  DiscoverLocationState copyWith({
    DisoverLocationServiceStatus status,
    String message,
    LocationPermissionStatus permission,
  }) {
    return DiscoverLocationState(
      status: status ?? this.status,
      message: message ?? this.message,
      permission: permission ?? this.permission,
    );
  }

  @override
  List<Object> get props => [status, message, permission];
}
