import 'package:equatable/equatable.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

enum AuthStatus {
  checking,
  optPending,
  genderPending,
  locationPending,
  birthYearPending,
  abilityPending,
  profilePending,
  unauthenticated,
  authenticated,
  updating,
  error,
}

extension name on AuthStatus {
  String get description {
    String value;
    switch (this) {
      case AuthStatus.checking:
        break;
      case AuthStatus.optPending:
        value = "optPending";
        break;
      case AuthStatus.genderPending:
        value = "genderPending";
        break;
      case AuthStatus.locationPending:
        value = "locationPending";
        break;
      case AuthStatus.birthYearPending:
        value = "birthYearPending";
        break;
      case AuthStatus.abilityPending:
        value = "abilityPending";
        break;
      case AuthStatus.profilePending:
        value = "profilePending";
        break;
      case AuthStatus.unauthenticated:
        value = "unauthenticated";
        break;
      case AuthStatus.authenticated:
        value = "authenticated";
        break;
      case AuthStatus.updating:
        value = "updating";
        break;

      case AuthStatus.error:
        value = "error";
        break;
    }
    return value;
  }

  AuthStatus getAuthStatus(String value) {
    AuthStatus status;
    switch (value) {
      case "optPending":
        status = AuthStatus.optPending;
        break;
      case "genderPending":
        status = AuthStatus.genderPending;
        break;
      case "locationPending":
        status = AuthStatus.locationPending;
        break;
      case "birthYearPending":
        status = AuthStatus.birthYearPending;
        break;
      case "abilityPending":
        status = AuthStatus.abilityPending;
        break;
      case "profilePending":
        status = AuthStatus.profilePending;
        break;
      case "unauthenticated":
        status = AuthStatus.unauthenticated;
        break;
      case "authenticated":
        status = AuthStatus.authenticated;
        break;

      default:
        status = AuthStatus.unauthenticated;
    }
    return status;
  }
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserProfile user;
  final String message;

  AuthState({
    this.status = AuthStatus.checking,
    this.user,
    this.message = "",
  });

  AuthState copyWith({
    AuthStatus status,
    UserProfile user,
    String message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message ?? "",
    );
  }

  @override
  List<Object> get props => [status, user, message];
}
