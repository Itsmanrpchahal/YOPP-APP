import 'package:equatable/equatable.dart';

import 'gender.dart';

abstract class BirthYearEvent extends Equatable {}

class GenderSelectionEvent extends BirthYearEvent {
  final Gender gender;

  GenderSelectionEvent(this.gender);

  @override
  List<Object> get props => [gender];
}
