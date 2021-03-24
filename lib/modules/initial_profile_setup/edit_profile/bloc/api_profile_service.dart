import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:yopp/helper/url_constants.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

import 'package:http/http.dart' as http;

import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

class ApiProfileService {
  Future<void> updateProfile(UserProfile profile) async {
    print("update api profile");
    var url = UrlConstants.updateUser(profile.uid);
    var body = Map<String, dynamic>();

    if (profile.email != null) {
      body["email"] = profile.email;
    }

    if (profile.phone != null) {
      body['phone'] = profile.phone;
    }

    if (profile.countryCode != null) {
      body['countryCode'] = profile.countryCode;
    }

    if (profile.avatar != null) {
      body["avatar"] = profile.avatar;
    }
    if (profile.name != null) {
      body["name"] = profile.name;
    }
    if (profile.age != null) {
      body["dob"] = DateTime.now().year - profile.age;
    }

    if (profile.dob != null) {
      body["dob"] = profile.dob;
    }
    if (profile.about != null) {
      body["about"] = profile.about;
    }

    if (profile.height != null) {
      body["height"] = profile.height;
    }
    if (profile.weight != null) {
      body["weight"] = profile.weight;
    }
    if (profile.gender != null) {
      body["gender"] = profile.gender.name;
    }

    if (profile.address != null) {
      body["location"] = {
        "type": "Point",
        "coordinates": [
          profile.address.coordinates.longitude,
          profile.address.coordinates.latitude
        ],
      };
      // body["address"] = profile.address.toMap();
    }

    if (profile.selectedSport != null) {
      body["selectedSport"] = profile.selectedSport.name;
    }

    if (profile.searchBy != null) {
      body["searchBy"] = profile.searchBy;
    }

    if (profile.status != null) {
      body["status"] = profile.status.description;
    }

    var response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to upated user.');
    }
  }

  Future<String> addUserProfile(UserProfile profile) async {
    var url = UrlConstants.addUser;
    var response = await http.post(url, body: {
      'uid': profile.uid,
      'name': profile.name,
      'phone': profile.phone,
      'status': profile.status.description,
      'countryCode': profile.countryCode,
      'email': profile.email
    });

    if (response.statusCode == 201) {
      return jsonDecode(response.body)["id"];
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<void> blockUser({@required String uid, @required String id}) async {
    var url = UrlConstants.blockUser;
    var response = await http.post(url, body: {
      'uid': uid,
      'user_id': id,
    });

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to block user.');
    }
  }
}
