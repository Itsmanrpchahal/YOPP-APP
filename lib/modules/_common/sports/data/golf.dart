import '../sports.dart';
import 'requirements/sports_requirements.dart';

Sport createGolf(int id) {
  var running = Sport(
      id: id,
      name: "Golf",
      requirements: [SportRequirements.handicap],
      imagePath: "assets/sports/golf.svg");

  return running;
}
