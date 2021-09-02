enum DeleteOptionEnum {
  needBreak,
  dontLike,
  startOver,
  somethingBroken,
  somethingElse,
}

extension ListTile on DeleteOptionEnum {
  String get name {
    var _name = "";
    switch (this) {
      case DeleteOptionEnum.needBreak:
        _name = "I NEED A BREAK FROM YOPP";
        break;
      case DeleteOptionEnum.dontLike:
        _name = "I DON'T LIKE YOPP";
        break;
      case DeleteOptionEnum.startOver:
        _name = "I WANT TO START OVER";
        break;
      case DeleteOptionEnum.somethingBroken:
        _name = "SOMETHING'S BROKEN";
        break;
      case DeleteOptionEnum.somethingElse:
        _name = "SOMETHING ELSE?";
        break;
    }
    return _name;
  }
}
