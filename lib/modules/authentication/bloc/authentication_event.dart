import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

abstract class AuthenticationEvent extends Equatable {}

class AuthStatusRequestedEvent extends AuthenticationEvent {
  AuthStatusRequestedEvent();

  @override
  List<Object> get props => [];
}

class SuccessfullyLogedInEvent extends AuthenticationEvent {
  final UserProfile userProfile;

  SuccessfullyLogedInEvent({
    @required this.userProfile,
  });
  @override
  List<Object> get props => [];
}

class AuthLogoutRequestedEvent extends AuthenticationEvent {
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
