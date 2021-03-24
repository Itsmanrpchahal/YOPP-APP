import '../sports.dart';
import '../sports_category.dart';
import 'requirements/sports_requirements.dart';

Sport createHorseRiding(int id) {
  final requirements = [SportRequirements.skill_level];
  var outrides =
      SportStyle(id: 0, name: "Outrides", requirements: requirements);
  var polo = SportStyle(id: 1, name: "Polo", requirements: requirements);
  var poloCross =
      SportStyle(id: 2, name: "Polo Cross", requirements: requirements);

  var riding = Sport(
      id: id,
      name: "Horse Riding",
      styles: [outrides, polo, poloCross],
      requirements: [],
      imagePath: "assets/sports/horse_riding.svg");

  return riding;
}
