import 'package:equatable/equatable.dart';

import 'package:yopp/modules/bottom_navigation/activity/bloc/activity.dart';

enum ActivityStatus {
  initial,
  loadingInitial,
  loadingPrevious,
  loadingInitialSuccess,
  loadingPreviousSuccess,
  replying,
  replied,
  failed
}

class ActivityState extends Equatable {
  final List<ChatActivity> activities;

  final ActivityStatus status;
  final String serviceMessage;

  ActivityState(
    this.activities,
    this.status,
    this.serviceMessage,
  );

  ActivityState copyWith({
    List<ChatActivity> activities,
    ActivityStatus status,
    String serviceMessage,
  }) {
    return ActivityState(activities ?? this.activities, status ?? this.status,
        serviceMessage ?? "");
  }

  @override
  List<Object> get props =>
      [activities, status, serviceMessage, activities.length];
}
