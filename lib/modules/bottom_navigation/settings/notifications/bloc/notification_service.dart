import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/helper/firebase_constants.dart';
import 'package:yopp/modules/bottom_navigation/settings/notifications/bloc/notification_setting.dart';

abstract class NotificationService {
  Future<void> setMatchNotification(bool value);
  Future<void> setMessageNotification(bool value);
  Future<void> setEmailNotification(bool value);
  Future<void> setNotificationToken(String token);
  Future<void> deleteNotificationToken();

  Future<NotificationSetting> getNotificationOptions();
}

class FirebaseNotificationService extends NotificationService {
  @override
  Future<void> setEmailNotification(bool value) async {
    final userId = FirebaseAuth.instance.currentUser.uid;

    try {
      final data = NotificationSetting(emailNotification: value);
      await FirebaseConstants.notificationSettingCollectionRef
          .doc(userId)
          .set(data.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("setEmailNotification");
      FirebaseCrashlytics.instance.log(userId);
      FirebaseCrashlytics.instance.log(value.toString());

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  @override
  Future<void> setMatchNotification(bool value) async {
    final userId = FirebaseAuth.instance.currentUser.uid;

    try {
      final data = NotificationSetting(newMatchNotication: value);
      await FirebaseConstants.notificationSettingCollectionRef
          .doc(userId)
          .set(data.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("setMatchNotification");
      FirebaseCrashlytics.instance.log(userId);
      FirebaseCrashlytics.instance.log(value.toString());

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  @override
  Future<void> setMessageNotification(bool value) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      final data = NotificationSetting(messageNotification: value);
      await FirebaseConstants.notificationSettingCollectionRef
          .doc(userId)
          .set(data.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("setMessageNotification");
      FirebaseCrashlytics.instance.log(userId);
      FirebaseCrashlytics.instance.log(value.toString());

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  @override
  Future<NotificationSetting> getNotificationOptions() async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      final documentSnapshot = await FirebaseConstants
          .notificationSettingCollectionRef
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        return NotificationSetting.fromJson(documentSnapshot.data());
      } else {
        return NotificationSetting(
            messageNotification: true,
            newMatchNotication: true,
            emailNotification: true);
      }
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getNotificationOptions");
      FirebaseCrashlytics.instance.log(userId);

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  @override
  Future<void> setNotificationToken(String token) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    if (token == null || userId == null) {
      print("token is null");
      return;
    }

    try {
      final userId = FirebaseAuth.instance.currentUser.uid;
      final data = NotificationSetting(notificationToken: token).toJson();
      await FirebaseConstants.notificationSettingCollectionRef
          .doc(userId)
          .set(data, SetOptions(merge: true));
      print("set token");
    } on FirebaseException catch (e) {
      
      print(e.message);
    }
  }

  Future<void> deleteNotificationToken() async {
    try {
      final userId = FirebaseAuth.instance.currentUser.uid;
      await FirebaseConstants.notificationSettingCollectionRef
          .doc(userId)
          .update({
        "notificationToken": FieldValue.delete(),
      });
      print("delete token");
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
