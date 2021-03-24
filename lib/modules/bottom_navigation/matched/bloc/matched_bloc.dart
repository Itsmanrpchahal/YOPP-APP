import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_service.dart';
import 'package:yopp/modules/bottom_navigation/matched/bloc/matched_event.dart';
import 'package:yopp/modules/bottom_navigation/matched/bloc/matched_state.dart';

class MatchedBloc extends Bloc<MatchedEvent, MatchedState> {
  final ChatService service;
  MatchedBloc(this.service) : super(MatchedState.inital());

  @override
  Stream<MatchedState> mapEventToState(MatchedEvent event) async* {
    if (event is MatchedUserEvent) {
      try {
        yield MatchedState.loading(message: "Creating Chat");
        final chatDescription =
            await service.createChatRoom(event.user, event.otherUser);

        yield MatchedState.success(chatDescription: chatDescription);
      } catch (e) {
        yield MatchedState.failure(message: e.toString());
      }
    }
  }
}
