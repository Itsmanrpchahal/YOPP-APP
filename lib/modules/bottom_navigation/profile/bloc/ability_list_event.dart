import 'package:equatable/equatable.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';

abstract class AbilityListEvent extends Equatable {}

class GetAbilityListEvent extends AbilityListEvent {
  final String userId;
  GetAbilityListEvent({this.userId});

  @override
  List<Object> get props => [userId];
}

class SelectSportAbilityEvent extends AbilityListEvent {
  final UserSport sport;

  SelectSportAbilityEvent(this.sport);

  @override
  List<Object> get props => [sport];
}

class DeleteSportAbilityEvent extends AbilityListEvent {
  final String sportName;

  DeleteSportAbilityEvent(this.sportName);

  @override
  List<Object> get props => [sportName];
}
