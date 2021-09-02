import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/_common/sports/data/requirements/cycling_requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/running-requirements.dart';

import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

abstract class InterestDialogEvent extends Equatable {}

class LoadInterestDialogEvent extends InterestDialogEvent {
  final List<InterestOption> interestOptions;
  final Interest selectedInterest;
  final bool refineFilter;

  LoadInterestDialogEvent({
    @required this.interestOptions,
    @required this.selectedInterest,
    this.refineFilter = false,
  });

  @override
  List<Object> get props => [selectedInterest, interestOptions, refineFilter];
}

class InterestOptionSelectedEvent extends InterestDialogEvent {
  final InterestOption selectedInterestOption;
  final int height;
  InterestOptionSelectedEvent(this.selectedInterestOption,
      {@required this.height});

  @override
  List<Object> get props => [selectedInterestOption];
}

class CategoryOptionSelectedEvent extends InterestDialogEvent {
  final CategoryOption selectedCategoryOption;
  CategoryOptionSelectedEvent(this.selectedCategoryOption);

  @override
  List<Object> get props => [selectedCategoryOption];
}

class SubCategoryOptionSelectedEvent extends InterestDialogEvent {
  final SubCategoryOption selectedSubCategoryOption;
  SubCategoryOptionSelectedEvent(this.selectedSubCategoryOption);

  @override
  List<Object> get props => [selectedSubCategoryOption];
}

class SkillSelectedEvent extends InterestDialogEvent {
  final SkillLevel skill;
  SkillSelectedEvent(this.skill);

  @override
  List<Object> get props => [skill];
}

class PaceSelectedEvent extends InterestDialogEvent {
  final PaceLevel paceLevel;
  PaceSelectedEvent(this.paceLevel);

  @override
  List<Object> get props => [paceLevel];
}

class CylclingLevelSelectedEvent extends InterestDialogEvent {
  final CyclingLevel level;
  CylclingLevelSelectedEvent(this.level);

  @override
  List<Object> get props => [level];
}

class RunningLevelSelectedEvent extends InterestDialogEvent {
  final RunningLevel level;
  RunningLevelSelectedEvent(this.level);

  @override
  List<Object> get props => [level];
}

class GenderSelectedEvent extends InterestDialogEvent {
  final Gender gender;
  GenderSelectedEvent(this.gender);

  @override
  List<Object> get props => [gender];
}

class OnBackEvent extends InterestDialogEvent {
  @override
  List<Object> get props => [];
}
