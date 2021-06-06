import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';

abstract class ProfileEvent extends Equatable {}

class SetUserProfileEvent extends ProfileEvent {
  final UserProfile profile;
  final List<InterestOption> interests;
  final int connectionCount;
  SetUserProfileEvent({this.profile, this.interests, this.connectionCount});
  @override
  List<Object> get props => [profile, connectionCount];
}

class LoadUserProfileEvent extends ProfileEvent {
  final String userId;

  LoadUserProfileEvent({
    this.userId,
  });

  @override
  List<Object> get props => [userId];
}

class UpdateUserProfileEvent extends ProfileEvent {
  final UserProfile profile;
  final File image;
  final addSportAfterCompletion;

  UpdateUserProfileEvent({
    this.profile,
    this.image,
    this.addSportAfterCompletion = false,
  });

  @override
  List<Object> get props => [profile, image, addSportAfterCompletion];
}

class SelectInterestEvent extends ProfileEvent {
  final Interest interest;

  SelectInterestEvent(this.interest);

  @override
  List<Object> get props => [interest];
}

class DeleteInterestEvent extends ProfileEvent {
  final String interestId;

  DeleteInterestEvent(this.interestId);

  @override
  List<Object> get props => [interestId];
}

class AddNewInterestEvent extends ProfileEvent {
  final Interest interest;

  AddNewInterestEvent({
    this.interest,
  });

  @override
  List<Object> get props => [
        interest,
      ];
}

class UpdatePreferedInterestEvent extends ProfileEvent {
  final Interest interest;

  UpdatePreferedInterestEvent({
    this.interest,
  });

  @override
  List<Object> get props => [
        interest,
      ];
}

class UpdateInterestEvent extends ProfileEvent {
  final Interest interest;

  UpdateInterestEvent({
    this.interest,
  });

  @override
  List<Object> get props => [
        interest,
      ];
}
