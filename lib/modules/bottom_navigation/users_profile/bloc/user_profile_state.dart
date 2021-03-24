import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_state.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';

class UserProfileState extends Equatable {
  final ProfileServiceStatus status;
  final UserProfile userProfile;
  final List<UserSport> sports;

  final String distance;
  final String message;

  const UserProfileState._({
    this.status = ProfileServiceStatus.initial,
    this.message = "",
    this.userProfile,
    this.sports = const [],
    this.distance = "0",
  });

  const UserProfileState.inital()
      : this._(status: ProfileServiceStatus.initial, message: "");

  const UserProfileState.loading(
      {UserProfile profile,
      List<UserSport> sports,
      String distance,
      String message})
      : this._(
            status: ProfileServiceStatus.loading,
            userProfile: profile,
            sports: sports,
            distance: distance ?? "",
            message: message ?? "");

  const UserProfileState.loaded({
    UserProfile profile,
    List<UserSport> sports,
    String distance,
    String message,
  }) : this._(
            status: ProfileServiceStatus.loaded,
            userProfile: profile,
            sports: sports,
            distance: distance ?? "",
            message: message ?? "");

  const UserProfileState.failure({
    UserProfile profile,
    List<UserSport> sports,
    String distance,
    String message,
  }) : this._(
          status: ProfileServiceStatus.failure,
          userProfile: profile,
          sports: sports,
          distance: distance ?? "",
          message: message ?? "",
        );

  @override
  List<Object> get props => [status, userProfile, sports, message, distance];
}
