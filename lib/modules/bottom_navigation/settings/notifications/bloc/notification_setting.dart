import 'package:equatable/equatable.dart';

class NotificationSetting extends Equatable {
  final bool newMatchNotication;
  final bool messageNotification;
  final bool emailNotification;
  final String notificationToken;

  const NotificationSetting({
    this.newMatchNotication,
    this.messageNotification,
    this.emailNotification,
    this.notificationToken,
  });

  NotificationSetting copyWith({
    bool newMatchNotication,
    bool messageNotification,
    bool emailNotification,
    String notificationToken,
  }) {
    return NotificationSetting(
      newMatchNotication: newMatchNotication ?? this.newMatchNotication,
      messageNotification: messageNotification ?? this.messageNotification,
      emailNotification: emailNotification ?? this.emailNotification,
      notificationToken: notificationToken ?? this.notificationToken,
    );
  }

  factory NotificationSetting.fromJson(Map<String, dynamic> json) =>
      NotificationSetting(
          newMatchNotication: json["newMatchNotication"] == null
              ? true
              : json["newMatchNotication"],
          messageNotification: json["messageNotification"] == null
              ? true
              : json["messageNotification"],
          emailNotification: json["emailNotification"] == null
              ? true
              : json["emailNotification"],
          notificationToken: json["notificationToken"] == null
              ? null
              : json["notificationToken"]);

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();

    if (newMatchNotication != null) {
      json["newMatchNotication"] = newMatchNotication;
    }

    if (messageNotification != null) {
      json["messageNotification"] = messageNotification;
    }

    if (emailNotification != null) {
      json["emailNotification"] = emailNotification;
    }

    if (notificationToken != null) {
      json["notificationToken"] = notificationToken;
    }
    return json;
  }

  @override
  List<Object> get props => [
        newMatchNotication,
        messageNotification,
        emailNotification,
        notificationToken
      ];
}
