import 'package:equatable/equatable.dart';

abstract class BirthYearEvent extends Equatable {}

class BirthYearSelectionEvent extends BirthYearEvent {
  final int year;

  BirthYearSelectionEvent(this.year);

  @override
  List<Object> get props => [year];
}

class UnderAgePermissionEvent extends BirthYearEvent {
  final int year;
  UnderAgePermissionEvent(this.year);

  @override
  List<Object> get props => [year];
}
