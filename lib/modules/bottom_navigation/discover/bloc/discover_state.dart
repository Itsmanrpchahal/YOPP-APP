import 'package:equatable/equatable.dart';
import 'package:yopp/modules/bottom_navigation/discover/bloc/discovered_user.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/bottom_navigation/profile/pages/search/search_page.dart';

import 'discover_event.dart';

enum DiscoverServiceStatus {
  initial,
  noLocation,
  loading,
  loaded,
  loadingFailed,
  loadingAnotherPage,
  loadedAnotherPage,
  loadingAnotherPageFailed,
}

class DiscoverState extends Equatable {
  final DiscoverServiceStatus status;
  final String message;
  final List<DiscoveredUserData> data;
  final Meta meta;
  final UserProfile user;
  final Interest selectedInterest;

  final int skip;
  final SearchBy searchBy;
  final SearchRange searchRange;
  final bool showOnlineOnly;

  final int interestCount;
  final int availableCount;
  final int specificCount;

  DiscoverState({
    this.status = DiscoverServiceStatus.initial,
    this.message = "",
    this.user,
    this.meta,
    this.data = const [],
    this.skip = 0,
    this.searchBy = SearchBy.category,
    this.searchRange,
    this.showOnlineOnly = false,
    this.selectedInterest,
    this.interestCount,
    this.availableCount,
    this.specificCount,
  });

  DiscoverState copyWith({
    DiscoverServiceStatus status,
    String message,
    UserProfile user,
    int skip,
    SearchBy searchBy,
    SearchRange searchRange,
    bool showOnlineOnly,
    Interest selectedInterest,
    int interestCount,
    int availableCount,
    int specificCount,
    List<DiscoveredUserData> data,
    Meta meta,
  }) {
    return DiscoverState(
      status: status ?? this.status,
      message: message ?? this.message,
      meta: meta ?? this.meta,
      data: data ?? this.data,
      user: user ?? this.user,
      skip: skip ?? this.skip,
      searchBy: searchBy ?? this.searchBy,
      searchRange: searchRange ?? this.searchRange,
      showOnlineOnly: showOnlineOnly ?? this.showOnlineOnly,
      selectedInterest: selectedInterest ?? this.selectedInterest,
      interestCount: interestCount ?? this.interestCount,
      availableCount: availableCount ?? this.availableCount,
      specificCount: specificCount ?? this.specificCount,
    );
  }

  @override
  List<Object> get props => [
        status,
        message,
        meta,
        data,
        user,
        searchBy,
        searchRange,
        showOnlineOnly,
        selectedInterest,
        interestCount,
        availableCount,
        specificCount,
      ];
}
