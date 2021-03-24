import 'package:equatable/equatable.dart';

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
  @override
  List<Object> get props => [];
}
