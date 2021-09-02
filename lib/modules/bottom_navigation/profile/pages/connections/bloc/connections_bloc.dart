import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/connection_id.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_event.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/connections/bloc/connection_state.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

class AddConnectionData {
  AddConnectionData({
    @required this.avatar,
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.gender,
    @required this.selectedInterest,
  });

  final String avatar;
  final String id;
  final String uid;
  final String name;
  final Gender gender;
  final String selectedInterest;

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "uid": uid == null ? null : uid,
        "name": name == null ? null : name,
        "gender": gender == null ? null : gender.name,
        "selected_interest": selectedInterest == null ? null : selectedInterest,
      };
}

class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  final ConnectionService _service;
  final ChatService _chatService;

  final _dataLimit = 20;

  ConnectionsBloc(this._service, this._chatService) : super(ConnectionsState());

  @override
  Stream<ConnectionsState> mapEventToState(ConnectionsEvent event) async* {
    if (event is AddConnectionEvent) {
      try {
        yield state.copyWith(
          message: "Loading...",
          serviceStatus: ConnectionServiceStatus.creatingConnection,
        );
        final connectionId = createConnectionId(
            myUid: event.user.uid, otherUid: event.otherUser.uid);

        ChatDescription chatRoom =
            await _chatService.getChatRoomDescription(connectionId);

        if (chatRoom == null) {
          print("chatRoom = null");
          print("_service.addConnection");
          await _service.addConnection(
            friendID: event.otherUser.id,
            friendInterest: event.otherUser.selectedInterest,
            myID: event.user.id,
            myInterest: event.user.getSelectedInterestDescription(),
            connectionId: connectionId,
          );
          print("_chatService.createChatRoomConnection");
          final createdChatRoom = await _chatService.createChatRoomConnection(
              event.user, event.otherUser, connectionId);

          yield state.copyWith(
            message: "",
            chatRoom: createdChatRoom,
            serviceStatus: ConnectionServiceStatus.readyForChat,
          );
        } else {
          if (chatRoom.blockedBy != null && chatRoom.blockedBy.isNotEmpty) {
            print("chatRoom.blocked.contains");
            print(chatRoom.blockedBy.toString());
            yield state.copyWith(
              message: (event?.otherUser?.name ?? "Other user") +
                  " is not available for chat.",
              serviceStatus: ConnectionServiceStatus.connectionFailed,
            );
          } else if (chatRoom.connectionEndedBy != null) {
            print("_chatService.createChatRoomConnection");

            print("_service.addConnection");
            await _service.addConnection(
              friendID: event.otherUser.id,
              friendInterest: event.otherUser.selectedInterest,
              myID: event.user.id,
              myInterest: event.user.getSelectedInterestDescription(),
              connectionId: connectionId,
            );
            print("_chatService.createChatRoomConnection");
            final createdChatRoom = await _chatService.createChatRoomConnection(
                event.user, event.otherUser, connectionId);

            yield state.copyWith(
              message: "",
              chatRoom: createdChatRoom,
              serviceStatus: ConnectionServiceStatus.readyForChat,
            );
          } else {
            print(
                "chatRoom.connection is not ended && chatRoom.blocked.doesnt contain");
            print("_service.addConnection");
            await _service.addConnection(
              friendID: event.otherUser.id,
              friendInterest: event.otherUser.selectedInterest,
              myID: event.user.id,
              myInterest: event.user.getSelectedInterestDescription(),
              connectionId: connectionId,
            );

            yield state.copyWith(
              message: "",
              chatRoom: chatRoom,
              serviceStatus: ConnectionServiceStatus.readyForChat,
            );
          }
        }
      } catch (error) {
        yield state.copyWith(
          message: error.toString(),
          serviceStatus: ConnectionServiceStatus.connectionFailed,
        );
      }
    }

    if (event is ChatToConnectionEvent) {
      try {
        yield state.copyWith(
          message: "Loading...",
          serviceStatus: ConnectionServiceStatus.creatingConnection,
        );

        ChatDescription chatRoom = await _chatService
            .getChatRoomDescription(event.connectionData.connectionId);

        if (chatRoom != null) {
          print("chatRoom != null");
          if (chatRoom.blockedBy != null && chatRoom.blockedBy.isNotEmpty) {
            print("chatRoom.blocked.contains");
            yield state.copyWith(
              message: (event.connectionData?.user?.name ?? "Other user") +
                  " is not available for chat.",
              serviceStatus: ConnectionServiceStatus.connectionFailed,
            );
          } else if (chatRoom.connectionEndedBy != null) {
            print("chatRoom.connectionEndedBy != null");
            yield state.copyWith(
              message: (event.connectionData?.user?.name ?? "Other user") +
                  " is not available for chat.",
              serviceStatus: ConnectionServiceStatus.connectionFailed,
            );
          } else {
            print(
                "chatRoom.connection is not ended && chatRoom.blocked.doesn't contains");
            yield state.copyWith(
              message: "",
              chatRoom: chatRoom,
              serviceStatus: ConnectionServiceStatus.readyForChat,
            );
          }
        } else {
          print("chatRoom == null");
          yield state.copyWith(
            message: "Could not find connection. Pull down to refresh page.",
            serviceStatus: ConnectionServiceStatus.connectionFailed,
          );
        }
      } catch (error) {
        yield state.copyWith(
          message: error.toString(),
          serviceStatus: ConnectionServiceStatus.connectionFailed,
        );
      }
    }

    if (event is LoadConnectionEvent) {
      try {
        yield state.copyWith(
          message: "Loading...",
          pageNumber: 0,
          serviceStatus: ConnectionServiceStatus.loading,
        );
        final data = await _service.loadConnections(
          uid: FirebaseAuth.instance.currentUser.uid,
          limit: _dataLimit,
        );

        yield state.copyWith(
            message: "",
            serviceStatus: ConnectionServiceStatus.loaded,
            pageNumber: 0,
            userConnection: data);
      } catch (error) {
        yield state.copyWith(
          message: error.toString(),
          serviceStatus: ConnectionServiceStatus.loadingFailed,
        );
      }
    }

    if (event is LoadMoreConnectionEvent) {
      try {
        yield state.copyWith(
          message: "Loading...",
          serviceStatus: ConnectionServiceStatus.loadingMore,
        );
        final connectionData = await _service.loadConnections(
          uid: FirebaseAuth.instance.currentUser.uid,
          limit: _dataLimit,
          skipto: state.userConnection?.data?.length ?? 0,
        );

        var updated = state.userConnection.data.toList();
        updated.addAll(connectionData.data);

        yield state.copyWith(
            message: "",
            serviceStatus: ConnectionServiceStatus.loadedMore,
            pageNumber: state.pageNumber + 1,
            userConnection: state.userConnection.copyWith(data: updated));
      } catch (error) {
        yield state.copyWith(
          message: error.toString(),
          serviceStatus: ConnectionServiceStatus.loadingMoreFailed,
        );
      }
    }

    if (event is DeleteConnectionEvent) {
      try {
        yield state.copyWith(
          message: "Deleting...",
          serviceStatus: ConnectionServiceStatus.deleting,
        );

        await _service.deleteConnection(
          uids: event.uids,
          connectionId: event.connectionId,
        );

        await _chatService.removeConnectionToChatRoom(
          chatRoomId: event.connectionId,
          endedByUid: FirebaseAuth.instance.currentUser.uid,
        );

        final connections = state.userConnection;
        connections.data.removeWhere(
            (element) => element.connectionId == event.connectionId);

        yield state.copyWith(
            message: "",
            serviceStatus: ConnectionServiceStatus.deleted,
            userConnection: connections);
      } catch (error) {
        yield state.copyWith(
          message: error.toString(),
          serviceStatus: ConnectionServiceStatus.deletingFailed,
        );
      }
    }

    yield state;
  }
}
