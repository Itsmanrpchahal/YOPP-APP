import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:yopp/modules/_common/models/interest.dart';
import 'package:yopp/modules/bottom_navigation/block_user/bloc/blocked_users.dart';

import 'package:yopp/modules/bottom_navigation/profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

abstract class ProfileService {
  Future<void> saveGender(Gender gender);
  Future<void> saveDOB(DateTime birthDate);

  //Sport Activity
  Future<UserProfile> addNewInterest({
    @required String uid,
    @required Interest interest,
  });

  Future<UserProfile> updateUserInterest({
    @required String uid,
    @required Interest interest,
    bool isSelected,
  });

  Future<UserProfile> setInterestPreference({
    @required String uid,
    @required Interest interest,
  });

  Future<UserProfile> removeInterest({
    @required String interestId,
    @required String uid,
  });

  //Address
  Future<UserProfile> saveAddress(Address address);

//Complete Profile
  Future<UserProfile> addUserProfile(UserProfile profile);

  Future<UserProfile> updateProfile(UserProfile profile);

  Future<UserProfile> loadProfile(String userId);

  Future<String> uploadProfilePhoto(File file);

  Future<void> deleteProfile(String userId);

  Future<void> blockProfile({@required String myId, @required String friendId});

  Future<void> unblockProfile(
      {@required String myId, @required String friendId});

  Future<BlockedUsersApiResponse> loadBlockedProfile(
      {@required String uid, @required int limit, @required int skip});

  Future<List<InterestOption>> loadInterestOptions();
}
