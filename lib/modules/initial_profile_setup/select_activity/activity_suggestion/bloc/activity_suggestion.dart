import 'package:flutter/foundation.dart';

class ActivitySuggestion {
  String userId;
  String title;
  String email;
  DateTime createdAt;

  ActivitySuggestion({
    @required this.userId,
    @required this.title,
    @required this.createdAt,
    @required this.email,
  });

  factory ActivitySuggestion.fromJson(Map<String, dynamic> json) =>
      ActivitySuggestion(
        userId: json['userId'] == null ? null : json['userId'],
        title: json['title'] == null ? null : json['title'],
        email: json['email'] == null ? null : json['email'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.fromMicrosecondsSinceEpoch(
                json["createdAt"],
              ),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (title != null) {
      data['title'] = this.title;
    }

    if (userId != null) {
      data['userId'] = this.userId;
    }

    if (email != null) {
      data['email'] = this.email;
    }

    if (createdAt != null) {
      data["createdAt"] = createdAt.microsecondsSinceEpoch;
    }

    return data;
  }
}
