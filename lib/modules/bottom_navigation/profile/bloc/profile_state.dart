import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

enum ProfileServiceStatus {
  none,
  loading,
  loaded,
  loadingFailed,

  updating,
  updated,
  updatedAndAddSportPending,
  updateFailed,

  deleting,
  deleted,
  deleteFailed,
}

class ProfileState extends Equatable {
  final ProfileServiceStatus status;
  final UserProfile userProfile;
  final List<InterestOption> interestOptions;
  final int connectionCount;
  final String message;

  ProfileState({
    @required this.status,
    @required this.userProfile,
    @required this.message,
    this.interestOptions = const [],
    this.connectionCount = 0,
  });

  ProfileState copyWith(
      {UserProfile userProfile,
      List<InterestOption> interestOptions,
      ProfileServiceStatus status,
      String message,
      int connectionCount}) {
    return ProfileState(
      status: status ?? this.status,
      message: message ?? this.message,
      userProfile: userProfile ?? this.userProfile,
      interestOptions: interestOptions ?? this.interestOptions,
      connectionCount: connectionCount ?? this.connectionCount,
    );
  }

  @override
  List<Object> get props =>
      [status, message, userProfile, interestOptions, connectionCount];
}
