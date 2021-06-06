import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/helper/firebase_constants.dart';

import 'activity_suggestion.dart';

abstract class ActivitySugesstionService {
  Future<void> saveSuggestion({
    @required ActivitySuggestion suggestion,
  });

  Future<List<ActivitySuggestion>> getLatestActivitySuggestions(int limit);

  Future<List<ActivitySuggestion>> getPreviousActivitySuggestions(
      int lastTimeStamp, int limit);
}

class FirebaseActivitySugessionService extends ActivitySugesstionService {
  @override
  Future<void> saveSuggestion({
    @required ActivitySuggestion suggestion,
  }) {
    try {
      final docRef = FirebaseConstants.activitySuggestionRef.doc();
      return docRef.set(suggestion.toJson());
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("saveSuggestion");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  @override
  Future<List<ActivitySuggestion>> getLatestActivitySuggestions(
      int limit) async {
    try {
      final snapshot = await FirebaseConstants.activitySuggestionRef
          .where("createdAt", isGreaterThanOrEqualTo: 0)
          .orderBy("createdAt", descending: true)
          .limit(limit)
          .get();

      var data = [];
      data = snapshot.docs
          .map((documentSnap) =>
              ActivitySuggestion.fromJson(documentSnap.data()))
          .toList();

      return data;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getLatestActivitySuggestions");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  @override
  Future<List<ActivitySuggestion>> getPreviousActivitySuggestions(
      int lastTimeStamp, int limit) async {
    if (lastTimeStamp != null) {
      try {
        final snapshot = await FirebaseConstants.activitySuggestionRef
            .where('createdAt', isLessThan: lastTimeStamp)
            .orderBy("createdAt", descending: true)
            .limit(limit)
            .get();

        List<ActivitySuggestion> data = [];
        data = snapshot.docs
            .map((e) => ActivitySuggestion.fromJson(e.data()))
            .toList();

        return data;
      } on FirebaseException catch (e) {
        FirebaseCrashlytics.instance.log("getPreviousActivitySuggestions");
        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));

        throw Exception(e.message);
      }
    } else {
      return getLatestActivitySuggestions(limit);
    }
  }
}
