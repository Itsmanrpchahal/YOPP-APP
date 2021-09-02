import 'package:equatable/equatable.dart';

enum BirthYearServiceStatus {
  initial,
  updating,
  success,
  failure,
  underAgeAlert
}

class BirthYearState extends Equatable {
  final BirthYearServiceStatus status;
  final String message;

  BirthYearState({
    this.status = BirthYearServiceStatus.initial,
    this.message = "",
  });

  BirthYearState copyWith({BirthYearServiceStatus status, String message}) {
    return BirthYearState(
        message: message ?? this.message, status: status ?? this.status);
  }

  List<Object> get props => [status, message];
}
