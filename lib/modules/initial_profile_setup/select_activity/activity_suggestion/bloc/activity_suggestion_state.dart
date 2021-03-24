import 'package:equatable/equatable.dart';

import 'activity_suggestion.dart';

enum ActivitySuggestionStatus {
  initial,
  loadingInitial,
  loadingPrevious,
  loadingInitialSuccess,
  loadingPreviousSuccess,
  posting,
  posted,
  failed
}

class ActivitySuggestionState extends Equatable {
  final List<ActivitySuggestion> suggestions;

  final ActivitySuggestionStatus status;
  final String serviceMessage;

  ActivitySuggestionState({
    this.suggestions = const [],
    this.status = ActivitySuggestionStatus.initial,
    this.serviceMessage = "",
  });

  ActivitySuggestionState copyWith({
    List<ActivitySuggestion> suggestions,
    ActivitySuggestionStatus status,
    String serviceMessage,
  }) {
    return ActivitySuggestionState(
        suggestions: suggestions ?? this.suggestions,
        status: status ?? this.status,
        serviceMessage: serviceMessage ?? this.serviceMessage);
  }

  @override
  List<Object> get props =>
      [suggestions, status, serviceMessage, suggestions.length];
}
