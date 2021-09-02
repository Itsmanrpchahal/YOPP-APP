import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {}

class CheckLocationPermission extends LocationEvent {
  @override
  List<Object> get props => [];
}

class SaveLocationEvent extends LocationEvent {
  @override
  List<Object> get props => [];
}

class RemindLater extends LocationEvent {
  @override
  List<Object> get props => [];
}
