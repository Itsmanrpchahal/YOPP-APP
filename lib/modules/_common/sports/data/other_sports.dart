import '../sports.dart';
import '../sports_category.dart';
import 'requirements/sports_requirements.dart';

Sport createOtherSports(int id) {
  final skate = SportStyle(
    id: 0,
    name: "Skateboarding",
    requirements: [],
  );
  final music = SportStyle(
    id: 1,
    name: "Music",
    requirements: [],
  );
  final climbing = SportStyle(
    id: 2,
    name: "Rock climbing",
    requirements: [SportRequirements.skill_level],
  );

  var sport = Sport(
      id: id,
      name: "Other",
      styles: [skate, music, climbing],
      requirements: [],
      imagePath: "assets/sports/other_sports.svg");

  return sport;
}
