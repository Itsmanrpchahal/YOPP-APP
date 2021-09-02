import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_message.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_service.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/bloc/chat_event.dart';
import 'package:yopp/modules/bottom_navigation/chat/chat_detail/bloc/chat_state.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_service.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatService service;
  final ProfileService _profileService;
  final String chatRoomId;
  final intialMsgCount = 10;

  StreamSubscription _streamSubscription;

  ChatBloc(this.service, this.chatRoomId, this._profileService)
      : super(ChatState());

  @override
  Future<void> close() async {
    print("Chat Bloc Closed");

    _streamSubscription = null;
    return super.close();
  }

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is BlockUserEvent) {
      try {
        yield (state.copyWith(
            status: ChatStatus.blocking, serviceMessage: "Blocking"));
        await _profileService.blockProfile(
            friendId: event.friendId, myId: event.myId);
        await service.addBlockToChatRoom(
            chatRoomId: event.chatRoomId, uids: [event.myId]);
        yield (state.copyWith(
            status: ChatStatus.blocked, serviceMessage: "Blocked User"));
      } catch (e) {
        yield (state.copyWith(
            status: ChatStatus.failure, serviceMessage: e.toString()));
      }
    }

    if (event is LoadInitialMessageEvent) {
      try {
        yield (state.copyWith(
            status: ChatStatus.loadingInitial, serviceMessage: "Loading"));
        final user = await _profileService.loadProfile(event.otherUserId);
        final chatRoom = await service.getChatRoomDescription(event.chatRoomId);
        final initialMessages =
            await service.getFewLatestMessages(chatRoomId, intialMsgCount);

        yield (state.copyWith(
          chatMessages: formatedMessages(initialMessages),
          chatRoom: chatRoom,
          otherUser: user,
          status: ChatStatus.loadingInitialSuccess,
        ));

        if (initialMessages.isNotEmpty) {
          add(ObserveLatestMessageEvent(
              initialMessages.last.timeStamp.microsecondsSinceEpoch));
        } else {
          add(ObserveLatestMessageEvent(0));
        }
      } catch (e) {
        yield (state.copyWith(
            status: ChatStatus.failure, serviceMessage: e.toString()));
      }
    }

    if (event is LoadPreviousMessageEvent) {
      try {
        yield (state.copyWith(
            status: ChatStatus.loadingPrevious, serviceMessage: "Loading"));

        if (state.chatMessages.length == 0) {
          yield (state.copyWith(
              chatMessages: state.chatMessages,
              status: ChatStatus.loadingPreviousSuccess));
          return;
        }

        int lastTimeStamp =
            state.chatMessages.first?.timeStamp?.microsecondsSinceEpoch;
        final previousMessages = await service.getFewPreviousMessages(
            chatRoomId, lastTimeStamp, intialMsgCount);

        final allMessages = state.chatMessages;
        allMessages.insertAll(0, previousMessages);

        yield (state.copyWith(
            chatMessages: formatedMessages(allMessages),
            status: ChatStatus.loadingPreviousSuccess));
      } catch (e) {
        yield (state.copyWith(
            status: ChatStatus.failure, serviceMessage: e.toString()));
      }
    }

    if (event is ObserveLatestMessageEvent) {
      try {
        yield (state.copyWith(status: ChatStatus.observingNew));
        await _streamSubscription?.cancel();
        final stream =
            service.getChatMessageStream(chatRoomId, event.latestMsgTimeStamp);

        _streamSubscription = stream.listen((chatMessages) {
          if (chatMessages.isNotEmpty) {
            print(chatMessages.toString());
            add(GotObservedMessageEvent(chatMessages.last));
          } else {
            print("chat message is empty");
          }
        }, onError: (error, stacktrace) {
          print("onserving error");
        }, onDone: () {
          print("DOne observing");
        }, cancelOnError: false);
      } catch (error, _) {
        print(error);
        yield (state.copyWith(
            status: ChatStatus.failure, serviceMessage: error.toString()));
      }
    }

    if (event is GotObservedMessageEvent) {
      final allMessages = state.chatMessages;

      final index = allMessages.indexWhere(
          (element) => element.messageId == event.chatMessage.messageId);

      if (index == -1) {
        allMessages.add(event.chatMessage);
      } else {
        print(index);
        allMessages.removeAt(index);
        allMessages.insert(index, event.chatMessage);
      }

      yield (state.copyWith(
          chatMessages: formatedMessages(allMessages),
          status: ChatStatus.observedNew,
          serviceMessage: allMessages.length.toString()));
    }

    if (event is PostChatMessageEvent) {
      try {
        final newMessage = ChatMessage(
            message: event.message,
            type: event.messageType,
            timeStamp: DateTime.now(),
            sender: FirebaseAuth.instance.currentUser.uid,
            users: event.chatDescription.users);

        service.postChatMessage(event.chatDescription, newMessage);
      } catch (e) {
        yield (state.copyWith(
            status: ChatStatus.failure, serviceMessage: e.toString()));
      }
    }

    if (event is RemoveMessageForSelfEvent) {
      try {
        yield (state.copyWith(status: ChatStatus.deleting));
        final messages = state.chatMessages;
        messages.removeWhere((element) => element.type == "timeStamp");

        ChatMessage message = messages
            .firstWhere((element) => element.messageId == event.messageId);
        final userId = FirebaseAuth.instance.currentUser.uid;
        message.users.remove(userId);

        await service.removeChatMessageForSelf(
          chatRoomId: chatRoomId,
          messageId: event.messageId,
          lastMessage: message,
          updateChatHistoryList: messages.last.messageId == event.messageId,
        );

        messages.removeWhere((element) => element.messageId == event.messageId);
        yield (state.copyWith(
            status: ChatStatus.deleted,
            chatMessages: formatedMessages(messages)));
      } catch (e) {
        yield (state.copyWith(
            status: ChatStatus.failure, serviceMessage: e.toString()));
      }
    }

    if (event is UpdateTypingEvent) {
      try {
        service.updateTyping(chatRoomId, event.isTyping);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  List<ChatMessage> formatedMessages(List<ChatMessage> messages) {
    messages
        .removeWhere((element) => element.type.toLowerCase() == 'timestamp');
    DateTime lastTimeStamp;

    var chatMessages = List<ChatMessage>();

    for (ChatMessage message in messages) {
      String timeString = "";
      final currentTime = DateTime.now();
      final msgTimeStamp = message.timeStamp;

      if (lastTimeStamp == null) {
        if (currentTime.year == msgTimeStamp.year &&
            currentTime.month == msgTimeStamp.month &&
            currentTime.day == msgTimeStamp.day) {
          timeString = DateFormat.Hm('en_US').format(message.timeStamp);
        } else {
          timeString =
              DateFormat.yMd('en_US').add_Hm().format(message.timeStamp);
        }

        final timeMessage = ChatMessage(
          message: timeString,
          timeStamp: message.timeStamp,
          type: "timeStamp",
        );
        lastTimeStamp = message.timeStamp;
        chatMessages.add(timeMessage);
      } else {
        if (currentTime.year == msgTimeStamp.year &&
            currentTime.month == msgTimeStamp.month &&
            currentTime.day == msgTimeStamp.day) {
          timeString = DateFormat.Hm('en_US').format(message.timeStamp);

          final difference = message.timeStamp.difference(lastTimeStamp);

          if (difference.inMinutes > 10) {
            timeString = DateFormat.Hm('en_US').format(message.timeStamp);
            final timeMessage = ChatMessage(
              message: timeString,
              timeStamp: message.timeStamp,
              type: "timeStamp",
            );
            lastTimeStamp = message.timeStamp;
            chatMessages.add(timeMessage);
          }
        }
      }

      chatMessages.add(message);
    }

    return chatMessages;
  }
}
