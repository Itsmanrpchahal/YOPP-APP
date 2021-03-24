import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

enum AppStaging { dev, live }

class FirebaseConstants {
  static const _appStage = AppStaging.live;

  static dynamic get baseFireStoreRef {
    if (_appStage == AppStaging.live) {
      return FirebaseFirestore.instance;
    }
    return FirebaseFirestore.instance.collection("yopp").doc("development");
  }

  static DatabaseReference get onlineStatusDatabaseRef {
    if (_appStage == AppStaging.live) {
      return FirebaseDatabase.instance.reference().child("onlineUsers");
    }
    return FirebaseDatabase.instance
        .reference()
        .child("yopp")
        .child('development')
        .child("onlineUsers");
  }

  static CollectionReference get userCollectionRef =>
      baseFireStoreRef.collection("users");

  static CollectionReference get chatCollectionRef =>
      baseFireStoreRef.collection("chatRooms");

  static CollectionReference get notificationSettingCollectionRef =>
      baseFireStoreRef.collection("notificationSettings");

  static CollectionReference get notificationCollectionRef =>
      baseFireStoreRef.collection("notifications");

  static CollectionReference get onlineStatusCollectionRef =>
      baseFireStoreRef.collection('onlineStatus');

  static CollectionReference get activitySuggestionRef =>
      baseFireStoreRef.collection('sportSuggestions');
}
