import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/helper/firebase_constants.dart';
import 'package:yopp/modules/_common/models/notificationModel.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_message.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

abstract class ChatService {
  Future<ChatDescription> createChatRoom(
      UserProfile user, DiscoveredUser matchedUser);
  Future<List<ChatDescription>> getChatHistory(String userId);
  Stream<List<ChatDescription>> getChatHistoryStream(String userId);
  Future<List<ChatMessage>> getFewLatestMessages(String chatRoomId, int limit);

  Future<List<ChatMessage>> getFewPreviousMessages(
      String chatRoomId, int lastTimeStamp, int limit);
  Stream<List<ChatMessage>> getChatMessageStream(
      String chatRoomId, int latestMessageTimeStamp);
  Future<void> postChatMessage(
      ChatDescription chatDescription, ChatMessage chatMessage);

  Future<void> removeSelfFromChatRoom(String chatRoomId);

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
  Future<ChatDescription> createChatRoom(
      UserProfile user, DiscoveredUser matchedUser) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      final createdTime = DateTime.now();
      final chatId =
          _createChatId(user.selectedSport.name, user.uid, matchedUser.uid);

      final ChatMessage chatMessage = ChatMessage(
          messageId: chatId,
          message: "Congratulations, You Matched!!",
          timeStamp: createdTime,
          sender: "Admin",
          users: [user.uid, matchedUser.uid],
          type: "Text");

      final chatDescription = ChatDescription(
        chatRoomId: chatId,
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
        sportName: user.selectedSport.name,
      );

      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(chatId);
      batch.set(chatRoomRef, chatDescription.toJson(), SetOptions(merge: true));

      final userNotification = NotificationModel(
          silent: true,
          userId: user.uid,
          title: "Congratulations, You have a new match.",
          subtitle: user.selectedSport.name,
          createdAt: DateTime.now(),
          type: NotificationType.match,
          chatDescription: chatDescription);
      final userNotificationRef =
          FirebaseConstants.notificationCollectionRef.doc();
      batch.set(userNotificationRef, userNotification.toJson());

      final otherUserNotification = NotificationModel(
        silent: false,
        userId: matchedUser.uid,
        title: "Congratulations, You have a new match.",
        subtitle: user.selectedSport.name,
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
      FirebaseCrashlytics.instance.log("createChatRoom");
      FirebaseCrashlytics.instance.log(user.toJson().toString());
      FirebaseCrashlytics.instance.log(matchedUser.toJson().toString());
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }

  String _createChatId(String sportName, String userId, String otherUserId) {
    var chatId = sportName + "_";
    if (userId.compareTo(otherUserId) > 0) {
      chatId += userId + "_" + otherUserId;
    } else {
      chatId += otherUserId + "_" + userId;
    }
    return chatId;
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
      FirebaseCrashlytics.instance.log(userId);

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
      FirebaseCrashlytics.instance.log(userId);

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
      FirebaseCrashlytics.instance.log(chatRoomId);
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
        FirebaseCrashlytics.instance.log(chatRoomId);
        FirebaseCrashlytics.instance.log(lastTimeStamp.toString());
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
      FirebaseCrashlytics.instance.log(chatRoomId);
      FirebaseCrashlytics.instance.log(latestMessageTimeStamp.toString());
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
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(chatDescription.toJson().toString());
      FirebaseCrashlytics.instance.log(message.toJson().toString());
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
  Future<void> removeSelfFromChatRoom(String chatRoomId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser.uid;
      final chatRoomRef = FirebaseConstants.chatCollectionRef.doc(chatRoomId);

      await chatRoomRef.update(
        {
          'users': FieldValue.arrayRemove(
            [userId],
          )
        },
      );
    } on FirebaseException catch (e) {
      FirebaseCrashlytics.instance.log("removeSelfFromChatRoom");
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(chatRoomId);

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

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
      FirebaseCrashlytics.instance.log(FirebaseAuth.instance.currentUser.uid);
      FirebaseCrashlytics.instance.log(chatRoomId);
      FirebaseCrashlytics.instance.log(messageId);
      FirebaseCrashlytics.instance.log(lastMessage.toJson().toString());
      FirebaseCrashlytics.instance.log(updateChatHistoryList.toString());

      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e));

      throw Exception(e.message);
    }
  }
}
