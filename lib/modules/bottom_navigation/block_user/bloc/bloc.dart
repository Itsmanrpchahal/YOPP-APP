import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yopp/helper/connection_id.dart';
import 'package:yopp/modules/bottom_navigation/block_user/bloc/event.dart';
import 'package:yopp/modules/bottom_navigation/block_user/bloc/state.dart';
import 'package:yopp/modules/bottom_navigation/chat/bloc/chat_service.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/profile_service.dart';

class BlockedUserBloc extends Bloc<BlockEvent, BlockState> {
  final ProfileService service;
  final ChatService chatService;
  final int _limit = 20;
  int _skip = 0;

  BlockedUserBloc(this.service, this.chatService) : super(BlockState());

  @override
  Stream<BlockState> mapEventToState(BlockEvent event) async* {
    if (event is LoadBlockedUserEvent) {
      try {
        yield state.copyWith(
            status: BlockServiceStatus.loading, serviceMessage: "Loading...");
        final users = await service.loadBlockedProfile(
          uid: FirebaseAuth.instance.currentUser.uid,
          limit: _limit,
          skip: 0,
        );
        print("success");
        print(users.toRawJson());
        _skip = users.data?.length ?? 0;

        yield state.copyWith(
            status: BlockServiceStatus.loaded,
            serviceMessage: "",
            blockedUsers: users.data);
      } catch (error) {
        yield state.copyWith(
          status: BlockServiceStatus.loadingFailed,
          serviceMessage: error.toString(),
        );
      }
    }

    if (event is LoadMoreBlockedUserEvent) {
      if (state.blockedUsers == null) {
        add(LoadBlockedUserEvent());
      } else {
        try {
          yield state.copyWith(
              status: BlockServiceStatus.loadingMore,
              serviceMessage: "Loading...");
          final users = await service.loadBlockedProfile(
              uid: FirebaseAuth.instance.currentUser.uid,
              limit: _limit,
              skip: _skip);

          state.blockedUsers.addAll(users.data);

          yield state.copyWith(
              status: BlockServiceStatus.loaded,
              serviceMessage: "",
              blockedUsers: state.blockedUsers);
        } catch (error) {
          yield state.copyWith(
            status: BlockServiceStatus.loadingMoreFailed,
            serviceMessage: error.toString(),
          );
        }
      }
    }

    if (event is UnblockUserEvent) {
      try {
        yield state.copyWith(
            status: BlockServiceStatus.blocked,
            serviceMessage: "Unblocking...");

        await service.unblockProfile(
            myId: event.myId, friendId: event.friendId);

        final chatRoomId =
            createConnectionId(myUid: event.myUid, otherUid: event.friendUid);

        await chatService.removeBlockFromChatRoom(
            chatRoomId: chatRoomId, uids: [event.myId]);

        state.blockedUsers
            .removeWhere((element) => element.id == event.friendId);

        yield state.copyWith(
          status: BlockServiceStatus.unblocked,
          serviceMessage: "",
          blockedUsers: state.blockedUsers,
        );
      } catch (error) {
        yield state.copyWith(
          status: BlockServiceStatus.unblockingFailed,
          serviceMessage: error.toString(),
        );
      }
    }
  }
}
