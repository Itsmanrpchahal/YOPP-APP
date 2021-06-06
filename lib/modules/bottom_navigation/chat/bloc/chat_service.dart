import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/helper/firebase_constants.dart';
import 'package:yopp/modules/_common/models/notificationModel.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_message.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connections_bloc.dart';

abstract class ChatService {
  Future<ChatDescription> createChatRoomConnection(
    UserProfile user,
    AddConnectionData otherUser,
    String connectionId,
  );
  Future<List<ChatDescription>> getChatHistory(String userId);
  Stream<List<ChatDescription>> getChatHistoryStream(String userId);
  Future<List<ChatMessage>> getFewLatestMessages(String chatRoomId, int limit);
  Future<ChatDescription> getChatRoomDescription(String chatRoomId);

  Future<List<ChatMessage>> getFewPreviousMessages(
      String chatRoomId, int lastTimeStamp, int limit);
  Stream<List<ChatMessage>> getChatMessageStream(
      String chatRoomId, int latestMessageTimeStamp);
  Future<void> postChatMessage(
      ChatDescription chatDescription, ChatMessage chatMessage);

  Future<void> deleteChatRoom(String chatRoomId);

  Future<void> removeConnectionToChatRoom({
    @required String chatRoomId,
    @required String endedByUid,
  });

  Future<void> resetConnectionToChatRoom({
    @required String chatRoomId,
    @required String uid,
  });

  Future<void> removeUsersFromChatRoom({
    @required String chatRoomId,
    @required List<String> uids,
  });

  Future<void> addUserToChatRoom({
    @required String chatRoomId,
    @required List<String> uids,
  });

  Future<void> removeBlockFromChatRoom({
    @required String chatRoomId,
    @required List<String> uids,
  });

  Future<void> addBlockToChatRoom({
    @required String chatRoomId,
    @required List<String> uids,
  });

  Future<void> removeChatMessageForSelf({
    @required String chatRoomId,
    @required String messageId,
    @required ChatMessage lastMessage,
    @required bool updateChatHistoryList,
  });

  Future<void> updateTyping(String chatRoomId, Typing isTyping);
}

class FirebaseChatService extends ChatService {
  @override
  Future<ChatDescription> createChatRoomConnection(
    UserProfile user,
    AddConnectionData matchedUser,
    String connectionId,
  ) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      final createdTime = DateTime.now();

      final ChatMessage chatMessage = ChatMessage(
          messageId: connectionId,
          message: "Congratulations, You have a new connection!!",
          timeStamp: createdTime,
          sender: "Admin",
          users: [user.uid, matchedUser.uid],
          type: "Text");

      final chatDescription = ChatDescription(
        chatRoomId: connectionId,
        user1Id: user.uid,
        user2Id: matchedUser.uid,
        users: [user.uid, matchedUser.uid],
        user1Profile: user.avatar,
        user2Profile: matchedUser.avatar,
        user1Name: user.name,
        user2Name: matchedUser.name,
        user1Gender: user.gender,
        user2Gender: matchedUser.gender,
        lastMessage: chatMessage,
        createdAt: createdTime,
        blockedBy: null,
        connectionEndedBy: null,
      );

      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(connectionId);
      batch.set(
          chatRoomRef, chatDescription.toJson(), SetOptions(merge: false));

      final userNotification = NotificationModel(
          silent: true,
          userId: user.uid,
          title: matchedUser.name + " is added as a new Connection",
          subtitle: "",
          createdAt: DateTime.now(),
          type: NotificationType.match,
          chatDescription: chatDescription);
      final userNotificationRef =
          FirebaseConstants.notificationCollectionRef.doc();
      batch.set(userNotificationRef, userNotification.toJson());

      final otherUserNotification = NotificationModel(
        silent: false,
        userId: matchedUser.uid,
        title: "Congratulations, You have a new connection.",
        subtitle: "",
        type: NotificationType.match,
        createdAt: DateTime.now(),
        chatDescription: chatDescription,
      );

      final otherUserNotificationRef =
          FirebaseConstants.notificationCollectionRef.doc();
      batch.set(otherUserNotificationRef, otherUserNotification.toJson());

      await batch.commit();

