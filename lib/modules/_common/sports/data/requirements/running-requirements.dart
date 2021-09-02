enum RunningLevel { level0, level1, level2, level3, level4 }

extension runningName on RunningLevel {
  String get name {
    String value;
    switch (this) {
      case RunningLevel.level0:
        value = "0-10 km";
        break;
      case RunningLevel.level1:
        value = "10-20 km";
        break;
      case RunningLevel.level2:
        value = "20-30 km";
        break;
      case RunningLevel.level3:
        value = "30-40 km";
        break;
      case RunningLevel.level4:
        value = "40+ km";
        break;
    }
    return value;
  }
}
