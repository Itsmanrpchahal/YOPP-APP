import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';

import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

abstract class ProfileService {
  Future<void> saveGender(Gender gender);
  Future<void> saveDOB(int year);

  //Sport Activity
  Future<void> saveAndSetSelectedSportAcitivy({
    @required UserProfile userProfile,
    @required UserSport sport,
    double height,
    double weight,
  });

  Future<void> saveSportAcitivy({
    @required UserSport sport,
    double height,
    double weight,
  });

  Future<UserSport> getUserSport(String sportName);

  Future<List<UserSport>> getUserSports(String userId);

  Future<void> setSelectedSport({
    @required UserProfile userProfile,
    @required UserSport sport,
  });

  Future<void> removeSportActivity(String sportName);

  //Address
  Future<void> saveAddress(Address address);

//Complete Profile
  Future<UserProfile> addUserProfile(UserProfile profile);

  Future<void> updateProfile(UserProfile profile);

  Future<UserProfile> getupdateProfile(String userId);

  Future<String> uploadProfilePhoto(File file);

  Future<void> deleteProfile(String userId);

  Future<void> blockProfile({@required String uid, @required String id});
}
