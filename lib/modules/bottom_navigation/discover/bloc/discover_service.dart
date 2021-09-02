import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:yopp/helper/url_constants.dart';
import 'package:http/http.dart' as http;
import 'package:yopp/modules/bottom_navigation/discover/bloc/discover_event.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

import 'discovered_user.dart';

abstract class DiscoverService {
  Future<DiscoveredApiResponse> loadMatchedUsers({
    @required int skip,
    @required int limit,
    @required String id,
    @required double maxDistance,
    @required SearchBy searchBy,
    @required bool showOnlineOnly,
    @required Interest selectedInterest,
    @required double lat,
    @required double lng,
  });
}

class ApiDiscoverService extends DiscoverService {
  @override
  Future<DiscoveredApiResponse> loadMatchedUsers({
    @required int skip,
    @required int limit,
    @required String id,
    @required double maxDistance,
    @required SearchBy searchBy,
    @required bool showOnlineOnly,
    @required Interest selectedInterest,
    @required double lat,
    @required double lng,
  }) async {
    try {
      var url = UrlConstants.discoverUsers;

      Map data = {
        "limit": limit,
        "skip": skip,
        "lat": lat,
        "lng": lng,
        "maxDistance": maxDistance,
        "id": id,
        "interest": selectedInterest.interest.id,
      };

      if (selectedInterest.category != null) {
        data["category"] = selectedInterest.category.id;
        print(selectedInterest.category.name);
      }

      if (selectedInterest.subCategory != null) {
        data["subCategory"] = selectedInterest.subCategory.id;
      }

      switch (searchBy) {
        case SearchBy.interest:
          data["searchBy"] = "interest";
          data["searchByID"] = selectedInterest.interest.id;
          break;
        case SearchBy.category:
          data["searchBy"] = "category";
          data["searchByID"] = selectedInterest.category.id;
          break;
        case SearchBy.subCategory:
          data["searchBy"] = "subCategory";
          data["searchByID"] = selectedInterest.subCategory.id;
          break;
      }

      if (showOnlineOnly == true) {
        data["online"] = "true";
      }

      Gender gender = selectedInterest.gender;
      switch (gender) {
        case Gender.male:
          data["gender"] = [Gender.male.name];
          break;
        case Gender.female:
          data["gender"] = [Gender.female.name];
          break;
        default:
          data["gender"] = [Gender.male.name, Gender.female.name];
          break;
      }

      String body = json.encode(data);

      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);

      if (response.statusCode == 201) {
        final data = DiscoveredApiResponse.fromJson(response.body);

        return data;
      } else {
        print(body);
        print(response.body);
        throw Exception('Failed to get users.');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      print("error: " + error.toString());
      FirebaseCrashlytics.instance.log("Discover");
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }
}
