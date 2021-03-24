import 'package:flutter/material.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';

enum NotificationType {
  match,
  message,
}

extension notificationName on NotificationType {
  String get name {
    String result;
    switch (this) {
      case NotificationType.match:
        result = "match";
        break;
      case NotificationType.message:
        result = "message";
        break;
    }
    return result;
  }
}

class NotificationModel {
  bool silent;
  String userId;
  String title;
  String subtitle;
  ChatDescription chatDescription;
  DateTime createdAt;
  NotificationType type;

  NotificationModel({
    @required this.silent,
    @required this.userId,
    @required this.title,
    @required this.subtitle,
    @required this.createdAt,
    @required this.type,
    this.chatDescription,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    silent = json['silent'] == null ? false : json['silent'];
    userId = json['userId'] == null ? null : json['userId'];
    title = json['title'] == null ? null : json['title'];
    subtitle = json['subtitle'] == null ? null : json['subtitle'];
    type = json['type'] == "match"
        ? NotificationType.match
        : NotificationType.message;
    createdAt = json['createdAt'] == null
        ? null
        : DateTime.fromMicrosecondsSinceEpoch(json["createdAt"]);
    chatDescription = json['chatDescription'] == null
        ? null
        : ChatDescription.fromJson(json['chatDescription']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (silent != null) {
      data['silent'] = this.silent;
    }

    if (title != null) {
      data['title'] = this.title;
    }

    if (userId != null) {
      data['userId'] = this.userId;
    }

    if (subtitle != null) {
      data['subtitle'] = this.subtitle;
    }

    if (type != null) {
      data['type'] = this.type.name;
    }

    if (createdAt != null) {
      data["createdAt"] = createdAt;
    }

    if (chatDescription != null) {
      data['chatDescription'] = this.chatDescription.toJson();
    }
    return data;
  }
}
