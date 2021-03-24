import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/edit_profile_event.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/edit_profile_state.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileService firebaseService;

  EditProfileBloc(
    this.firebaseService,
  ) : super(EditProfileState());

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is GetUpdatedUserProfile) {
      try {
        yield state.copyWith(
            status: EditProfileStatus.initial, message: "Loading");
        final userInfo = await firebaseService.getupdateProfile(event.userId);
        yield state.copyWith(
            status: EditProfileStatus.loaded,
            userProfile: userInfo,
            message: "");
      } catch (e) {
        yield state.copyWith(
            status: EditProfileStatus.failure, message: e.toString());
      }
    }

    if (event is UpdateUserProfileEvent) {
      try {
        yield state.copyWith(
            status: EditProfileStatus.updating, message: "Updating");

        var data = event.profile.copyWith(status: UserStatus.active);

        if (event.image != null) {
          final photoUrl =
              await firebaseService.uploadProfilePhoto(event.image);
          data = data.copyWith(imageUrl: photoUrl);
        }

        await firebaseService.updateProfile(data);

        yield state.copyWith(
            status: EditProfileStatus.updated,
            userProfile: data,
            message: "Updated");
      } catch (e) {
        yield state.copyWith(
            status: EditProfileStatus.failure, message: e.toString());
      }
    }
  }
}
