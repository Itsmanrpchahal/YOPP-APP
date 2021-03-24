abstract class OtpEvent {}

class SendOtpEvent extends OtpEvent {
  final String countryCode;
  final String phoneNumber;

  SendOtpEvent(this.countryCode, this.phoneNumber);
}

class VerifyOtpEvent extends OtpEvent {
  final String enteredOtp;
  VerifyOtpEvent(this.enteredOtp);
}

class CodeSentEvent extends OtpEvent {
  CodeSentEvent();
}

class VerificationSuccessEvent extends OtpEvent {
  VerificationSuccessEvent();
}

class VerificationFailedEvent extends OtpEvent {
  final String message;

  VerificationFailedEvent(this.message);
}
