import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';

abstract class SportCategory {
  int id;
  String name;
}

class SportsSubCategory extends SportCategory {
  final int id;
  final String name;
  List<SportStyle> styles = [];
  SportsSubCategory({
    this.id,
    this.name,
    this.styles,
  });
}

class SportStyle extends SportCategory {
  final int id;
  final String name;
  var isSelected = false;
  List<SportRequirements> requirements = [];
  SportStyle({this.id, this.name, this.requirements});
}
