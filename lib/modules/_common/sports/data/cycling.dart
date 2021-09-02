import '../sports.dart';
import '../sports_category.dart';
import 'requirements/sports_requirements.dart';

Sport createCycling(int id) {
  final road = SportStyle(id: 0, name: "Road", requirements: [
    SportRequirements.cyclingDistance,
    SportRequirements.pace
  ]);
  final track =
      SportStyle(id: 1, name: "Track", requirements: [SportRequirements.pace]);
  final mtb = SportStyle(id: 2, name: "MTB", requirements: [
    SportRequirements.cyclingDistance,
    SportRequirements.pace
  ]);
  final bmx = SportStyle(id: 3, name: "BMX", requirements: []);
  final recreational =
      SportStyle(id: 4, name: "Recreational", requirements: []);

  var running = Sport(
      id: id,
      name: "Cycling",
      styles: [road, track, mtb, bmx, recreational],
      requirements: [],
      imagePath: "assets/sports/cycling.svg");

  return running;
}

// Under Cycling, can we have the options for "Road", "Track", "MTB", "BMX", and "Recreational"
