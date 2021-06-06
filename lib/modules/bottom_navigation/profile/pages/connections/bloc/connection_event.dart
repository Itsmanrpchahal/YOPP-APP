import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

import 'api_connection_data.dart';
import 'connections_bloc.dart';

abstract class ConnectionsEvent extends Equatable {}

class AddConnectionEvent extends ConnectionsEvent {
  final UserProfile user;
  final AddConnectionData otherUser;

  AddConnectionEvent({
    @required this.user,
    @required this.otherUser,
  });

  @override
  List<Object> get props => [user, otherUser];
}

class ChatToConnectionEvent extends ConnectionsEvent {
  final ConnectionData connectionData;

  ChatToConnectionEvent({
    @required this.connectionData,
  });

  @override
  List<Object> get props => [connectionData];
}

class LoadConnectionEvent extends ConnectionsEvent {
  LoadConnectionEvent();

  @override
  List<Object> get props => [];
}

class LoadMoreConnectionEvent extends ConnectionsEvent {
  LoadMoreConnectionEvent();
  @override
  List<Object> get props => [];
}

class DeleteConnectionEvent extends ConnectionsEvent {
  final List<String> uids;
  final String connectionId;
  DeleteConnectionEvent({
    @required this.connectionId,
    @required this.uids,
  });
  @override
  List<Object> get props => [connectionId, uids];
}
