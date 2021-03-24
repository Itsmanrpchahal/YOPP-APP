import '../sports.dart';

Sport createDriving(int id) {
  var driving = Sport(
      id: id,
      name: "4WD",
      requirements: [],
      imagePath: "assets/sports/4wd.svg");
  return driving;
}
