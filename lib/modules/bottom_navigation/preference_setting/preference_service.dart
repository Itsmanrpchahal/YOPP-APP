import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yopp/helper/app_constants.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_profile.dart';

import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

abstract class PreferenceService {
  Future<void> setAgeRange(RangeValues value);
  Future<RangeValues> getAgeRange();
  Future<void> setHeightRange(RangeValues value);
  Future<RangeValues> getHeightRange();
  Future<void> setLocationRange(double distance);
  Future<double> getLocationRange();
  Future<void> setSkillLevel(SkillLevel level);
  Future<SkillLevel> getSkillLevel();
  Future<void> setGender(Gender gender);
  Future<Gender> getGender();

  Future<void> setUserProfile(UserProfile user);
  Future<UserProfile> getUserProfile();
}

class SharedPreferenceService extends PreferenceService {
  Future<void> setAgeRange(RangeValues value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('AGE_START', value.start);
    await prefs.setDouble('AGE_END', value.end);
  }

  Future<RangeValues> getAgeRange() async {
    final prefs = await SharedPreferences.getInstance();
    final start = prefs.getDouble('AGE_START');
    final end = prefs.getDouble('AGE_END');
    return RangeValues(
      start ?? PreferenceConstants.defaultStartAgeValue,
      end ?? PreferenceConstants.defaultEndAgeValue,
    );
  }

  Future<void> setHeightRange(RangeValues value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('Height_START', value.start);
    await prefs.setDouble('Height_END', value.end);
  }

  Future<RangeValues> getHeightRange() async {
    final prefs = await SharedPreferences.getInstance();
    final start = prefs.getDouble('Height_START');
    final end = prefs.getDouble('Height_END');
    return RangeValues(
      start ?? PreferenceConstants.defaultStartHeightValue,
      end ?? PreferenceConstants.defaultEndHeightValue,
    );
  }

  Future<void> setLocationRange(double distance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('LOCATION_DISTANCE', distance);
  }

  Future<double> getLocationRange() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('LOCATION_DISTANCE') ??
        PreferenceConstants.defaultLocationRangeValue;
  }

  Future<void> setSkillLevel(SkillLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('SKILL_LEVEL', level == null ? null : level.index);
  }

  Future<SkillLevel> getSkillLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getInt('SKILL_LEVEL');
    return rawValue == null ? null : SkillLevel.values[rawValue];
  }

  Future<void> setGender(Gender gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('GENDER', gender == null ? null : gender.index);
  }

  Future<Gender> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getInt('GENDER');
    return rawValue == null ? Gender.any : Gender.values[rawValue];
  }

  @override
  Future<UserProfile> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getString("UserProfile");
    return userProfileFromJson(rawValue);
  }

  @override
  Future<void> setUserProfile(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      await prefs.setString('UserProfile', userProfileToJson(user));
    } else {
      await prefs.setString('UserProfile', null);
    }
  }
}
