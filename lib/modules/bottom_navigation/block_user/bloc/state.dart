import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/block_user/bloc/blocked_users.dart';

enum BlockServiceStatus {
  initial,
  loading,
  loaded,
  loadingFailed,
  loadingMore,
  loadedMore,
  loadingMoreFailed,
  blocking,
  blocked,
  blockingFailed,
  unblocking,
  unblocked,
  unblockingFailed,
}

class BlockState extends Equatable {
  final List<BlockedUser> blockedUsers;

  final BlockServiceStatus status;
  final String serviceMessage;

  BlockState({
    this.blockedUsers = const [],
    this.status = BlockServiceStatus.initial,
    this.serviceMessage = "",
  });

  BlockState copyWith({
    final List<BlockedUser> blockedUsers,
    BlockServiceStatus status,
    String serviceMessage,
  }) {
    return BlockState(
      blockedUsers: blockedUsers ?? this.blockedUsers,
      serviceMessage: serviceMessage ?? this.serviceMessage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        status,
        serviceMessage,
        blockedUsers,
      ];
}
