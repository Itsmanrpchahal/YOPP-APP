import 'package:equatable/equatable.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

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

  const LoginState({
    this.status = LoginStatus.inital,
    this.message = "",
    this.email = "",
    this.password = "",
    this.rememberMe = false,
    this.userProfile,
  });

  LoginState copyWith({
    LoginStatus status,
    String message,
    String email,
    String password,
    bool rememberMe,
    UserProfile userProfile,
  }) {
    return LoginState(
        status: status ?? this.status,
        message: message ?? this.message,
        email: email ?? this.email,
        password: password ?? this.password,
        rememberMe: rememberMe ?? this.rememberMe,
        userProfile: userProfile ?? this.userProfile);
  }

  List<Object> get props =>
      [status, message, email, password, rememberMe, userProfile];
}
