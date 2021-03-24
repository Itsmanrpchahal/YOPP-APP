import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_message.dart';

abstract class ChatEvent extends Equatable {}

class LoadInitialMessageEvent extends ChatEvent {
  final String chatRoomId;

  LoadInitialMessageEvent(this.chatRoomId);
  @override
  List<Object> get props => [chatRoomId];
}

class LoadPreviousMessageEvent extends ChatEvent {
  LoadPreviousMessageEvent();

  @override
  List<Object> get props => [];
}

class ObserveLatestMessageEvent extends ChatEvent {
  final int latestMsgTimeStamp;
  ObserveLatestMessageEvent(
    this.latestMsgTimeStamp,
  );

  @override
  List<Object> get props => [latestMsgTimeStamp];
}

class GotObservedMessageEvent extends ChatEvent {
  final ChatMessage chatMessage;

  GotObservedMessageEvent(this.chatMessage);

  @override
  List<Object> get props => [chatMessage];
}

class PostChatMessageEvent extends ChatEvent {
  final String message;
  final String messageType;
  final ChatDescription chatDescription;

  PostChatMessageEvent(this.message, this.messageType, this.chatDescription);

  @override
  List<Object> get props => [message, messageType, chatDescription];
}

class RemoveMessageForSelfEvent extends ChatEvent {
  final String messageId;

  RemoveMessageForSelfEvent(this.messageId);
  @override
  List<Object> get props => [messageId];
}

class UpdateTypingEvent extends ChatEvent {
  final Typing isTyping;

  UpdateTypingEvent(
    this.isTyping,
  );

  @override
  List<Object> get props => [isTyping];
}

class BlocUserEvent extends ChatEvent {
  final String uid;
  final String id;

  BlocUserEvent({@required this.id, @required this.uid});

  @override
  List<Object> get props => [id, uid];
}
