import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_state.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService service;

  ProfileBloc(
    this.service,
  ) : super(
          ProfileState(
              status: ProfileServiceStatus.none,
              message: "",
              userProfile: null),
        );

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is SetUserProfileEvent) {
      yield state.copyWith(
        userProfile: event.profile,
        status: ProfileServiceStatus.loaded,
        interestOptions: event.interests,
        connectionCount: event.connectionCount,
      );
    }

    if (event is LoadUserProfileEvent) {
      try {
        yield state.copyWith(
            status: ProfileServiceStatus.loading, message: "Loading");
        final userInfo = await service.loadProfile(event.userId);
        final interestOptions = await service.loadInterestOptions();

        yield state.copyWith(
          status: ProfileServiceStatus.loaded,
          userProfile: userInfo,
          interestOptions: interestOptions,
          connectionCount: userInfo?.connection?.length ?? 0,
          message: "",
        );
      } catch (e) {
        FirebaseCrashlytics.instance.log("GetUserProfile");

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        print(e.toString());
        yield state.copyWith(
            status: ProfileServiceStatus.loadingFailed, message: e.toString());
      }
    }

    if (event is UpdateUserProfileEvent) {
      try {
        yield state.copyWith(
            status: ProfileServiceStatus.updating, message: "Updating");

        var data = event.profile.copyWith(status: UserStatus.active);

        if (event.image != null) {
          final photoUrl = await service.uploadProfilePhoto(event.image);
          data = data.copyWith(avatar: photoUrl);
        }

        final userInfo = await service.updateProfile(data);

        yield state.copyWith(
            status: event.addSportAfterCompletion
                ? ProfileServiceStatus.updatedAndAddSportPending
                : ProfileServiceStatus.updated,
            userProfile: userInfo,
            connectionCount: userInfo?.connection?.length ?? 0,
            message: "Updated");
      } catch (e) {
        yield state.copyWith(
            status: ProfileServiceStatus.updateFailed, message: e.toString());
      }
    }

    if (event is AddNewInterestEvent) {
      try {
        yield state.copyWith(message: "Saving");
        yield state.copyWith(
            status: ProfileServiceStatus.updating, message: "Saving");

        final userProfile = await service.addNewInterest(
          uid: FirebaseAuth.instance.currentUser.uid,
          interest: event.interest,
        );
        print(userProfile.toJson().toString());
        yield state.copyWith(
            status: ProfileServiceStatus.updated,
            userProfile: userProfile,
            connectionCount: userProfile?.connection?.length ?? 0,
            message: "Saved");
      } catch (e) {
        FirebaseCrashlytics.instance.log("AddNewInterestEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            status: ProfileServiceStatus.updateFailed, message: e.toString());
      }
    }
    if (event is UpdateInterestEvent) {
      try {
        yield state.copyWith(message: "Saving");
        yield state.copyWith(
            status: ProfileServiceStatus.updating, message: "Saving");

        final userProfile = await service.updateUserInterest(
          uid: FirebaseAuth.instance.currentUser.uid,
          interest: event.interest,
          isSelected: false,
        );
        yield state.copyWith(
            status: ProfileServiceStatus.updated,
            userProfile: userProfile,
            connectionCount: userProfile?.connection?.length ?? 0,
            message: "Saved");
      } catch (e) {
        FirebaseCrashlytics.instance.log("SaveSelectedAbilityEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            status: ProfileServiceStatus.updateFailed, message: e.toString());
      }
    }

    if (event is UpdatePreferedInterestEvent) {
      try {
        yield state.copyWith(
            status: ProfileServiceStatus.updating, message: "Saving");

        final userProfile = await service.updateUserInterest(
          uid: FirebaseAuth.instance.currentUser.uid,
          interest: event.interest,
          isSelected: true,
        );
        yield state.copyWith(
            status: ProfileServiceStatus.updated,
            userProfile: userProfile,
            connectionCount: userProfile?.connection?.length ?? 0,
            message: "Saved");
      } catch (e) {
        FirebaseCrashlytics.instance.log("SaveSelectedAbilityEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            status: ProfileServiceStatus.updateFailed, message: e.toString());
      }
    }

    if (event is SelectInterestEvent) {
      try {
        yield state.copyWith(message: "Saving");
        yield state.copyWith(
            status: ProfileServiceStatus.updating, message: "Saving");

        final toBeUpdated = UserProfile(
            uid: FirebaseAuth.instance.currentUser.uid,
            selectedInterest: event.interest);
        final updatedUser = await service.updateProfile(toBeUpdated);

        yield state.copyWith(
            status: ProfileServiceStatus.updated,
            userProfile: updatedUser,
            connectionCount: updatedUser?.connection?.length ?? 0,
            message: "Saved");
      } catch (e) {
        FirebaseCrashlytics.instance.log("SaveAbilityEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            status: ProfileServiceStatus.updateFailed, message: e.toString());
      }
    }

    if (event is DeleteInterestEvent) {
      try {
        yield state.copyWith(
            status: ProfileServiceStatus.deleting, message: "Deleting");

        final userProfile = await service.removeInterest(
          uid: FirebaseAuth.instance.currentUser.uid,
          interestId: event.interestId,
        );

        yield state.copyWith(
            status: ProfileServiceStatus.deleted,
            userProfile: userProfile,
            connectionCount: userProfile?.connection?.length ?? 0,
            message: "Deleted");
      } catch (e) {
        FirebaseCrashlytics.instance.log("DeleteInterestEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield state.copyWith(
            status: ProfileServiceStatus.updateFailed, message: e.toString());
      }
    }
    yield state;
  }
}