      return chatDescription;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("createChatRoom Connection");

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  Future<ChatDescription> getChatRoomDescription(String chatRoomId) async {
    try {
      final snapshot =
          await FirebaseConstants.chatCollectionRef.doc(chatRoomId).get();
      if (snapshot.exists) {
        final data = ChatDescription.fromJson(snapshot.data());
        return data;
      }
      return null;
    } on FirebaseException catch (e) {
      print(e.toString());
      FirebaseCrashlytics.instance.log("getChatRoomDescription");

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));
      throw Exception(e.message);
    }
  }

  @override
  Future<List<ChatDescription>> getChatHistory(String userId) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      final snapshot = await FirebaseConstants.chatCollectionRef
          .where("users", arrayContains: userId)
          .get();

      final data =
          snapshot.docs.map((e) => ChatDescription.fromJson(e.data())).toList();
      return data;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getChatHistory");

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));
      throw Exception(e.message);
    }
  }

  @override
  Stream<List<ChatDescription>> getChatHistoryStream(
    String userId,
  ) {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      final snapshotStream = FirebaseConstants.chatCollectionRef
          .where("users", arrayContains: userId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((e) => ChatDescription.fromJson(e.data()))
              .toList());

      return snapshotStream;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getChatHistoryStream");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  @override
  Future<List<ChatMessage>> getFewLatestMessages(
      String chatRoomId, int limit) async {
    try {
      final userId = FirebaseAuth.instance.currentUser.uid;

      final snapshot = await FirebaseConstants.chatCollectionRef
          .doc(chatRoomId)
          .collection('messages')
          .where('users', arrayContains: userId)
          .orderBy('timeStamp', descending: true)
          .limit(limit)
          .get();
      var data = [];
      data = snapshot.docs.reversed
          .map((e) => ChatMessage.fromJson(e.data()))
          .toList();

      return data;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getFewLatestMessages");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(chatRoomId ?? "ChatRoom");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  @override
  Future<List<ChatMessage>> getFewPreviousMessages(
      String chatRoomId, int lastTimeStamp, int limit) async {
    if (lastTimeStamp != null) {
      try {
        final userId = FirebaseAuth.instance.currentUser.uid;
        final snapshot = await FirebaseConstants.chatCollectionRef
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('timeStamp', descending: true)
            .where('timeStamp', isLessThan: lastTimeStamp)
            .where('users', arrayContains: userId)
            .limit(limit)
            .get();
        var data = [];
        data = snapshot.docs.reversed
            .map((e) => ChatMessage.fromJson(e.data()))
            .toList();

        return data;
      } on FirebaseException catch (e) {
        FirebaseCrashlytics.instance.log("getFewPreviousMessages");
        FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
        FirebaseCrashlytics.instance.log(chatRoomId ?? "CHATROOMID");

        FirebaseCrashlytics.instance
            .recordFlutterError(FlutterErrorDetails(exception: e));
        throw Exception(e.message);
      }
    } else {
      return getFewLatestMessages(chatRoomId, limit);
    }
  }

  @override
  Stream<List<ChatMessage>> getChatMessageStream(
      String chatRoomId, int latestMessageTimeStamp) {
    final condition = latestMessageTimeStamp ?? 0;

    try {
      final userId = FirebaseAuth.instance.currentUser.uid;
      final snapshotStream = FirebaseConstants.chatCollectionRef
          .doc(chatRoomId)
          .collection('messages')
          .where('timeStamp', isGreaterThan: condition)
          .where('users', arrayContains: userId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((e) => ChatMessage.fromJson(e.data()))
              .toList());

      return snapshotStream;
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getChatMessageStream");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(chatRoomId ?? "ChatRoomID");

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));
      throw Exception(e.message);
    }
  }

  @override
  Future<void> postChatMessage(
      ChatDescription chatDescription, ChatMessage message) async {
    try {
      if (chatDescription.users.length < 2) {
        return;
      }

      WriteBatch batch = FirebaseFirestore.instance.batch();

      final messageRef = FirebaseConstants.chatCollectionRef
          .doc(chatDescription.chatRoomId)
          .collection('messages')
          .doc();

      final newMessage = message.copyWithMessageId(messageRef.id);

      final chatListRef =
          FirebaseConstants.chatCollectionRef.doc(chatDescription.chatRoomId);
      final newChatDescription = ChatDescription(lastMessage: newMessage);

      final userId = FirebaseAuth.instance.currentUser.uid;

      String userName;
      String otherUserId;

      if (userId == chatDescription.user1Id) {
        userName = chatDescription.user1Name;
        otherUserId = chatDescription.user2Id;
      } else {
        userName = chatDescription.user2Name;
        otherUserId = chatDescription.user1Id;
      }

      final otherUserNotification = NotificationModel(
          silent: false,
          userId: otherUserId,
          title: "$userName sent you a message.",
          subtitle: newMessage.message,
          type: NotificationType.message,
          chatDescription: chatDescription.copyWith(newMessage),
          createdAt: DateTime.now());

      final otherUserNotificationRef =
          FirebaseConstants.notificationCollectionRef.doc();

      batch.set(messageRef, newMessage.toJson(), SetOptions(merge: true));
      batch.set(
          chatListRef, newChatDescription.toJson(), SetOptions(merge: true));
      batch.set(otherUserNotificationRef, otherUserNotification.toJson());

      await batch.commit();
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("getChatMessageStream");

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));
      print(e);
      throw Exception(e.message);
    }
  }

  @override
  Future<void> updateTyping(String chatRoomId, Typing isTyping) async {
    try {
      final userId = FirebaseAuth.instance.currentUser.uid;
      final chatListRef = FirebaseConstants.chatCollectionRef
          .doc(chatRoomId)
          .collection("isTyping")
          .doc(userId);
      await chatListRef.set(isTyping.toJson(), SetOptions(merge: true));
      print(isTyping);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> deleteChatRoom(String chatRoomId) async {
    try {
      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(chatRoomId);
      await chatRoomRef.delete();
      return;
    } on FirebaseException catch (e, stack) {
      FirebaseCrashlytics.instance.log("deleteChatRoom");

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e, stack: stack));

      throw Exception(e.message);
    }
  }

  @override
  Future<void> removeChatMessageForSelf({
    @required String chatRoomId,
    @required String messageId,
    @required ChatMessage lastMessage,
    @required bool updateChatHistoryList,
  }) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final userId = FirebaseAuth.instance.currentUser.uid;

      final messageRef = FirebaseConstants.chatCollectionRef
          .doc(chatRoomId)
          .collection("messages")
          .doc(messageId);

      batch.update(
        messageRef,
        {
          'users': FieldValue.arrayRemove(
            [userId],
          )
        },
      );

      if (updateChatHistoryList) {
        final chatListRef = FirebaseConstants.chatCollectionRef.doc(chatRoomId);
        final chatDescription = ChatDescription(lastMessage: lastMessage);
        batch.set(
            chatListRef, chatDescription.toJson(), SetOptions(merge: true));
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("removeChatMessageForSelf");

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  @override
  Future<void> addBlockToChatRoom(
      {String chatRoomId, List<String> uids}) async {
    try {
      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(chatRoomId);

      await chatRoomRef.update(
        {
          'blockedBy': FieldValue.arrayUnion(
            uids,
          ),
          'connectionEndedBy': FirebaseAuth.instance.currentUser.uid,
          'users': FieldValue.delete(),
        },
      );
    } on FirebaseException catch (e, stack) {
      FirebaseCrashlytics.instance.log("addBlockToChatRoom");
      FirebaseCrashlytics.instance.log(chatRoomId);
      FirebaseCrashlytics.instance.log(uids.toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e, stack: stack));

      throw Exception(e.message);
    }
  }

  @override
  Future<void> removeBlockFromChatRoom(
      {String chatRoomId, List<String> uids}) async {
    try {
      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(chatRoomId);

      await chatRoomRef.update(
        {
          'blockedBy': FieldValue.arrayRemove(
            uids,
          )
        },
      );
    } on FirebaseException catch (e, stack) {
      FirebaseCrashlytics.instance.log("removeBlockFromChatRoom");
      FirebaseCrashlytics.instance.log(chatRoomId);
      FirebaseCrashlytics.instance.log(uids.toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e, stack: stack));

      throw Exception(e.message);
    }
  }

  @override
  Future<void> addUserToChatRoom({String chatRoomId, List<String> uids}) async {
    try {
      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(chatRoomId);

      await chatRoomRef.update(
        {
          'users': FieldValue.arrayUnion(
            uids,
          )
        },
      );
    } on FirebaseException catch (e, stack) {
      FirebaseCrashlytics.instance.log("removeUserFromChatRoom");
      FirebaseCrashlytics.instance.log(chatRoomId);
      FirebaseCrashlytics.instance.log(uids.toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e, stack: stack));

      throw Exception(e.message);
    }
  }

  @override
  Future<void> removeUsersFromChatRoom(
      {String chatRoomId, List<String> uids}) async {
    try {
      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(chatRoomId);

      await chatRoomRef.update(
        {
          'users': FieldValue.arrayRemove(
            uids,
          )
        },
      );
    } on FirebaseException catch (e, stack) {
      FirebaseCrashlytics.instance.log("removeUserFromChatRoom");
      FirebaseCrashlytics.instance.log(chatRoomId);
      FirebaseCrashlytics.instance.log(uids.toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e, stack: stack));

      throw Exception(e.message);
    }
  }

  @override
  Future<void> removeConnectionToChatRoom({
    @required String chatRoomId,
    @required String endedByUid,
  }) async {
    try {
      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(chatRoomId);

      await chatRoomRef.update(
        {
          'connectionEndedBy': endedByUid,
          'users': FieldValue.delete(),
        },
      );
    } on FirebaseException catch (e, stack) {
      FirebaseCrashlytics.instance.log("removeConnectionToChatRoom");
      FirebaseCrashlytics.instance.log(chatRoomId);
      FirebaseCrashlytics.instance.log(endedByUid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e, stack: stack));
      if (e.code == "not-found") {
        return;
      }

      throw Exception(e.message);
    }
  }

  @override
  Future<void> resetConnectionToChatRoom(
      {String chatRoomId, String uid}) async {
    try {
      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(chatRoomId);

      await chatRoomRef.update(
        {'connectionEndedBy': null},
      );
    } on FirebaseException catch (e, stack) {
      FirebaseCrashlytics.instance.log("resetConnectionToChatRoom");
      FirebaseCrashlytics.instance.log(chatRoomId);
      FirebaseCrashlytics.instance.log(uid);
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e, stack: stack));

      throw Exception(e.message);
    }
  }
}
