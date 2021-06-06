import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_message.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

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
  final ChatDescription chatRoom;

  final ChatStatus status;
  final String serviceMessage;
  final UserProfile otherUser;

  ChatState({
    this.chatMessages = const [],
    this.status = ChatStatus.initial,
    this.otherUser,
    this.serviceMessage = "",
    this.chatRoom,
  });

  ChatState copyWith({
    ChatDescription chatRoom,
    List<ChatMessage> chatMessages,
    ChatStatus status,
    String serviceMessage,
    UserProfile otherUser,
  }) {
    return ChatState(
      chatMessages: chatMessages ?? this.chatMessages,
      chatRoom: chatRoom ?? this.chatRoom,
      serviceMessage: serviceMessage ?? this.serviceMessage,
      status: status ?? this.status,
      otherUser: otherUser ?? this.otherUser,
    );
  }

  @override
  List<Object> get props => [
        chatMessages,
        status,
        serviceMessage,
        chatMessages.length,
        chatRoom,
        otherUser
      ];
}
