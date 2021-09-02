import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yopp/modules/_common/sports/data/requirements/cycling_requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/running-requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/swimming_requirements.dart';
import 'package:yopp/modules/_common/sports/sports.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

UserSport userSportFromJson(String str) => UserSport.fromJson(json.decode(str));

String userSportToJson(UserSport data) => json.encode(data.toJson());

class UserSport {
  UserSport({
    @required this.name,
    @required this.sportId,
    this.categoryId,
    this.styleId,
    this.gender,
    this.handicap,
    this.skillLevel,
    this.heightRequired,
    this.pace,
    this.belt,
    this.weightRequired,
    this.distance,
    this.runningLevel,
    this.cyclingLevel,
    this.swimmingLevel,
  });

  final int sportId;
  final int categoryId;
  final int styleId;

  final String name;
  final Gender gender;
  final int handicap;
  final SkillLevel skillLevel;
  final bool heightRequired;
  final PaceLevel pace;
  final String belt;
  final bool weightRequired;
  final double distance;

  final RunningLevel runningLevel;
  final CyclingLevel cyclingLevel;
  final SwimmingLevel swimmingLevel;

  UserSport copyWith({
    String name,
    int sportId,
    int categoryId,
    int styleId,
    Gender gender,
    int handicap,
    SkillLevel skillLevel,
    bool heightRequired,
    PaceLevel pace,
    String belt,
    bool weightRequired,
    double distance,
    RunningLevel runningLevel,
    CyclingLevel cyclingLevel,
    SwimmingLevel swimmingLevel,
  }) {
    return UserSport(
        name: name ?? this.name,
        sportId: sportId ?? this.sportId,
        categoryId: categoryId ?? this.categoryId,
        styleId: styleId ?? this.styleId,
        gender: gender ?? this.gender,
        handicap: handicap ?? this.handicap,
        skillLevel: skillLevel ?? this.skillLevel,
        heightRequired: heightRequired ?? this.heightRequired,
        pace: pace ?? this.pace,
        belt: belt ?? this.belt,
        weightRequired: weightRequired ?? this.weightRequired,
        distance: distance ?? this.distance,
        runningLevel: runningLevel ?? this.runningLevel,
        cyclingLevel: cyclingLevel ?? this.cyclingLevel,
        swimmingLevel: swimmingLevel ?? this.swimmingLevel);
  }

  factory UserSport.fromJson(Map<String, dynamic> json) => UserSport(
        name: json["name"] == null ? null : json["name"],
        categoryId: json["categoryId"] == null ? null : json["categoryId"],
        styleId: json["styleId"] == null ? null : json["styleId"],
        sportId: json["sportId"] == null ? null : json["sportId"],
        gender: json["gender"] == null ? null : Gender.values[json["gender"]],
        handicap: json["handicap"] == null ? null : json["handicap"],
        skillLevel: json["skillLevel"] == null
            ? null
            : SkillLevel.values[json["skillLevel"]],
        heightRequired:
            json["heightRequired"] == null ? false : json["heightRequired"],
        pace: json["pace"] == null ? null : PaceLevel.values[json["pace"]],
        belt: json["belt"] == null ? null : json["belt"],
        weightRequired:
            json["weightRequired"] == null ? false : json["weightRequired"],
        runningLevel: json["runningLevel"] == null
            ? null
            : RunningLevel.values[json["runningLevel"]],
        cyclingLevel: json["cyclingLevel"] == null
            ? null
            : CyclingLevel.values[json["cyclingLevel"]],
        swimmingLevel: json["swimmingLevel"] == null
            ? null
            : SwimmingLevel.values[json["swimmingLevel"]],
      );

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();

    if (name != null) {
      json["name"] = name;
    }

    if (categoryId != null) {
      json["categoryId"] = categoryId;
    }

    if (styleId != null) {
      json["styleId"] = styleId;
    }

    if (sportId != null) {
      json["sportId"] = sportId;
    }

    if (gender != null) {
      json["gender"] = gender.index;
    }

    if (handicap != null) {
      json["handicap"] = handicap;
    }

    if (skillLevel != null) {
      json["skillLevel"] = skillLevel.index;
    }

    if (heightRequired != null) {
      json["heightRequired"] = heightRequired;
    }

    if (pace != null) {
      json["pace"] = pace.index;
    }

    if (belt != null) {
      json["belt"] = belt;
    }

    if (weightRequired != null) {
      json["weightRequired"] = weightRequired;
    }

    if (runningLevel != null) {
      json["runningLevel"] = runningLevel.index;
    }

    if (cyclingLevel != null) {
      json["cyclingLevel"] = cyclingLevel.index;
    }

    if (swimmingLevel != null) {
      json["swimmingLevel"] = swimmingLevel.index;
    }

    return json;
  }

  List<SportRequirements> getRequirements() {
    List<SportRequirements> requirements = [];
    if (sportId != null) {
      final allSports = getAllSports();

      final selectedSport =
          allSports.firstWhere((element) => element.id == sportId);

      if (categoryId != null) {
        final sportSubCategory = selectedSport.subCategory
            .firstWhere((element) => element.id == categoryId);
        if (styleId != null) {
          final sportStyle = sportSubCategory.styles
              .firstWhere((element) => element.id == styleId);
          requirements = sportStyle.requirements;
        }
      } else if (styleId != null) {
        final sportStyle =
            selectedSport.styles.firstWhere((element) => element.id == styleId);
        requirements = sportStyle.requirements;
      } else {
        requirements = selectedSport.requirements;
      }
    }

    return requirements;
  }

  String getImagepath() {
    String imagepath = "";
    if (sportId != null) {
      final allSports = getAllSports();

      final selectedSport =
          allSports.firstWhere((element) => element.id == sportId);
      imagepath = selectedSport.imagePath;
    }
    return imagepath;
  }
}
