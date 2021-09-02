import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_service.dart';
import 'package:yopp/modules/bottom_navigation/users_profile/bloc/user_profile_state.dart';

class UserProfileBloc extends Bloc<ProfileEvent, UserProfileState> {
  final ProfileService service;

  UserProfileBloc(
    this.service,
  ) : super(UserProfileState.inital());

  @override
  Stream<UserProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is LoadUserProfileEvent) {
      try {
        yield UserProfileState.loading(message: "Loading");
        final otherUserInfo = await service.loadProfile(event.userId);

        yield UserProfileState.loaded(
          profile: otherUserInfo,
          message: "",
        );
      } catch (e) {
        FirebaseCrashlytics.instance.log("UserProfileBloc.GetUserProfile");

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        yield UserProfileState.failure(message: e.toString());
      }
    }
  }
}
