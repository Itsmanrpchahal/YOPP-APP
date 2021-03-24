enum Gender { male, female, any }

extension genderName on Gender {
  String get name {
    String name;
    switch (this) {
      case Gender.male:
        name = "male";
        break;
      case Gender.female:
        name = "female";
        break;
      case Gender.any:
        name = "any";
        break;
    }
    return name;
  }
}
