class AppConstant {
  static const Duration NETWORK_TIMEOUT_SECONDS = Duration(seconds: 10);
  static const helpEmail = "complaints@yopp.com.au";
}

class DefaultText {
  static const ABOUT_USER =
      "Write a little about yourself and your passions. What are you looking for in a practise partner?";
}

class PreferenceConstants {
  // In years
  static const double minAgeValue = 13;
  static const double underAgeValue = 18;
  static const double maxAgeValue = 100;

  static const double defaultStartAgeValue = 18;
  static const double defaultEndAgeValue = 100;

  // In cm
  static const double minHeightValue = 0;
  static const double maxHeightValue = 250;
  static const double defaultHeightValue = 150;

  static const double defaultStartHeightValue = 0;
  static const double defaultEndHeightValue = 250;

  // In KM
  static const double minLocationRange = 10;
  static const double maxLocationRange = 200;
  static const double defaultLocationRangeValue = 100;

  // In KM
  static const double minDistance = 0;
  static const double maxDistance = 100;
  static const double defaultDistance = 0;

  // In Kg
  static const double minWeight = 0;
  static const double maxWeight = 200;
  static const double defaultWeight = 50;

  static const int defaultHandicapLevel = 0;
}
