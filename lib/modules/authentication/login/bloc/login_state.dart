import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

enum LoginStatus {
  inital,
  loading,
  success,
  faliure,

  optPending,
  genderPending,

  birthYearPending,
  abilityPending,
  profilePending,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final String message;
  final String email;
  final String password;
  final bool rememberMe;

  final UserProfile userProfile;
  final List<InterestOption> interests;

  const LoginState({
    this.status = LoginStatus.inital,
    this.message = "",
    this.email = "",
    this.password = "",
    this.rememberMe = false,
    this.userProfile,
    this.interests = const [],
  });

  LoginState copyWith({
    LoginStatus status,
    String message,
    String email,
    String password,
    bool rememberMe,
    UserProfile userProfile,
    List<InterestOption> interests,
  }) {
    return LoginState(
      status: status ?? this.status,
      message: message ?? this.message,
      email: email ?? this.email,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      userProfile: userProfile ?? this.userProfile,
      interests: interests ?? this.interests,
    );
  }

  List<Object> get props =>
      [status, message, email, password, rememberMe, userProfile, interests];
}
