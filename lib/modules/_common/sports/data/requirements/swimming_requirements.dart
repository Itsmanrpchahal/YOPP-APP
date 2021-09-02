enum SwimmingLevel { level0, level1, level2, level3, level4 }

extension distanceName on SwimmingLevel {
  String get name {
    String value;
    switch (this) {
      case SwimmingLevel.level0:
        value = "0-0.5 km";
        break;
      case SwimmingLevel.level1:
        value = "0.5-1 km";
        break;
      case SwimmingLevel.level2:
        value = "1-2 km";
        break;
      case SwimmingLevel.level3:
        value = "2-3 km";
        break;
      case SwimmingLevel.level4:
        value = "3+ km";
        break;
    }
    return value;
  }
}
