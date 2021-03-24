import '../sports.dart';
import '../sports_category.dart';
import 'requirements/sports_requirements.dart';

Sport createMartialArts(int id) {
  var judo = SportStyle(id: 0, name: "Judo", requirements: [
    SportRequirements.weight,
    SportRequirements.belt,
  ]);

  var karate = SportStyle(id: 1, name: "Karate", requirements: [
    SportRequirements.weight,
    SportRequirements.belt,
  ]);

  var jujitsu = SportStyle(id: 2, name: "Jujitsu", requirements: [
    SportRequirements.weight,
    SportRequirements.belt,
  ]);

  var taeKwonDo = SportStyle(id: 3, name: "Tae kwon do", requirements: [
    SportRequirements.weight,
    SportRequirements.belt,
  ]);

  var kickBoxing = SportStyle(id: 4, name: "Kickboxing", requirements: [
    SportRequirements.weight,
  ]);

  var taiChi = SportStyle(id: 5, name: "Tai chi", requirements: [
    SportRequirements.skill_level,
  ]);

  var martialArts = Sport(
      id: id,
      name: "Martial Arts",
      styles: [
        judo,
        karate,
        jujitsu,
        taeKwonDo,
        kickBoxing,
        taiChi,
      ],
      requirements: [],
      imagePath: "assets/sports/martial_arts.svg");

  return martialArts;
}
