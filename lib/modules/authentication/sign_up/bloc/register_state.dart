import 'package:equatable/equatable.dart';

enum RegisterStatus {
  inital,
  loading,
  countryDialCodeLoaded,
  success,
  faliure,
}

class RegisterState extends Equatable {
  final RegisterStatus status;
  final String message;
  final String countryCode;
  final String phoneNumber;

  const RegisterState({
    this.status = RegisterStatus.inital,
    this.message = "",
    this.countryCode = "+61",
    this.phoneNumber,
  });

  RegisterState copyWith(
      {RegisterStatus status,
      String message,
      String countryCode,
      String phoneNumber}) {
    return RegisterState(
        status: status ?? this.status,
        message: message ?? this.message,
        countryCode: countryCode ?? this.countryCode,
        phoneNumber: phoneNumber ?? this.phoneNumber);
  }

  List<Object> get props => [status, message, countryCode, phoneNumber];
}
