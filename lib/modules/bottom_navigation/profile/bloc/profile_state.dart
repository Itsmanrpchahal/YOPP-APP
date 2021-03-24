import 'package:equatable/equatable.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

enum ProfileServiceStatus { initial, loading, loaded, failure }

class ProfileState extends Equatable {
  final ProfileServiceStatus status;
  final UserProfile userProfile;
  final String message;

  const ProfileState._({
    this.status = ProfileServiceStatus.initial,
    this.message = "",
    this.userProfile,
  });

  const ProfileState.inital()
      : this._(status: ProfileServiceStatus.initial, message: "");

  const ProfileState.loading({UserProfile profile, String message})
      : this._(
            status: ProfileServiceStatus.loading,
            userProfile: profile,
            message: message ?? "");

  const ProfileState.loaded({UserProfile profile, String message})
      : this._(
            status: ProfileServiceStatus.loaded,
            userProfile: profile,
            message: message ?? "");

  const ProfileState.failure({UserProfile profile, String message})
      : this._(
            status: ProfileServiceStatus.failure,
            userProfile: profile,
            message: message ?? "");

  @override
  List<Object> get props => [status, message];
}
