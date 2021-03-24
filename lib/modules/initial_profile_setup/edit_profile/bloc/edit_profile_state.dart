import 'package:equatable/equatable.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

enum EditProfileStatus { initial, loading, loaded, updating, updated, failure }

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final UserProfile userProfile;
  final String message;

  EditProfileState({
    this.status = EditProfileStatus.initial,
    this.message = "",
    this.userProfile,
  });

  EditProfileState copyWith({
    EditProfileStatus status,
    final UserProfile userProfile,
    final String message,
  }) {
    return EditProfileState(
        status: status ?? this.status,
        userProfile: userProfile ?? this.userProfile,
        message: message ?? this.message);
  }

  @override
  List<Object> get props => [status, message, userProfile];
}
