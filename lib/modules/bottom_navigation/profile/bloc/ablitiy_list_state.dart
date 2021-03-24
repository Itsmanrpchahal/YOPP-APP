import 'package:equatable/equatable.dart';

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';

enum AbilityListStatus {
  none,
  loading,
  loaded,
  selecting,
  selected,
  deleting,
  deleted,
  failure
}

class AbilityListState extends Equatable {
  final List<UserSport> sports;
  final AbilityListStatus status;
  final String message;

  AbilityListState({this.status, this.message, this.sports});

  AbilityListState copyWith({
    List<UserSport> sports,
    AbilityListStatus status,
    String message,
  }) {
    return AbilityListState(
        status: status ?? this.status,
        message: message ?? this.message,
        sports: sports ?? this.sports);
  }

  @override
  List<Object> get props => [sports, status, message];
}
