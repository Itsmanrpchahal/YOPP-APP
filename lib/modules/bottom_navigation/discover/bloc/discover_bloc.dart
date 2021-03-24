import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_event.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_service.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_state.dart';
import 'package:yopp/modules/bottom_navigation/preference_setting/preference_service.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverService service;
  final ProfileService profileService;
  final PreferenceService preferenceService;

  DiscoverBloc(
    this.service,
    this.profileService,
    this.preferenceService,
  ) : super(DiscoverState());

  @override
  Stream<DiscoverState> mapEventToState(DiscoverEvent event) async* {
    if (event is DiscoverUsersEvent) {
      try {
        yield state.copyWith(
            status: DiscoverServiceStatus.loading,
            message: "Loading",
            users: []);

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();

          final userProfile = await preferenceService.getUserProfile();
          final ageRange = await preferenceService.getAgeRange();
          final locationRange = await preferenceService.getLocationRange();

          print(userProfile.toJson().toString());

          if ((permission == LocationPermission.whileInUse ||
                  permission == LocationPermission.always) &&
              userProfile?.address != null) {
            final result = await service.getSimilarUsers(
              userProfile: userProfile,
              ageRange: ageRange,
              maxDistance: locationRange,
            );

            yield state.copyWith(
              status: DiscoverServiceStatus.loaded,
              message: "",
              user: userProfile,
              users: result.data,
              metaData: result.meta,
            );
          } else {
            yield state.copyWith(
              status: DiscoverServiceStatus.noLocation,
              message: "",
              user: userProfile,
            );
          }
        }
      } catch (e) {
        FirebaseCrashlytics.instance.log("DiscoverUsersEvent");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        print(e.toString());
        yield state.copyWith(
            status: DiscoverServiceStatus.failure, message: e.toString());
      }
    }

    if (event is LikeUserEvent) {
      final users = state.users;
      users.remove(event.user);

      yield state.copyWith(
          status: DiscoverServiceStatus.swping, message: "Like", users: users);

      try {
        final matched = await service.likeUser(
          discoveredUser: event.user,
          uid: FirebaseAuth.instance.currentUser.uid,
        );

        print(matched.toString());

        if (matched == true) {
          yield state.copyWith(
              status: DiscoverServiceStatus.matched,
              message: "Matched with " + event.user.name,
              users: users,
              matchedUser: event.user);
        } else {
          yield state.copyWith(
              status: DiscoverServiceStatus.liked,
              message: "",
              users: users,
              matchedUser: null);
        }

        getMoreIfEmpty(state);
      } catch (e) {
        final users = state.users;
        users.insert(0, event.user);
        yield state.copyWith(
            status: DiscoverServiceStatus.failure,
            message: e.toString(),
            users: users);
      }
    }

    if (event is DislikeUserEvent) {
      final users = state.users;
      users.remove(event.user);

      yield state.copyWith(
          status: DiscoverServiceStatus.swping,
          message: "Dislike",
          users: users);

      try {
        await service.dislikeUser(
          discoveredUser: event.user,
          uid: FirebaseAuth.instance.currentUser.uid,
        );

        yield state.copyWith(
          status: DiscoverServiceStatus.disliked,
          message: "",
          users: users,
        );
      } catch (e) {
        final users = state.users;
        users.insert(0, event.user);

        yield state.copyWith(
            status: DiscoverServiceStatus.failure,
            message: e.toString(),
            users: users);
      }

      getMoreIfEmpty(state);
    }
  }

  getMoreIfEmpty(DiscoverState state) {
    add(DiscoverUsersEvent());
  }
}
