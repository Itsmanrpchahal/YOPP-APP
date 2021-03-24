import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

abstract class MatchedEvent extends Equatable {}

class MatchedUserEvent extends MatchedEvent {
  final UserProfile user;
  final DiscoveredUser otherUser;

  MatchedUserEvent(this.user, this.otherUser);

  @override
  List<Object> get props => [user, otherUser];
}
