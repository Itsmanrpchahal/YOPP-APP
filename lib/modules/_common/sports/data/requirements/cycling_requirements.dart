enum CyclingLevel {
  level0,
  level1,
  level2,
  level3,
}

extension runningName on CyclingLevel {
  String get name {
    String value;
    switch (this) {
      case CyclingLevel.level0:
        value = "0-20 km";
        break;
      case CyclingLevel.level1:
        value = "20-40 km";
        break;
      case CyclingLevel.level2:
        value = "40-60 km";
        break;
      case CyclingLevel.level3:
        value = "60+ km";
        break;
    }
    return value;
  }
}
