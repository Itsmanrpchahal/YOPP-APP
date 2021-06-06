import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_description.dart';

import 'api_connection_data.dart';

enum ConnectionServiceStatus {
  initial,
  creatingConnection,
  readyForChat,
  connectionFailed,
  loading,
  loaded,
  loadingFailed,
  loadingMore,
  loadedMore,
  loadingMoreFailed,
  deleting,
  deleted,
  deletingFailed,
}

class ConnectionsState {
  final ConnectionServiceStatus serviceStatus;
  final String message;
  final UserConnection userConnection;
  final int pageNumber;
  final ChatDescription chatRoomCreated;

  ConnectionsState({
    this.serviceStatus = ConnectionServiceStatus.initial,
    this.message = "",
    this.userConnection,
    this.pageNumber = 0,
    this.chatRoomCreated,
  });

  ConnectionsState copyWith({
    ConnectionServiceStatus serviceStatus,
    String message,
    UserConnection userConnection,
    int pageNumber,
    final ChatDescription chatRoom,
  }) {
    return ConnectionsState(
      serviceStatus: serviceStatus ?? this.serviceStatus,
      message: message ?? this.message,
      userConnection: userConnection ?? this.userConnection,
      pageNumber: pageNumber ?? this.pageNumber,
      chatRoomCreated: chatRoom,
    );
  }
}
