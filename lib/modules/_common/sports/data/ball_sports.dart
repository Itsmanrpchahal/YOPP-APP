import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';

import '../sports.dart';
import '../sports_category.dart';

Sport createBallSports(int id) {
  final skillLevel = [SportRequirements.skill_level];
  // final basketball =
  //     SportStyle(id: 0, name: "Basketball", requirements: skillLevel);
  // final scoccer = SportStyle(id: 1, name: "Soccer", requirements: skillLevel);

  // final bowels = SportStyle(id: 2, name: "Bowels", requirements: skillLevel);
  // final baseball =
  //     SportStyle(id: 3, name: "Baseball", requirements: skillLevel);
  // final softball =
  //     SportStyle(id: 4, name: "Softball", requirements: skillLevel);

  // final afl = SportStyle(id: 5, name: "AFL", requirements: skillLevel);

  // final rugby = SportStyle(id: 6, name: "Rugby", requirements: skillLevel);

  // final league = SportStyle(id: 7, name: "League", requirements: skillLevel);

  final basketball =
      SportStyle(id: 0, name: "Basketball", requirements: skillLevel);
  final hockey = SportStyle(id: 1, name: "Hockey", requirements: skillLevel);
  final netball = SportStyle(id: 2, name: "Netball", requirements: skillLevel);

  final scoccer = SportStyle(id: 3, name: "Soccer", requirements: skillLevel);

  return Sport(
      id: id,
      name: "Ball Sports",
      styles: [
        basketball,
        hockey,
        netball,
        scoccer,
      ],
      requirements: skillLevel,
      imagePath: "assets/sports/ball_sports.svg");
}
