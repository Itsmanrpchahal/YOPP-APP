import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ActivityEvent extends Equatable {}

class GetLatestActivityList extends ActivityEvent {
  @override
  List<Object> get props => [];
}

class GetPreviousActivityList extends ActivityEvent {
  GetPreviousActivityList();
  @override
  List<Object> get props => [];
}

class PostMessageActivityEvent extends ActivityEvent {
  final String message;
  final String messageType;
  final String chatRoomId;

  PostMessageActivityEvent({
    @required this.message,
    @required this.messageType,
    @required this.chatRoomId,
  });

  @override
  List<Object> get props => [message];
}
