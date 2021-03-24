import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

abstract class EditProfileEvent extends Equatable {}

class UpdateUserProfileEvent extends EditProfileEvent {
  final UserProfile profile;
  final File image;

  UpdateUserProfileEvent({this.profile, this.image});

  @override
  List<Object> get props => [profile, image];
}

class GetUpdatedUserProfile extends EditProfileEvent {
  final String userId;
  GetUpdatedUserProfile({this.userId});
  @override
  List<Object> get props => [userId];
}
