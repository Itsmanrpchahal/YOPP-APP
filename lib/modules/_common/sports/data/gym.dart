import 'package:yopp/modules/_common/sports/sports.dart';

import '../sports_category.dart';

Sport createGym(int id) {
  var weightLifting =
      SportStyle(id: 0, name: "Weight lifting", requirements: []);

  return Sport(
      id: id,
      name: "Gym",
      styles: [weightLifting],
      requirements: [],
      imagePath: "assets/sports/gym.svg");
}
