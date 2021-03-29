import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:yopp/helper/url_constants.dart';
import 'package:http/http.dart' as http;

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

import 'discovered_user.dart';

abstract class DiscoverService {
  Future<DiscoveredData> getSimilarUsers({
    @required UserProfile userProfile,
    @required double maxDistance,
    @required RangeValues ageRange,
  });

  Future<bool> likeUser({
    @required String uid,
    @required DiscoveredUser discoveredUser,
  });
  Future<void> dislikeUser({
    @required String uid,
    @required DiscoveredUser discoveredUser,
  });
}

class ApiDiscoverService extends DiscoverService {
  @override
  Future<void> dislikeUser({
    @required String uid,
    @required DiscoveredUser discoveredUser,
  }) async {
    var url = UrlConstants.swipeUser;

    Map data = {
      "uid": uid,
      "sport": discoveredUser.selectedSport,
      "swipedTo": discoveredUser.id,
      "like": false
    };

    String body = json.encode(data);
    print("dislike user:" + body);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 201) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } else {
      throw Exception('Failed to swipe user.');
    }
  }

  @override
  Future<bool> likeUser({String uid, DiscoveredUser discoveredUser}) async {
    var url = UrlConstants.swipeUser;

    Map data = {
      "uid": uid,
      "sport": discoveredUser.selectedSport,
      "swipedTo": discoveredUser.id,
      "like": "true"
    };

    String body = json.encode(data);
    print("like user:" + body);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 201) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      final bool result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception('Failed to swipe user.');
    }
  }

  @override
  Future<DiscoveredData> getSimilarUsers({
    UserProfile userProfile,
    double maxDistance,
    RangeValues ageRange,
  }) async {
    var url = UrlConstants.discoverUsers;

    Map data = {
      "limit": 20,
      "fromAge": ageRange.start,
      "ToAge": ageRange.end,
      "lat": userProfile.address.coordinates.latitude,
      "lng": userProfile.address.coordinates.longitude,
      "maxDistance": maxDistance * 1000,
      "uid": userProfile.uid,
      "sport": userProfile.selectedSport.name
    };

    Gender gender = userProfile.selectedSport.gender;
    if (gender == Gender.male) {
      data["gender"] = [Gender.male.name];
    } else if (gender == Gender.female) {
      data["gender"] = [Gender.female.name];
    } else {
      data["gender"] = [Gender.male.name, Gender.female.name];
    }

    String body = json.encode(data);

    print("discover user:" + body);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 201) {
      print("Success");
      print('Response body: ${response.body}');
      print('Response status: ${response.statusCode}');

      final data = DiscoveredData.fromJson(response.body);
      return data;
    } else {
      throw Exception('Failed to get users.');
    }
  }
}
