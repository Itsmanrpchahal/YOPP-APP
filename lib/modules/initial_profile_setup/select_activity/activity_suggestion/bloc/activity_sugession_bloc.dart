import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/profile_service.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_suggestion_event.dart';
import 'package:yopp/modules/initial_profile_setup/select_activity/activity_suggestion/bloc/activity_suggestion_state.dart';

import 'activity_sugession_service.dart';
import 'activity_suggestion.dart';

class ActivitySugessionBloc
    extends Bloc<ActivitySuggestionEvent, ActivitySuggestionState> {
  final ActivitySugesstionService service;
  final ProfileService profileService;

  ActivitySugessionBloc(this.service, this.profileService)
      : super(ActivitySuggestionState());

  @override
  Stream<ActivitySuggestionState> mapEventToState(
      ActivitySuggestionEvent event) async* {
    if (event is PostActivitySuggestion) {
      final userId = FirebaseAuth.instance.currentUser.uid;

      try {
        final profile = await profileService.getupdateProfile(userId);

        yield state.copyWith(
            status: ActivitySuggestionStatus.posting,
            serviceMessage: "Sending Suggestion");

        await service.saveSuggestion(
            suggestion: ActivitySuggestion(
          userId: userId,
          createdAt: DateTime.now(),
          title: event.sportName,
          email: profile.email,
        ));

        yield state.copyWith(
            status: ActivitySuggestionStatus.posted,
            serviceMessage: "Suggestion Sent");
      } catch (e) {
        yield state.copyWith(
            status: ActivitySuggestionStatus.failed,
            serviceMessage: e.toString());
      }
    }

    if (event is GetLatestSuggestionList) {
      try {
        yield (state.copyWith(
            status: ActivitySuggestionStatus.loadingInitial,
            serviceMessage: "Loading"));

        var suggestions = await service.getLatestActivitySuggestions(20);
        print("sfsdfsdf");
        yield (state.copyWith(
            suggestions: suggestions,
            status: ActivitySuggestionStatus.loadingInitialSuccess));
      } catch (e) {
        yield (state.copyWith(
            status: ActivitySuggestionStatus.failed,
            serviceMessage: e.toString()));
      }
    }

    if (event is GetPreviousSuggestionList) {
      try {
        yield (state.copyWith(
            status: ActivitySuggestionStatus.loadingPrevious,
            serviceMessage: "Loading Previous Suggestions"));

        int lastTimeStamp =
            state.suggestions.last?.createdAt?.microsecondsSinceEpoch;
        print(lastTimeStamp);
        final previousSuggestions =
            await service.getPreviousActivitySuggestions(lastTimeStamp, 20);

        final allSuggestions = state.suggestions;
        allSuggestions.addAll(previousSuggestions);

        yield (state.copyWith(
            suggestions: allSuggestions,
            status: ActivitySuggestionStatus.loadingPreviousSuccess));
      } catch (e) {
        yield (state.copyWith(
            status: ActivitySuggestionStatus.failed,
            serviceMessage: e.toString()));
      }
    }
  }
}
