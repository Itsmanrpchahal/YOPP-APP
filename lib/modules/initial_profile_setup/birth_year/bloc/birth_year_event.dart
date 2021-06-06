import 'package:equatable/equatable.dart';

abstract class BirthYearEvent extends Equatable {}

class BirthYearSelectionEvent extends BirthYearEvent {
  final DateTime birthDate;

  BirthYearSelectionEvent(this.birthDate);

  @override
  List<Object> get props => [birthDate];
}

class UnderAgePermissionEvent extends BirthYearEvent {
  final DateTime birthDate;
  UnderAgePermissionEvent(this.birthDate);

  @override
  List<Object> get props => [birthDate];
}
