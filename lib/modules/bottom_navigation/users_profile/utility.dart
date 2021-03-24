import 'package:flutter/foundation.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';

String getUserSkillLevel({
  @required UserProfile profile,
  @required UserSport selectedSport,
}) {
  var sport = selectedSport;

  String skill = "";

  if (sport?.heightRequired == true) {
    skill = "Height - ${profile?.height?.toInt() ?? ""} cm";
  }

  if (sport?.weightRequired == true) {
    skill = "Weight - ${profile?.weight?.toInt() ?? ""} kg";
  }

  if (sport?.belt != null) {
    skill = "Belt - ${sport.belt}";
  }

  if (sport?.handicap != null) {
    skill = "Handicap - ${sport.handicap}";
  }

  if (sport?.skillLevel != null) {
    skill = "Skill Level - ${sport.skillLevel.name}";
  }

  return skill;
}
