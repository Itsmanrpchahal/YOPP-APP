import 'package:yopp/helper/firebase_constants.dart';
import 'package:yopp/modules/_common/models/online_status.dart';

class OnlineStatusDatabase {
  static Future<void> updateUserPresence(String uid, bool presence) async {
    final presenceStatus = OnlineStatus(
      presence: presence,
      lastSeenInEpoch: DateTime.now().millisecondsSinceEpoch,
    ).toJson();

    final databaseRef = FirebaseConstants.onlineStatusDatabaseRef.child(uid);

    await databaseRef
        .update(presenceStatus)
        .whenComplete(() {})
        .catchError((e) {});

    final presenceStatusFalse = OnlineStatus(
      presence: false,
      lastSeenInEpoch: DateTime.now().millisecondsSinceEpoch,
    ).toJson();

    await databaseRef.onDisconnect().update(presenceStatusFalse);
  }

  static Future<void> apiOnlineConnection(String uid) async {}
}
