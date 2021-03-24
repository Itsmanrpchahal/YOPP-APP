import 'package:equatable/equatable.dart';

abstract class ActivitySuggestionEvent extends Equatable {}

class PostActivitySuggestion extends ActivitySuggestionEvent {
  final String sportName;
  PostActivitySuggestion(this.sportName);

  @override
  List<Object> get props => [sportName];
}

class GetLatestSuggestionList extends ActivitySuggestionEvent {
  @override
  List<Object> get props => [];
}

class GetPreviousSuggestionList extends ActivitySuggestionEvent {
  @override
  List<Object> get props => [];
}
