import '../sports.dart';
import '../sports_category.dart';
import 'requirements/sports_requirements.dart';

Sport createRunning(int id) {
  final running = SportStyle(
    id: 0,
    name: "Running",
    requirements: [SportRequirements.runningDistance, SportRequirements.pace],
  );
  final trailCross = SportStyle(
    id: 1,
    name: 'Trail-Cross Country',
    requirements: [SportRequirements.runningDistance, SportRequirements.pace],
  );
  final track = SportStyle(
    id: 2,
    name: "Track",
    requirements: [SportRequirements.pace],
  );

  var sport = Sport(
      id: id,
      name: "Running",
      styles: [running, trailCross, track],
      requirements: [],
      imagePath: "assets/sports/running.svg");

  return sport;
}
