import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';

abstract class DiscoverEvent extends Equatable {}

class DiscoverUsersEvent extends DiscoverEvent {
  @override
  List<Object> get props => [];
}

class ReloadUserEvent extends DiscoverEvent {
  final String lastUserId;
  ReloadUserEvent(this.lastUserId);
  @override
  List<Object> get props => [lastUserId];
}

class LikeUserEvent extends DiscoverEvent {
  final DiscoveredUser user;
  LikeUserEvent(this.user);
  @override
  List<Object> get props => [user];
}

class DislikeUserEvent extends DiscoverEvent {
  final DiscoveredUser user;
  DislikeUserEvent(this.user);
  @override
  List<Object> get props => [user];
}
