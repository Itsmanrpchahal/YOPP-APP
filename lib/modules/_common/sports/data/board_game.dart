import 'package:yopp/modules/_common/sports/sports.dart';

import '../sports_category.dart';

Sport createBoardGame(int id) {
  final chess = SportStyle(id: 0, name: "Chess", requirements: []);
  final backgammon = SportStyle(id: 1, name: "Backgammon", requirements: []);
  final dart = SportStyle(id: 2, name: "Darts", requirements: []);
  final scrabble = SportStyle(id: 3, name: "Scrabble", requirements: []);
  final checkers = SportStyle(id: 4, name: "Checkers", requirements: []);

  return Sport(
      id: id,
      name: "Board Games",
      styles: [chess, backgammon, dart, scrabble, checkers],
      requirements: [],
      imagePath: "assets/sports/board_games.svg");
}
