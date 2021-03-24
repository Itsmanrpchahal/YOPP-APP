enum AppStaging { dev, live }

class UrlConstants {
  static const _appStage = AppStaging.live;

  static const _liveBaseUrl = "http://13.55.191.125:3000";
  static const _devBaseUrl = "http://65.1.81.225:3000";

  static String get baseUrl {
    if (_appStage == AppStaging.live) {
      return _liveBaseUrl;
    }
    return _devBaseUrl;
  }

  //Post
  static String get addUser => baseUrl + "/users";

  //Patch
  static String updateUser(String uid) {
    return baseUrl + "/users/" + uid;
  }

  static String get discoverUsers => baseUrl + "/users/discover";

  static String get swipeUser => baseUrl + "/users/swipe";

  static String get blockUser => baseUrl + "/users/block";

  static String get reportUser => baseUrl + "/reports";
}
