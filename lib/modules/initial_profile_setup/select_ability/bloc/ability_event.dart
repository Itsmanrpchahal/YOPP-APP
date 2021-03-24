import 'package:equatable/equatable.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';

abstract class EditAblityEvent extends Equatable {}

class SaveSelectedAbilityEvent extends EditAblityEvent {
  final UserSport userSport;
  final double height;
  final double weight;

  SaveSelectedAbilityEvent({
    this.userSport,
    this.height,
    this.weight,
  });

  @override
  List<Object> get props => [userSport, height, weight];
}

class SaveAbilityEvent extends EditAblityEvent {
  final UserSport userSport;
  final double height;
  final double weight;

  SaveAbilityEvent({
    this.userSport,
    this.height,
    this.weight,
  });

  @override
  List<Object> get props => [userSport, height, weight];
}
