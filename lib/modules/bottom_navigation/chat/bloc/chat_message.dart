import 'dart:convert';

import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  ChatMessage({
    this.messageId,
    this.message,
    this.timeStamp,
    this.sender,
    this.type,
    this.users,
  });

  final String messageId;
  final String message;
  final DateTime timeStamp;
  final String sender;
  final String type;
  final List<String> users;

  factory ChatMessage.fromRawJson(String str) =>
      ChatMessage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        messageId: json["messageId"] == null ? null : json["messageId"],
        message: json["message"] == null ? null : json["message"],
        timeStamp: json["timeStamp"] == null
            ? null
            : DateTime.fromMicrosecondsSinceEpoch(json["timeStamp"]),
        sender: json["sender"] == null ? null : json["sender"],
        type: json["type"] == null ? null : json["type"],
        users: json["users"] == null
            ? []
            : List<String>.from(json["users"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "messageId": messageId == null ? null : messageId,
        "message": message == null ? null : message,
        "timeStamp":
            timeStamp == null ? null : timeStamp.microsecondsSinceEpoch,
        "sender": sender == null ? null : sender,
        "type": type == null ? null : type,
        "users": users == null ? null : users,
      };

  ChatMessage copyWithMessageId(String id) {
    return ChatMessage(
      messageId: id ?? this.messageId,
      message: this.message,
      timeStamp: this.timeStamp,
      sender: this.sender,
      type: this.type,
      users: this.users,
    );
  }

  @override
  List<Object> get props =>
      [messageId, message, timeStamp, sender, type, users];
}
