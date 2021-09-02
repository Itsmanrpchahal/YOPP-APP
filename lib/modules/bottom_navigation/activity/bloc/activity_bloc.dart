import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:yopp/modules/bottom_navigation/activity/bloc/acitvity_service.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity_event.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity_state.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_service.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc({
    @required this.service,
    @required this.chatService,
  }) : super(ActivityState([], ActivityStatus.initial, ""));

  final ActivityService service;
  final ChatService chatService;

  @override
  Stream<ActivityState> mapEventToState(ActivityEvent event) async* {
    if (event is GetLatestActivityList) {
      try {
        yield (state.copyWith(
            status: ActivityStatus.loadingInitial, serviceMessage: "Loading"));

        var initialActitivies = await service.getLatestActivityList(null, 20);
        // initialActitivies.removeWhere((element) =>
        //     element.chatDescription.sender ==
        //     FirebaseAuth.instance.currentUser.uid);

        yield (state.copyWith(
            activities: initialActitivies,
            status: ActivityStatus.loadingInitialSuccess));
      } catch (e) {
        yield (state.copyWith(
            status: ActivityStatus.failed, serviceMessage: e.toString()));
      }
    }

    if (event is GetPreviousActivityList) {
      try {
        yield (state.copyWith(
            status: ActivityStatus.loadingPrevious,
            serviceMessage: "Loading Previous Activities"));

        int lastTimeStamp = state.activities.last?.chatDescription?.lastMessage
            ?.timeStamp?.microsecondsSinceEpoch;
        final previousActivities =
            await service.getPreviousActivities(null, lastTimeStamp, 20);

        final allActivities = state.activities;
        allActivities.addAll(previousActivities);

        yield (state.copyWith(
            activities: allActivities,
            status: ActivityStatus.loadingPreviousSuccess));
      } catch (e) {
        yield (state.copyWith(
            status: ActivityStatus.failed, serviceMessage: e.toString()));
      }
    }

    // if (event is PostMessageActivityEvent) {
    //   try {
    //     yield (state.copyWith(status: ActivityStatus.replying));
    //     chatService.postChatMessage(
    //         event.chatRoomId,
    //         FirebaseAuth.instance.currentUser.uid,
    //         event.message,
    //         event.messageType);
    //     yield (state.copyWith(status: ActivityStatus.replied));
    //   } catch (e) {
    //     yield (state.copyWith(
    //         status: ActivityStatus.failed, serviceMessage: e.toString()));
    //   }
    // }
  }
}
