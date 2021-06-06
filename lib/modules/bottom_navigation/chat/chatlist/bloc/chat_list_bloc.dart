// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_service.dart';
// import 'package:yopp/modules/bottom_navigation/chat/chatlist/bloc/chat_list_event.dart';
// import 'package:yopp/modules/bottom_navigation/chat/chatlist/bloc/chat_list_state.dart';

// class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
//   final ChatService service;
//   StreamSubscription _streamSubscription;

//   ChatHistoryBloc(this.service) : super(ChatHistoryState.inital());

//   @override
//   Future<void> close() {
//     _streamSubscription.cancel();
//     return super.close();
//   }

//   @override
//   Stream<ChatHistoryState> mapEventToState(ChatHistoryEvent event) async* {
//     if (event is GetChatHistoryEvent) {
//       try {
//         yield ChatHistoryState.loading(message: "Loading");
//         await _streamSubscription?.cancel();

//         final stream = service.getChatHistoryStream(null);
//         _streamSubscription = stream.listen((event) {
//           add(GotChatHistoryStream(event));
//         });
//       } catch (e) {
//         yield ChatHistoryState.failure(message: e.toString());
//       }
//     }

//     if (event is GotChatHistoryStream) {
//       event.chatHistory.sort(
//           (x, y) => y.lastMessage.timeStamp.compareTo(x.lastMessage.timeStamp));
//       yield ChatHistoryState.success(
//           history: event.chatHistory,
//           currentUserId: FirebaseAuth.instance.currentUser.uid);
//     }

//     if (event is RemoveSelfFromChatRoomEvent) {
//       try {
//         yield ChatHistoryState.loading(message: "Deleting");

//         await service.removeSelfFromChatRoom(event.chatRoomId);

//         yield ChatHistoryState.success(
//             history: state.history, currentUserId: state.currentUserId);
//       } catch (e) {
//         yield ChatHistoryState.failure(message: e.toString());
//       }
//     }
//   }
// }
