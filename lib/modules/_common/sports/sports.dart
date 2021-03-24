import 'package:flutter/material.dart';
import 'package:yopp/modules/_common/sports/data/board_game.dart';
import 'package:yopp/modules/_common/sports/data/card_game.dart';
import 'package:yopp/modules/_common/sports/data/cycling.dart';
import 'package:yopp/modules/_common/sports/data/driving.dart';
import 'package:yopp/modules/_common/sports/data/golf.dart';
import 'package:yopp/modules/_common/sports/data/gym.dart';
import 'package:yopp/modules/_common/sports/data/hiking.dart';
import 'package:yopp/modules/_common/sports/data/horse_riding.dart';
import 'package:yopp/modules/_common/sports/data/other_sports.dart';
import 'package:yopp/modules/_common/sports/data/snow_sport.dart';
import 'package:yopp/modules/_common/sports/data/water_sport.dart';

import 'package:yopp/modules/_common/sports/sports_category.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';

import 'data/ball_sports.dart';
import 'data/dancing.dart';
import 'data/martial_arts.dart';
import 'data/racket.dart';
import 'data/running.dart';

class Sport {
  final int id;
  final String name;
  final String imagePath;
  bool isSelected = false;
  List<SportsSubCategory> subCategory = [];
  List<SportStyle> styles = [];
  List<SportRequirements> requirements = [];
  Sport({
    @required this.id,
    @required this.name,
    @required this.imagePath,
    this.styles = const [],
    this.subCategory = const [],
    @required this.requirements,
  });
}

List<Sport> getAllSports() {
  List<Sport> allSports = [];
  final dancing = createDancing(0);
  final racket = createRacket(1);
  final running = createRunning(2);
  final horse = createHorseRiding(3);
  final golf = createGolf(4);
  final martialArts = createMartialArts(5);
  final boardGames = createBoardGame(6);
  final cardGames = createCardGame(7);
  final hiking = createHiking(8);
  final cyling = createCycling(9);
  final waterSport = createWaterSport(10);
  final driving = createDriving(11);
  final gym = createGym(12);
  final snowGames = createSnowSports(13);
  final ballSports = createBallSports(14);
  final otherSports = createOtherSports(15);

  allSports.add(dancing);
  allSports.add(racket);
  allSports.add(running);
  allSports.add(horse);
  allSports.add(golf);
  allSports.add(martialArts);
  allSports.add(boardGames);
  allSports.add(cardGames);
  allSports.add(hiking);
  allSports.add(cyling);
  allSports.add(waterSport);
  allSports.add(driving);
  allSports.add(gym);
  allSports.add(snowGames);
  allSports.add(ballSports);
  allSports.add(otherSports);

  allSports.sort((a, b) => a.name.compareTo(b.name));

  return allSports;
}
