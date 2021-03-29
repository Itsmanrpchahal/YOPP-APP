import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/_common/sports/sports.dart';

import '../sports_category.dart';

Sport createHiking(int id) {
  var day = SportStyle(
      id: 0, name: "Day Hikes", requirements: [SportRequirements.skill_level]);
  var overNight = SportStyle(
      id: 1,
      name: "Overnighters",
      requirements: [SportRequirements.skill_level]);
  var oreint = SportStyle(
      id: 2,
      name: "Orienteering",
      requirements: [SportRequirements.skill_level]);
  var walk = SportStyle(
      id: 3, name: "Walking", requirements: [SportRequirements.skill_level]);
  var pack = SportStyle(id: 4, name: "Recreational", requirements: []);

  return Sport(
      id: id,
      name: "Hiking",
      styles: [
        day,
        overNight,
        oreint,
        walk,
        pack,
      ],
      requirements: [],
      imagePath: "assets/sports/hiking.svg");
}
