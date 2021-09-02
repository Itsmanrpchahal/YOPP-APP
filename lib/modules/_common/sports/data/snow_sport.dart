import '../sports.dart';
import '../sports_category.dart';
import 'requirements/sports_requirements.dart';

Sport createSnowSports(int id) {
  final skillLevel = [SportRequirements.skill_level];

  var skiing = SportStyle(id: 0, name: "Skiing", requirements: skillLevel);
  var boarding =
      SportStyle(id: 1, name: "Snow Boarding", requirements: skillLevel);
  var cross =
      SportStyle(id: 2, name: "Cross Country Skiing", requirements: skillLevel);
  var skating =
      SportStyle(id: 3, name: "Ice Skating", requirements: skillLevel);
  var hockey = SportStyle(
    id: 4,
    name: "Ice Hockey",
    requirements: skillLevel,
  );
  var fishing = SportStyle(id: 5, name: "Ice Fishing", requirements: []);

  var shoeing =
      SportStyle(id: 6, name: "Snow Shoeing", requirements: skillLevel);

  var mobile = SportStyle(id: 7, name: "Snowmobile", requirements: skillLevel);

  var biking = SportStyle(id: 8, name: "Snow Biking", requirements: skillLevel);

  var sport = Sport(
      id: id,
      name: "Snow Sports",
      styles: [
        skiing,
        boarding,
        cross,
        skating,
        hockey,
        fishing,
        shoeing,
        mobile,
        biking,
      ],
      requirements: [],
      imagePath: "assets/sports/snow_sports.svg");

  return sport;
}
