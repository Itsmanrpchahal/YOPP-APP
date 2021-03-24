import '../sports.dart';
import '../sports_category.dart';
import 'requirements/sports_requirements.dart';

Sport createRacket(int id) {
  final requirements = [SportRequirements.skill_level];

  var tennis = SportStyle(id: 0, name: "Tennis", requirements: requirements);
  var squash = SportStyle(id: 1, name: "Squash", requirements: requirements);
  var badminton =
      SportStyle(id: 2, name: "Badminton", requirements: requirements);
  var tableTennis =
      SportStyle(id: 3, name: "Table Tennis", requirements: requirements);

  var racket = Sport(
      id: id,
      name: "Racket Sports",
      styles: [tennis, squash, badminton, tableTennis],
      requirements: [],
      imagePath: "assets/sports/racket_sports.svg");

  return racket;
}
