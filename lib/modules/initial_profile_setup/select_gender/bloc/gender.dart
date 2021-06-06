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

Gender parseGenderFromString(String value) {
  if (value.toLowerCase() == Gender.male.name.toLowerCase()) {
    return Gender.male;
  } else if (value.toLowerCase() == Gender.female.name.toLowerCase()) {
    return Gender.female;
  } else if (value.toLowerCase() == Gender.any.name.toLowerCase()) {
    return Gender.any;
  }
  return Gender.any;
}
