import '../sports.dart';
import '../sports_category.dart';
import 'requirements/sports_requirements.dart';

Sport createWaterSport(int id) {
  var scuba = SportStyle(
      id: 0,
      name: "Scuba Diving",
      requirements: [SportRequirements.skill_level]);
  var kayaking = SportStyle(
      id: 1,
      name: "Kayaking, Sculling, Rowing",
      requirements: [SportRequirements.skill_level]);
  var swimming = SportStyle(
      id: 2,
      name: "Swimming",
      requirements: [SportRequirements.swimmingDistance]);
  var surfing = SportStyle(
      id: 3, name: "Surfing", requirements: [SportRequirements.skill_level]);
  var sailing = SportStyle(
      id: 4, name: "Sailing", requirements: [SportRequirements.skill_level]);
  var kite = SportStyle(
      id: 5,
      name: "Kite Surfing",
      requirements: [SportRequirements.skill_level]);

  var racket = Sport(
      id: id,
      name: "Water Sports",
      styles: [
        scuba,
        kayaking,
        swimming,
        surfing,
        sailing,
        kite,
      ],
      requirements: [],
      imagePath: "assets/sports/water_sports.svg");

  return racket;
}
