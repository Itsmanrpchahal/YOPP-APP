import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

enum DiscoverServiceStatus {
  initial,
  noLocation,
  loading,
  loaded,
  failure,
  swping,
  liked,
  disliked,
  matched,
  reloaded,
}

class DiscoverState extends Equatable {
  final DiscoverServiceStatus status;
  final String message;
  final List<DiscoveredUser> users;
  final UserProfile user;
  final DiscoveredUser matchedUser;
  final Meta metaData;

  DiscoverState({
    this.status = DiscoverServiceStatus.initial,
    this.message = "",
    this.user,
    this.matchedUser,
    this.metaData,
    this.users = const [],
  });

  DiscoverState copyWith({
    DiscoverServiceStatus status,
    String message,
    List<DiscoveredUser> users,
    UserProfile user,
    DiscoveredUser matchedUser,
    Meta metaData,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      message: message ?? this.message,
      users: users ?? this.users,
      user: user ?? this.user,
      matchedUser: matchedUser ?? this.matchedUser,
      metaData: metaData ?? this.metaData,
    );
  }

  @override
  List<Object> get props =>
      [status, message, users, matchedUser, user, metaData];
}
