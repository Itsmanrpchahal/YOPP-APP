import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

abstract class DiscoverLocationEvent extends Equatable {}

class CheckLocationPermission extends DiscoverLocationEvent {
  @override
  List<Object> get props => [];
}

class UpdateLocationEvent extends DiscoverLocationEvent {
  @override
  List<Object> get props => [];
}

class UpdateIfLocationChanged extends DiscoverLocationEvent {
  final Location usersLastLocation;

  UpdateIfLocationChanged(this.usersLastLocation);

  @override
  List<Object> get props => [usersLastLocation];
}
