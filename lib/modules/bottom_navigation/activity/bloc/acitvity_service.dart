import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/helper/firebase_constants.dart';
import 'package:yopp/modules/bottom_navigation/activity/bloc/activity.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';

abstract class ActivityService {
  Future<List<ChatActivity>> getLatestActivityList(String userId, int limit);

  Future<List<ChatActivity>> getPreviousActivities(
      String userId, int lastTimeStamp, int limit);
}

class FirebaseActivityService extends ActivityService {
  @override
  Future<List<ChatActivity>> getLatestActivityList(
      String userId, int limit) async {
    final selectedUserId = userId ?? FirebaseAuth.instance.currentUser.uid;
    try {
      final snapshot = await FirebaseConstants.chatCollectionRef
          .where("users", arrayContains: selectedUserId)
          .where("lastMessage.timeStamp", isGreaterThanOrEqualTo: 0)
          .orderBy("lastMessage.timeStamp", descending: true)
          .limit(limit)
          .get();
      var data = [];
      data = snapshot.docs
          .map((e) =>
              ChatActivity(chatDescription: ChatDescription.fromJson(e.data())))
          .toList();

      print(snapshot.docs.length.toString());

      return data;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getLatestActivityList");
      FirebaseCrashlytics.instance.log(selectedUserId);
      FirebaseCrashlytics.instance.log(limit.toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));
      throw Exception(e.message);
    }
  }

  @override
  Future<List<ChatActivity>> getPreviousActivities(
      String userId, int lastTimeStamp, int limit) async {
    if (lastTimeStamp != null) {
      try {
        final selectedUserId = userId ?? FirebaseAuth.instance.currentUser.uid;
        final snapshot = await FirebaseConstants.chatCollectionRef
            .where("users", arrayContains: selectedUserId)
            .where('lastMessage.timeStamp', isLessThan: lastTimeStamp)
            .orderBy("lastMessage.timeStamp", descending: true)
            .limit(limit)
            .get();

        var data = [];
        data = snapshot.docs
            .map((e) => ChatActivity(
                chatDescription: ChatDescription.fromJson(e.data())))
            .toList();

        return data;
      } on FirebaseException catch (e) {
        FirebaseCrashlytics.instance.log("getPreviousActivities");
        FirebaseCrashlytics.instance
            .log(userId ?? FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance.log(lastTimeStamp.toString());
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));
        throw Exception(e.message);
      }
    } else {
      return getLatestActivityList(userId, limit);
    }
  }
}
