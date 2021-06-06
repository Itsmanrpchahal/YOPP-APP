import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/base_view_model.dart';

class ChangeNumberState extends Equatable {
  final ServiceStatus status;
  final String message;
  final String phoneNumber;
  final String countryCode;

  const ChangeNumberState({
    this.status = ServiceStatus.none,
    this.message = "",
    this.phoneNumber,
    this.countryCode,
  });

  ChangeNumberState copyWith(
      {ServiceStatus status,
      String message,
      String phoneNumber,
      String countryCode}) {
    return ChangeNumberState(
        status: status ?? this.status,
        message: message ?? this.message,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        countryCode: countryCode ?? this.countryCode);
  }

  List<Object> get props => [status, message, phoneNumber, countryCode];
}
