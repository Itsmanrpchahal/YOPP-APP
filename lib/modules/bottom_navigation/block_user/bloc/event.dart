import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class BlockEvent extends Equatable {}

class BlockUserEvent extends BlockEvent {
  final String uid;
  final String id;

  BlockUserEvent({@required this.id, @required this.uid});

  @override
  List<Object> get props => [id, uid];
}

class UnblockUserEvent extends BlockEvent {
  final String myId;
  final String myUid;
  final String friendId;
  final String friendUid;

  UnblockUserEvent({
    @required this.friendId,
    @required this.myId,
    @required this.myUid,
    @required this.friendUid,
  });

  @override
  List<Object> get props => [
        friendId,
        myId,
        myUid,
        friendUid,
      ];
}

class LoadBlockedUserEvent extends BlockEvent {
  LoadBlockedUserEvent();

  @override
  List<Object> get props => [];
}

class LoadMoreBlockedUserEvent extends BlockEvent {
  LoadMoreBlockedUserEvent();

  @override
  List<Object> get props => [];
}
