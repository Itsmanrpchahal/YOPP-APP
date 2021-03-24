import 'package:equatable/equatable.dart';

enum OtpStatus { initial, sending, sent, faliure, enteredCorrectOtp }

class OtpState extends Equatable {
  final OtpStatus status;
  final String message;

  const OtpState({
    this.status = OtpStatus.sending,
    this.message = "",
  });

  OtpState copyWith({OtpStatus status, String message}) {
    return OtpState(
        status: status ?? this.status, message: message ?? this.message);
  }

  List<Object> get props => [status, message];
}
