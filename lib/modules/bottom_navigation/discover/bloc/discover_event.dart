import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/search_page.dart';

abstract class DiscoverEvent extends Equatable {}

enum SearchBy {
  interest,
  category,
  subCategory,
}

class DiscoverUsersEvent extends DiscoverEvent {
  final UserProfile currentUser;
  final SearchBy searchBy;
  final SearchRange searchRange;
  final bool showOnlineOnly;
  final Interest selectedInterest;

  DiscoverUsersEvent({
    @required this.currentUser,
    @required this.searchBy,
    @required this.searchRange,
    @required this.showOnlineOnly,
    @required this.selectedInterest,
  });

  @override
  List<Object> get props => [
        currentUser,
        searchBy,
        searchRange,
        showOnlineOnly,
        selectedInterest,
      ];
}

class LoadMoreDiscoveredUserEvent extends DiscoverEvent {
  LoadMoreDiscoveredUserEvent();
  @override
  List<Object> get props => [];
}
