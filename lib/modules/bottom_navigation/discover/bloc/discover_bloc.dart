import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_event.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_service.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverService service;

  final int _limit = 20;

  DiscoverBloc(
    this.service,
  ) : super(DiscoverState());

  @override
  Stream<DiscoverState> mapEventToState(DiscoverEvent event) async* {
    if (event is DiscoverUsersEvent) {
      try {
        yield state.copyWith(
          status: DiscoverServiceStatus.loading,
          user: event.currentUser,
          selectedInterest: event.selectedInterest,
          searchBy: event.searchBy,
          showOnlineOnly: event.showOnlineOnly,
          searchRange: event.searchRange,
          skip: 0,
          data: [],
          message: "Loading",
        );

        if (event.selectedInterest == null) {
          yield state.copyWith(
              status: DiscoverServiceStatus.loadingFailed,
              message: "Please Select one sport from profile.");
          return;
        }

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();

          if ((permission == LocationPermission.whileInUse ||
                  permission == LocationPermission.always) &&
              event.currentUser?.location != null) {
            final result = await service.loadMatchedUsers(
              limit: _limit,
              skip: 0,
              searchBy: event.searchBy,
              showOnlineOnly: event.showOnlineOnly,
              maxDistance: event.searchRange.distance,
              id: event.currentUser.id,
              selectedInterest: event.selectedInterest,
              lat: event.currentUser.location.coordinates.last,
              lng: event.currentUser.location.coordinates.first,
            );

            int specificCount = result.data.interest.total;

            if (event.selectedInterest?.subCategory != null) {
              specificCount = result.data.subCategory.subCategories
                  .firstWhere((element) =>
                      element.id == state.selectedInterest?.subCategory?.id)
                  ?.total;
            } else if (event.selectedInterest?.category != null) {
              specificCount = result.data.category.categories
                  .firstWhere((element) =>
                      element.id == state.selectedInterest?.category?.id)
                  ?.total;
            }

            result.data.users.data.forEach((element) {
              print("element: " + element.name);
            });

            yield state.copyWith(
              status: DiscoverServiceStatus.loaded,
              message: "",
              meta: result.data.users.meta,
              data: result.data.users.data,
              interestCount: result.data.interest.total,
              availableCount: result.data.interest.online,
              specificCount: specificCount,
              searchBy: event.searchBy,
              selectedInterest: event.selectedInterest,
              showOnlineOnly: event.showOnlineOnly,
            );
          } else {
            yield state.copyWith(
              status: DiscoverServiceStatus.noLocation,
              message: "",
            );
          }
        }
      } catch (e) {
        FirebaseCrashlytics.instance.log("DiscoverUsersEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        print(e.toString());
        yield state.copyWith(
            status: DiscoverServiceStatus.loadingFailed, message: e.toString());
      }
    }

    if (event is LoadMoreDiscoveredUserEvent) {
      try {
        yield state.copyWith(
          status: DiscoverServiceStatus.loadingAnotherPage,
          message: "Loading",
        );

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();

          if ((permission == LocationPermission.whileInUse ||
                  permission == LocationPermission.always) &&
              state.user?.location != null) {
            final result = await service.loadMatchedUsers(
              skip: 0,
              limit: (state?.data?.length ?? 0) + _limit,
              // limit: _limit,
              // skip: state.data?.length ?? 0,
              searchBy: state.searchBy,
              showOnlineOnly: state.showOnlineOnly,
              maxDistance: state.searchRange.distance,
              selectedInterest: state.selectedInterest,
              id: state.user.id,
              lat: state.user.location.coordinates.last,
              lng: state.user.location.coordinates.first,
            );

            int specificCount;

            if (state.selectedInterest.subCategory != null) {
              specificCount = result.data.subCategory.subCategories
                  .firstWhere((element) =>
                      element.id == state.selectedInterest?.subCategory?.id)
                  ?.total;
            } else if (state.selectedInterest.category != null) {
              specificCount = result.data.category.categories
                  .firstWhere((element) =>
                      element.id == state.selectedInterest?.category?.id)
                  ?.total;
            } else {
              specificCount = result.data.interest.total;
            }

            // var data = state.data;
            // var uniqueData = result.data.users.data
            //     .where((element) => !data.contains(element));
            // data.addAll(uniqueData);

            // result.data.users.data.forEach((element) {
            //   print("element: " + element.name);
            // });

            yield state.copyWith(
              status: DiscoverServiceStatus.loadedAnotherPage,
              message: "",
              meta: result.data.users.meta,
              data: result.data.users.data,
              interestCount: result.data.interest.total,
              availableCount: result.data.interest.online,
              specificCount: specificCount,
            );
          } else {
            yield state.copyWith(
              status: DiscoverServiceStatus.noLocation,
              message: "",
            );
          }
        }
      } catch (e) {
        FirebaseCrashlytics.instance.log("DiscoverUsersEvent");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        print(e.toString());
        yield state.copyWith(
            status: DiscoverServiceStatus.loadingAnotherPageFailed,
            message: e.toString());
      }
    }
  }
}
