import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_message.dart';

import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

import 'chat_message.dart';

class Typing {
  final bool value;
  final DateTime timeStamp;
  Typing({this.value, this.timeStamp});

  factory Typing.fromJson(Map<String, dynamic> json) => Typing(
        value: json["value"] == null ? false : json["value"],
        timeStamp: json["timeStamp"] == null
            ? null
            : DateTime.fromMicrosecondsSinceEpoch(json["timeStamp"]),
      );

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();

    if (value != null) {
      json["value"] = value;
    }

    if (timeStamp != null) {
      json["timeStamp"] = timeStamp.microsecondsSinceEpoch;
    }

    return json;
  }
}

class ChatDescription extends Equatable {
  ChatDescription({
    this.chatRoomId,
    this.users,
    this.user1Id,
    this.user2Id,
    this.user1Name,
    this.user2Name,
    this.user1Profile,
    this.user2Profile,
    this.user1Gender,
    this.user2Gender,
    this.lastMessage,
    this.createdAt,
    this.sportName,
  });

  final String chatRoomId;
  final List<String> users;
  final String user1Id;
  final String user2Id;

  final String user1Name;
  final String user2Name;

  final String user1Profile;
  final String user2Profile;

  final Gender user1Gender;
  final Gender user2Gender;

  final ChatMessage lastMessage;
  final String sportName;

  final DateTime createdAt;

  ChatDescription copyWith(ChatMessage message) {
    return ChatDescription(
      chatRoomId: this.chatRoomId,
      users: this.users,
      user1Id: this.user1Id,
      user2Id: this.user2Id,
      user1Name: this.user1Name,
      user2Name: this.user2Name,
      user1Gender: this.user1Gender,
      user2Gender: this.user2Gender,
      user1Profile: this.user1Profile,
      user2Profile: this.user2Profile,
      lastMessage: message ?? this.lastMessage,
      sportName: this.sportName,
      createdAt: this.createdAt,
    );
  }

  factory ChatDescription.fromRawJson(String str) =>
      ChatDescription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatDescription.fromJson(Map<String, dynamic> json) =>
      ChatDescription(
        chatRoomId: json["chatRoomId"] == null ? null : json["chatRoomId"],
        user1Id: json["user1Id"] == null ? null : json["user1Id"],
        user2Id: json["user2Id"] == null ? null : json["user2Id"],
        users: json["users"] == null
            ? []
            : List<String>.from(json["users"].map((x) => x)),
        user1Name: json["user1Name"] == null ? null : json["user1Name"],
        user2Name: json["user2Name"] == null ? null : json["user2Name"],
        user1Profile:
            json["user1Profile"] == null ? null : json["user1Profile"],
        user2Profile:
            json["user2Profile"] == null ? null : json["user2Profile"],
        user1Gender: json["user1Gender"] == null
            ? null
            : Gender.values[json["user1Gender"]],
        user2Gender: json["user2Gender"] == null
            ? null
            : Gender.values[json["user2Gender"]],
        lastMessage: json["lastMessage"] == null
            ? null
            : ChatMessage.fromJson(json["lastMessage"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.fromMicrosecondsSinceEpoch(json["createdAt"]),
        sportName: json["sportName"] == null ? null : json["sportName"],
      );

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();

    if (chatRoomId != null) {
      json["chatRoomId"] = chatRoomId;
    }

    if (users != null) {
      json["users"] = users;
    }

    if (user1Id != null) {
      json["user1Id"] = user1Id;
    }

    if (user2Id != null) {
      json["user2Id"] = user2Id;
    }

    if (user1Name != null) {
      json["user1Name"] = user1Name;
    }

    if (user2Name != null) {
      json["user2Name"] = user2Name;
    }

    if (user1Profile != null) {
      json["user1Profile"] = user1Profile;
    }

    if (user2Profile != null) {
      json["user2Profile"] = user2Profile;
    }

    if (user1Gender != null) {
      json["user1Gender"] = user1Gender.index;
    }

    if (user2Gender != null) {
      json["user2Gender"] = user2Gender.index;
    }

    if (lastMessage != null) {
      json["lastMessage"] = lastMessage.toJson();
    }

    if (createdAt != null) {
      json["createdAt"] = createdAt.microsecondsSinceEpoch;
    }

    if (sportName != null) {
      json['sportName'] = sportName;
    }

    return json;
  }

  @override
  List<Object> get props => [
        chatRoomId,
        users,
        user1Id,
        user2Id,
        user1Name,
        user2Name,
        user1Profile,
        user2Profile,
        user1Gender,
        user2Gender,
        lastMessage,
        createdAt,
        sportName,
      ];
}
