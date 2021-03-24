import 'package:flutter/material.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

// distance
// pace
// Handicap
// belt
// Weight
enum PreferenceStatus { none, loading, loaded, updating, updated, failure }

class PreferenceState {
  final String serviceMessage;
  final PreferenceStatus serviceStatus;

  final RangeValues ageRange;
  final RangeValues heightRange;
  final double locationRange;
  final Gender gender;
  final SkillLevel skillLevel;
  final UserProfile userProfile;

  PreferenceState({
    @required this.serviceMessage,
    @required this.serviceStatus,
    @required this.ageRange,
    @required this.heightRange,
    @required this.locationRange,
    @required this.gender,
    @required this.skillLevel,
    @required this.userProfile,
  });

  PreferenceState copyWith({
    String serviceMessage,
    PreferenceStatus serviceStatus,
    RangeValues ageRange,
    RangeValues heightRange,
    double distance,
    Gender gender,
    SkillLevel skillLevel,
    UserProfile userProfile,
  }) {
    return PreferenceState(
      serviceMessage: serviceMessage ?? this.serviceMessage,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      ageRange: ageRange ?? this.ageRange,
      heightRange: heightRange ?? this.heightRange,
      locationRange: distance ?? this.locationRange,
      gender: gender ?? this.gender,
      skillLevel: skillLevel ?? this.skillLevel,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}
