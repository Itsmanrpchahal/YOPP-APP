import 'package:yopp/modules/_common/sports/sports.dart';

import '../sports_category.dart';

Sport createCardGame(int id) {
  final cribbage = SportStyle(id: 0, name: "Cribbage", requirements: []);
  final bridge = SportStyle(id: 1, name: "Bridge", requirements: []);
  final rummy = SportStyle(id: 2, name: "Rummy", requirements: []);
  final speed = SportStyle(id: 3, name: "Speed", requirements: []);
  final piquet = SportStyle(id: 4, name: "Piquet", requirements: []);
  return Sport(
      id: id,
      name: "Card Games",
      styles: [cribbage, bridge, rummy, speed, piquet],
      requirements: [],
      imagePath: "assets/sports/card_games.svg");
}

//Under card games replace "Poker" with  "Cribbage". Can I also add "Speed" and "Piquet"
