import 'package:equatable/equatable.dart';

abstract class SportRequirement extends Equatable {}

class SkillRequirement extends SportRequirement {
  final SkillLevel skillLevel;
  SkillRequirement(this.skillLevel);

  @override
  List<Object> get props => [skillLevel];
}

class HeightRequirement extends SportRequirement {
  final double height;
  HeightRequirement(this.height);

  @override
  List<Object> get props => [height];
}

class DistanceRequirement extends SportRequirement {
  final double distance;
  DistanceRequirement(this.distance);

  @override
  List<Object> get props => [distance];
}

class PaceRequirement extends SportRequirement {
  final PaceLevel level;
  PaceRequirement(this.level);

  @override
  List<Object> get props => [level];
}

class HandiCapRequirement extends SportRequirement {
  final bool handicap;
  HandiCapRequirement(this.handicap);

  @override
  List<Object> get props => [handicap];
}

class BeltRequirement extends SportRequirement {
  final String belt;
  BeltRequirement(this.belt);

  @override
  List<Object> get props => [belt];
}

class WeightRequirement extends SportRequirement {
  final String weight;
  WeightRequirement(this.weight);

  @override
  List<Object> get props => [weight];
}

enum SportRequirements {
  skill_level,
  height,
  cyclingDistance,
  runningDistance,
  swimmingDistance,
  pace,
  handicap,
  belt,
  weight
}

enum SkillLevel {
  beginner,
  intermediate,
  expert,
  all,
}

extension skillName on SkillLevel {
  String get name {
    String name;
    switch (this) {
      case SkillLevel.beginner:
        name = "Beginner";
        break;
      case SkillLevel.intermediate:
        name = "Intermediate";
        break;
      case SkillLevel.expert:
        name = "Expert";
        break;
      case SkillLevel.all:
        name = "All Level";
        break;
    }

    return name;
  }
}

enum PaceLevel {
  slow,
  intermediate,
  fast,
  all,
}

extension paceName on PaceLevel {
  String get name {
    String name;
    switch (this) {
      case PaceLevel.slow:
        name = "Slow";
        break;
      case PaceLevel.intermediate:
        name = "Intermediate";
        break;
      case PaceLevel.fast:
        name = "Fast";
        break;

      case PaceLevel.all:
        name = "All";
        break;
    }
    return name;
  }
}

class Distance {
  final double min;
  final double max;
  double value;

  Distance({
    this.min = 0,
    this.max = 100,
    this.value = 0,
  });
}

class Weight {
  final double min;
  final double max;
  double value;
  Weight({
    this.min = 0,
    this.max = 200,
    this.value = 0,
  });
}

class Height {
  final double min;
  final double max;
  double value;
  Height({
    this.min = 0,
    this.max = 250,
    this.value = 0,
  });
}

class Age {
  final int min;
  final int max;
  int value;
  Age({
    this.min = 0,
    this.max = 100,
    this.value = 0,
  });
}
