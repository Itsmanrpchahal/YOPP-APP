import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

abstract class AuthenticationEvent extends Equatable {}

class AuthStatusRequestedEvent extends AuthenticationEvent {
  AuthStatusRequestedEvent();

  @override
  List<Object> get props => [];
}

class SuccessfullyLogedInEvent extends AuthenticationEvent {
  final UserProfile userProfile;
  final List<InterestOption> interests;

  SuccessfullyLogedInEvent({
    @required this.userProfile,
    @required this.interests,
  });
  @override
  List<Object> get props => [userProfile, interests];
}

class AuthLogoutRequestedEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class AccountDeleted extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class PauseAccountRequestedEvent extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

class DeleteAccountRequestedEvent extends AuthenticationEvent {
  final String reason;

  DeleteAccountRequestedEvent(this.reason);
  @override
  List<Object> get props => [reason];
}
