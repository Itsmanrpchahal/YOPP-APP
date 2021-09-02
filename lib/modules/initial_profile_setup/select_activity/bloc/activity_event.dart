import 'package:equatable/equatable.dart';
import 'package:yopp/modules/_common/sports/sports.dart';

abstract class ActivityEvent extends Equatable {}

class GetSelectedSportsEvent extends ActivityEvent {
  final List<Sport> selectedSports;
  GetSelectedSportsEvent(this.selectedSports);
  @override
  List<Object> get props => [selectedSports];
}

class SportSelectionEvent extends ActivityEvent {
  final Sport sport;

  SportSelectionEvent(this.sport);
  @override
  List<Object> get props => [sport];
}
