import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/model.dart';

import 'package:yopp/helper/url_constants.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/bottom_navigation/block_user/bloc/blocked_users.dart';
import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

import 'package:http/http.dart' as http;

import 'profile_service.dart';

class APIProfileService extends ProfileService {
  @override
  Future<void> deleteProfile(String userId) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      await updateProfile(UserProfile(
        uid: userId,
        online: false,
        name: "Yopp User",
        email: "",
        avatar: "",
        countryCode: "",
        phone: "",
        about: "",
        age: 0,
        status: UserStatus.deleted,
      ));
    } on FirebaseException catch (e, stack) {
      FirebaseCrashlytics.instance.log("deleteProfile");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e, stack: stack));

      throw Exception(e.message);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("deleteProfile");

      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  @override
  Future<UserProfile> addUserProfile(UserProfile profile) async {
    try {
      var url = UrlConstants.postUser;
      final body = {
        'uid': profile.uid,
        'name': profile.name,
        'phone': profile.phone,
        'status': profile.status.description,
        'countryCode': profile.countryCode,
        'email': profile.email
      };
      var response = await http.post(Uri.parse(url), body: body);
      print(response.request.toString());
      print(body.toString());

      if (response.statusCode == 201) {
        return UserProfile.fromJson(jsonDecode(response.body));
      } else {
        FirebaseCrashlytics.instance.log(response.body);
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: "addUserProfile"));
        throw Exception('Failed to create user.');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      print(" addUserProfile error: " + error.toString());
      FirebaseCrashlytics.instance.log("addUserProfile");

      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  @override
  Future<void> saveGender(Gender gender) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      var update =
          UserProfile(uid: userId, gender: gender, status: UserStatus.active);
      await updateProfile(update);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("saveGender");
      FirebaseCrashlytics.instance.log(gender?.name ?? "NA");
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  @override
  Future<void> saveDOB(DateTime birthDate) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      var update =
          UserProfile(uid: userId, dob: birthDate.year, birthDate: birthDate);
      await updateProfile(update);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("saveDOB");
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  Future<UserProfile> updateProfile(UserProfile profile) async {
    print("update api profile");
    final uid = profile?.uid ?? FirebaseAuth.instance.currentUser.uid;
    var url = UrlConstants.user(uid);
    print(profile.toJson());

    try {
      var response = await http.patch(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(profile.toJson()));

      if (response.statusCode == 200) {
        return UserProfile.fromJson(jsonDecode(response.body));
      } else {
        print(response.body);
        FirebaseCrashlytics.instance.log("update profile");
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.log(response.body);
        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: Exception("update profile")));

        throw Exception('Failed to update user.');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      print("error: " + error.toString());
      FirebaseCrashlytics.instance.log("update profile");

      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));
      throw error;
    }
  }

  @override
  Future<UserProfile> loadProfile(String userId) async {
    final uid = userId ?? FirebaseAuth.instance.currentUser.uid;
    var url = UrlConstants.user(uid);

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(jsonDecode(response.body));
      } else {
        print(response.body);
        FirebaseCrashlytics.instance.log("load profile");
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.log(response.body);
        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: Exception("load profile")));
        throw Exception(
            jsonDecode(response.body)['message'] + '.\nFailed to load user.');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("load profile");

      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  @override
  Future<String> uploadProfilePhoto(File file) async {
    try {
      final userId = FirebaseAuth.instance.currentUser.uid;
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("yopp")
          .child(userId)
          .child('/profile.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e, stack) {
      FirebaseCrashlytics.instance.log("uploadProfilePhoto");
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: e, stack: stack));

      throw Exception(e.message);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("uploadProfilePhoto");

      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  @override
  Future<UserProfile> saveAddress(Address address) async {
    final userId = FirebaseAuth.instance.currentUser.uid;
    try {
      final data =
          await updateProfile(UserProfile(uid: userId, address: address));
      return data;
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("saveAddress");

      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  @override
  Future<UserProfile> setInterestPreference({
    @required String uid,
    @required Interest interest,
  }) async {
    try {
      final profileToUpdate = UserProfile(
        uid: uid,
        selectedInterest: interest,
      );
      final user = await updateProfile(profileToUpdate);
      return user;
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("setSelectedSport");

      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  @override
  Future<UserProfile> removeInterest({
    @required String interestId,
    @required String uid,
  }) async {
    try {
      final url = Uri.parse(UrlConstants.deleteInterest(interestId));
      final request = http.Request("DELETE", url);
      request.headers.addAll(<String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8'
      });
      request.body = jsonEncode({"uid": uid});
      final response = await request.send();

      if (response.statusCode == 200) {
        print("removeInterest  success");
        final body = await response.stream.bytesToString();
        print(body);
        return UserProfile.fromJson(jsonDecode(body));
      } else {
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.log(response.toString());

        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: response.statusCode.toString()));

        throw Exception('Failed to Delete Sport.');
      }
    } catch (error, stack) {
      print("error: " + error.toString());
      FirebaseCrashlytics.instance.log("removeInterest");
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));
      throw error;
    }
  }

  @override
  Future<UserProfile> updateUserInterest({
    @required String uid,
    @required Interest interest,
    bool isSelected,
  }) async {
    try {
      print("updateUserInterest");
      var url = UrlConstants.patchInterest(interest.id);

      var body = interest.toJson();
      body['uid'] = uid;
      body['isSelected'] = isSelected ? "true" : "false";

      print(jsonEncode(body));

      var response = await http.patch(Uri.parse(url), body: body);
      print("url: " + url);
      print("body:" + body.toString());

      if (response.statusCode == 200) {
        print("response: " + response.body);
        print(jsonDecode(response.body));
        return UserProfile.fromJson(jsonDecode(response.body));
      } else {
        print("error:" + response.statusCode.toString());

        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.log(response.body);

        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: response.statusCode.toString()));

        throw Exception(jsonDecode(response.body)['message'] +
            '.\nFailed to update interest..');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("updateUserInterest");

      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  @override
  Future<UserProfile> addNewInterest({
    @required String uid,
    @required Interest interest,
  }) async {
    try {
      var url = UrlConstants.postInterest;
      print("addNewInterest");
      var body = interest.toJson();
      body['uid'] = uid;
      print(jsonEncode(body));

      var response = await http.post(Uri.parse(url), body: body);

      if (response.statusCode == 201) {
        print("addNewInterest  success");
        return UserProfile.fromJson(jsonDecode(response.body));
      } else {
        print(response.body);
        FirebaseCrashlytics.instance.log("addNewInterest");
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.log(response.body);

        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: response.statusCode.toString()));

        throw Exception(jsonDecode(response.body)['message'] +
            '.\nFailed to add new interest..');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("addNewInterest");

      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  Future<void> blockProfile(
      {@required String myId, @required String friendId}) async {
    try {
      var url = UrlConstants.blockUser;
      var response = await http.post(Uri.parse(url), body: {
        'my_id': myId,
        'friend_id': friendId,
      });

      if (response.statusCode == 201) {
        return;
      } else {
        FirebaseCrashlytics.instance.log("block profile");
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.log(response.body);

        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: response.statusCode.toString()));

        throw Exception('Failed to block user.');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("blockProfile");
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<BlockedUsersApiResponse> loadBlockedProfile(
      {@required String uid, @required int limit, @required int skip}) async {
    try {
      var params = {
        "uid": uid,
        "limit": limit.toString(),
        "skip": skip.toString()
      };

      var response = await http.post(
        Uri.parse(UrlConstants.blockedUserList)
        ,
        body: params,
      );

      if (response.statusCode == 201) {
        final BlockedUsersApiResponse users =
            BlockedUsersApiResponse.fromRawJson(response.body);
        return users;
      } else {
        print(response.body);
        FirebaseCrashlytics.instance.log("loadBlockedProfiles");
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.log(response.body);

        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: response.statusCode.toString()));
        throw Exception(jsonDecode(response.body)['message'] +
            '.\nFailed to load blocked list.');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      print("error: " + error.toString());
      FirebaseCrashlytics.instance.log("loadBlockedProfiles");
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw error;
    }
  }

  @override
  Future<void> unblockProfile({String myId, String friendId}) async {
    try {
      final url = Uri.parse(UrlConstants.blockUser);
      final request = http.Request("DELETE", url);
      request.headers.addAll(<String, String>{
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8'
      });
      request.body = jsonEncode({
        'my_id': myId,
        'friend_id': friendId,
      });
      final response = await request.send();

      if (response.statusCode == 200) {
        print("unblockProfile  success");
        final body = await response.stream.bytesToString();
        print(body);
        return;
      } else {
        FirebaseCrashlytics.instance.log("unblockUser");
        FirebaseCrashlytics.instance.log(response.request.toString());

        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: response.statusCode.toString()));

        throw Exception('Failed to unblock user.');
      }
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("unblockUser");
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      throw ErrorDescription(error.toString());
    }
  }

  @override
  Future<List<InterestOption>> loadInterestOptions() async {
    var url = UrlConstants.interestOptions;

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final value = interestOptionsFromJson(response.body);
        return value;
      } else {
        print(response.body);
        FirebaseCrashlytics.instance.log("loadInterestOptions");
        FirebaseCrashlytics.instance.log(response.request.toString());
        FirebaseCrashlytics.instance.log(response.body);

        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: response.statusCode.toString()));

        throw Exception(jsonDecode(response.body)['message'] +
            '.\nFailed to load interest options.');
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      throw e;
    } on SocketException catch (e) {
      print('Socket Error: ');
      throw Exception(e.osError.message);
    } catch (error, stack) {
      FirebaseCrashlytics.instance.log("loadInterestOptions");
      FirebaseCrashlytics.instance.recordFlutterError(
          FlutterErrorDetails(exception: error, stack: stack));

      print("error: " + error.toString());
      throw error;
    }
  }
}
