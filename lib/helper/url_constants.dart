enum AppStaging { dev, live }

class UrlConstants {
  static const _appStage = AppStaging.live;

  static const _liveBaseUrl = "http://13.55.191.125:3000";
  static const _devBaseUrl = "http://65.1.151.66:3000";

  static String get baseUrl {
    if (_appStage == AppStaging.live) {
      return _liveBaseUrl;
    }
    return _devBaseUrl;
  }

  static String get postUser => baseUrl + "/users";
  static String user(String uid) {
    return baseUrl + "/users/" + uid;
  }

  static String get postInterest => baseUrl + "/users/interest";
  static String deleteInterest(String interestId) {
    return baseUrl + "/users/interest/" + interestId;
  }

  static String patchInterest(String interestId) {
    return baseUrl + "/users/interest/" + interestId;
  }

  static String get discoverUsers => baseUrl + "/users/discover/v2";

  static String get connections => baseUrl + "/users/connection";
  static String get loadconnections => baseUrl + "/users/connection/get";

  static String get swipeUser => baseUrl + "/users/swipe";

  static String get blockUser => baseUrl + "/users/block";
  static String get unblockUser => baseUrl + "/users/block";

  static String get blockedUserList => baseUrl + "/users/block/get";

  static String get reportUser => baseUrl + "/reports";

  static String get interestOptions => baseUrl + "/interests";

  static String interestImageUrl(String imageName) {
    final url = baseUrl + "/images/uploads/interests/" + imageName;

    return url;
  }

  static String categoryImageUrl(String imageName) {
    return baseUrl + "/images/uploads/categories/" + imageName;
  }

  static String discoverCategoryImageUrl(String imageName) {
    return baseUrl + "/images/uploads/discovery_categories/" + imageName;
  }

  static String subcategoryImageUrl(String imageName) {
    return baseUrl + "/images/uploads/sub_categories/" + imageName;
  }
}
