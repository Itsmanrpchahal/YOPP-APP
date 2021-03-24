import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';

abstract class ChatHistoryEvent extends Equatable {}

class GetChatHistoryEvent extends ChatHistoryEvent {
  final String userId;
  GetChatHistoryEvent(this.userId);
  @override
  List<Object> get props => [userId];
}

class GotChatHistoryStream extends ChatHistoryEvent {
  final List<ChatDescription> chatHistory;
  GotChatHistoryStream(this.chatHistory);
  @override
  List<Object> get props => [chatHistory];
}

class RemoveSelfFromChatRoomEvent extends ChatHistoryEvent {
  final String chatRoomId;
  RemoveSelfFromChatRoomEvent(this.chatRoomId);
  @override
  List<Object> get props => [chatRoomId];
}
