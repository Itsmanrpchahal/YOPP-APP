import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/models/location_permission_status.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

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
  final UserProfile userProfile;
  final String message;

  DiscoverLocationState({
    this.status,
    this.message,
    this.permission,
    this.userProfile,
  });

  DiscoverLocationState copyWith({
    DisoverLocationServiceStatus status,
    String message,
    LocationPermissionStatus permission,
    UserProfile userProfile,
  }) {
    return DiscoverLocationState(
      status: status ?? this.status,
      message: message ?? this.message,
      permission: permission ?? this.permission,
      userProfile: userProfile ?? this.userProfile,
    );
  }

  @override
  List<Object> get props => [status, message, permission, userProfile];
}
