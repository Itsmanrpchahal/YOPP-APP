import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/authentication/otp/bloc/otp_event.dart';
import 'package:yopp/modules/authentication/otp/bloc/otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc() : super(OtpState(status: OtpStatus.initial));

  // Variables
  String _verificationId;

  Duration _timeOut = const Duration(minutes: 1);

  _reset() {
    print("reset");
    _verificationId = null;
  }

  @override
  Stream<OtpState> mapEventToState(OtpEvent event) async* {
    if (event is SendOtpEvent) {
      try {
        _reset();
        yield state.copyWith(status: OtpStatus.sending, message: "Sending Otp");
        print("Sending Otp :" + event.countryCode + event.phoneNumber);
        await _verifyPhoneNumber(event.countryCode + event.phoneNumber);
      } catch (e) {
        print("Error Sending Otp :" +
            event.countryCode +
            event.phoneNumber +
            e.toString());

        FirebaseCrashlytics.instance.log(
            "Error SendOtpEvent" + event?.countryCode ??
                "CountryCode" + event?.phoneNumber ??
                "PhoneNumber");

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            status: OtpStatus.faliure,
            message: "Failed to Send Otp " + e.toString());
      }
    }

    if (event is VerifyOtpEvent) {
      print("VerifyOtpEvent");
      yield state.copyWith(status: OtpStatus.sending, message: "Verifying");
      await _submitSmsCode(event.enteredOtp);
    }

    if (event is VerificationFailedEvent) {
      print("VerificationFailedEvent: " + event.message);
      yield state.copyWith(status: OtpStatus.faliure, message: event.message);
    }

    if (event is CodeSentEvent) {
      print("CodeSentEvent: ");
      yield state.copyWith(status: OtpStatus.sent, message: "Otp Sent");
    }

    if (event is VerificationSuccessEvent) {
      print("VerificationSuccessEvent: ");
      yield state.copyWith(
          status: OtpStatus.enteredCorrectOtp,
          message: "Verification Successful");
    }

    yield state;
  }

  Future<void> _submitSmsCode(String code) async {
    print("_submitSmsCode:" + code);
    print("and _linkWithPhoneNumber called with sms code" +
            code +
            " and " +
            _verificationId ??
        "NA");
    await _linkWithPhoneNumber(
      PhoneAuthProvider.credential(
        smsCode: code,
        verificationId: _verificationId,
      ),
    );
  }

  Future<void> _verifyPhoneNumber(String number) async {
    print("_verifyPhoneNumber: " + number);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: _timeOut,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      verificationCompleted: _linkWithPhoneNumber,
      verificationFailed: verificationFailed,
    );
    return;
  }

  // PhoneCodeSent
  void codeSent(String verificationId, int forceResendingToken) async {
    print("Verification code sent to number :" +
            verificationId +
            " and " +
            forceResendingToken.toString() ??
        "NA");
    _verificationId = verificationId;
    add(CodeSentEvent());
  }

  // PhoneCodeAutoRetrievalTimeout
  codeAutoRetrievalTimeout(String verificationId) {
    print("codeAutoRetrievalTimeout");
    _verificationId = verificationId;

    // add(VerificationFailedEvent("TimeOut. Try Again"));
  }

  void verificationFailed(FirebaseAuthException authException) {
    print("verificationFailed" + authException.toString());

    if (authException.code.contains('invalid-phone-number')) {
      add(VerificationFailedEvent('The provided phone number is not valid.'));
    }
    if (authException.code.contains('too-many-requests')) {
      add(VerificationFailedEvent(
          "We have blocked all requests from this device due to unusual activity. Try again later."));
    } else {
      add(VerificationFailedEvent(
          "We couldn't verify your code for now! " + authException.toString()));
    }
  }

  Future<void> _linkWithPhoneNumber(PhoneAuthCredential credential) async {
    print("linkwithPhoneNumber");

    try {
      await FirebaseAuth.instance.currentUser.linkWithCredential(credential);
      _verifyUserHasPhoneLinked();
    } catch (error) {
      print("Failed to verify  code: $error");
      FirebaseCrashlytics.instance.log("_linkWithPhoneNumber error");

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: Exception(error)));

      String errorMessage = "";
      if (error.toString().contains("provider-already-linked")) {
        errorMessage = "The Phone number has already been verified.";
      } else if (error.toString().contains("invalid-phone-number")) {
        errorMessage = "Invalid Phone Number";
      } else if (error.toString().contains("quota-exceeded")) {
        errorMessage = "Server Error";
      } else if (error.toString().contains("user-disabled")) {
        errorMessage = "Phone number has been disabled";
      } else if (error.toString().contains("credential-already-in-use")) {
        errorMessage =
            "The Phone number has already been linked to Another User";
      } else if (error.toString().contains("operation-not-allowed")) {
        errorMessage = "Server Error - Operation Not Allowed";
      } else if (error.toString().contains("invalid-verification-code")) {
        errorMessage = "invalid-verification-code. Try Resending OTP";
      } else if (error.toString().contains("invalid-verification-id")) {
        errorMessage = "invalid-verification-id. Try Resending OTP";
      } else {
        errorMessage = error.code;
      }

      add(VerificationFailedEvent("Failed to verify code: " + errorMessage));
    }
    return;
  }

  void _verifyUserHasPhoneLinked() {
    final user = FirebaseAuth.instance.currentUser;

    final success = (user != null &&
        (user.phoneNumber != null && user.phoneNumber.isNotEmpty));
    print("verifyUserHasPhoneLinked:" + success.toString());

    if (success) {
      add(VerificationSuccessEvent());
    }
  }
}
