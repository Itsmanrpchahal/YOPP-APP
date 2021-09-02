import 'package:flutter/material.dart';

class OnlineStatus {
  bool presence;
  int lastSeenInEpoch;

  OnlineStatus({
    @required this.presence,
    @required this.lastSeenInEpoch,
  });

  OnlineStatus.fromJson(Map<String, dynamic> json) {
    presence = json['presence'];
    lastSeenInEpoch = json['last_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['presence'] = this.presence;
    data['last_seen'] = this.lastSeenInEpoch;

    return data;
  }
}
