import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_message.dart';

enum ChatStatus {
  initial,
  loadingInitial,
  loadingPrevious,
  observingNew,
  loadingInitialSuccess,
  loadingPreviousSuccess,
  observedNew,
  deleting,
  deleted,
  blocking,
  blocked,
  failure
}

class ChatState extends Equatable {
  final List<ChatMessage> chatMessages;

  final ChatStatus status;
  final String serviceMessage;

  ChatState(
    this.chatMessages,
    this.status,
    this.serviceMessage,
  );

  ChatState copyWith({
    List<ChatMessage> chatMessages,
    ChatStatus status,
    String serviceMessage,
  }) {
    return ChatState(chatMessages ?? this.chatMessages, status ?? this.status,
        serviceMessage ?? "");
  }

  @override
  List<Object> get props =>
      [chatMessages, status, serviceMessage, chatMessages.length];
}
