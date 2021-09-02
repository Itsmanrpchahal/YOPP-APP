import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';

// ignore: must_be_immutable
class ChatActivity extends Equatable {
  bool isOpen;
  final ChatDescription chatDescription;

  ChatActivity({
    this.isOpen = false,
    @required this.chatDescription,
  });

  @override
  List<Object> get props => [isOpen, chatDescription];
}
