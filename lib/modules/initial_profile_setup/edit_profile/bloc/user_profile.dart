import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geocoder/geocoder.dart';
import 'package:yopp/modules/initial_profile_setup/edit_profile/bloc/user_sport.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

UserProfile userProfileFromJson(String str) =>
    UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

enum UserStatus {
  pending,
  active,
  paused,
  deleted,
  unknown,
}

extension name on UserStatus {
  String get description {
    String value;
    switch (this) {
      case UserStatus.pending:
        value = "pending";
        break;
      case UserStatus.paused:
        value = "paused";
        break;
      case UserStatus.deleted:
        value = "deleted";
        break;
      case UserStatus.active:
        value = "active";
        break;
      case UserStatus.unknown:
        value = "unknown";
        break;
    }
    return value;
  }
}

UserStatus getStatus(String value) {
  UserStatus status;
  switch (value) {
    case "pending":
      status = UserStatus.pending;
      break;
    case "active":
      status = UserStatus.active;
      break;
    case "paused":
      status = UserStatus.paused;
      break;
    case "deleted":
      status = UserStatus.deleted;
      break;

    default:
      status = UserStatus.unknown;
  }
  return status;
}

class UserProfile extends Equatable {
  UserProfile({
    this.id,
    this.uid,
    this.email,
    this.avatar,
    this.name,
    this.countryCode,
    this.phone,
    this.age,
    this.dob,
    this.about,
    this.height,
    this.weight,
    this.gender,
    this.address,
    this.selectedSport,
    this.status,
    this.searchBy,
    this.userType,
    this.blocked,
    this.blockedBy,
  });

  final String avatar;
  final String phone;
  final String countryCode;

  final String id;
  final String uid;
  final String name;
  final String email;
  final int age;
  final int dob;
  final String about;

  final double height;
  final double weight;
  final Gender gender;
  final Address address;
  final UserSport selectedSport;
  final String searchBy;
  final UserStatus status;
  final String userType;
  final List<String> blocked;
  final List<String> blockedBy;

  UserProfile copyWith({
    String id,
    String uid,
    String imageUrl,
    UserStatus status,
    List<String> blocked,
    List<String> blockedBy,
  }) {
    return UserProfile(
      id: id ?? this.id,
      avatar: imageUrl ?? this.avatar,
      uid: uid ?? this.uid,
      email: this.email,
      phone: this.phone,
      countryCode: this.countryCode,
      name: this.name,
      age: this.age,
      dob: this.dob,
      about: this.about,
      height: this.height,
      weight: this.weight,
      gender: this.gender,
      address: this.address,
      selectedSport: this.selectedSport,
      status: status ?? this.status,
      userType: this.userType,
      blocked: blocked ?? this.blocked,
      blockedBy: blockedBy ?? this.blockedBy,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json["id"] == null ? null : json["id"],
        uid: json["uid"] == null ? null : json["uid"],
        email: json["email"] == null ? null : json["email"],
        phone: json['phone'] == null ? null : json['phone'],
        countryCode: json['countryCode'] == null ? null : json["countryCode"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        name: json["name"] == null ? null : json["name"],
        age: json["dob"] == null ? null : DateTime.now().year - json["dob"],
        dob: json["dob"] == null ? null : json["dob"],
        about: json["about"] == null ? null : json["about"],
        height: json["height"] == null ? null : json["height"].toDouble(),
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        gender: json["gender"] == null
            ? null
            : json["gender"] == Gender.male.name
                ? Gender.male
                : Gender.female,
        address:
            json["address"] == null ? null : Address.fromMap(json["address"]),
        selectedSport: json["selectedSport"] == null
            ? null
            : UserSport.fromJson(json["selectedSport"]),
        status: json["status"] == null ? null : getStatus(json['status']),
        searchBy: json["searchBy"] == null ? null : json["searchBy"],
        userType: json["userType"] == null ? null : json["userType"],
        blocked: json["blocked"] == null
            ? []
            : List<String>.from(json["blocked"].map((x) => x)),
        blockedBy: json["blockedBy"] == null
            ? []
            : List<String>.from(json["blockedBy"].map((x) => x)),
      );

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();

    if (id != null) {
      json["id"] = id;
    }

    if (uid != null) {
      json["uid"] = uid;
    }

    if (email != null) {
      json["email"] = email;
    }

    if (phone != null) {
      json['phone'] = phone;
    }

    if (countryCode != null) {
      json['countryCode'] = countryCode;
    }

    if (avatar != null) {
      json["avatar"] = avatar;
    }

    if (name != null) {
      json["name"] = name;
    }
    if (age != null) {
      json["dob"] = DateTime.now().year - age;
    }
    if (dob != null) {
      json["dob"] = dob;
    }
    if (about != null) {
      json["about"] = about;
    }

    if (height != null) {
      json["height"] = height;
    }
    if (weight != null) {
      json["weight"] = weight;
    }
    if (gender != null) {
      json["gender"] = gender.name;
    }

    if (address != null) {
      json["address"] = address.toMap();
    }

    if (selectedSport != null) {
      json["selectedSport"] = selectedSport.toJson();
    }

    if (searchBy != null) {
      json["searchBy"] = searchBy;
    }

    if (status != null) {
      json["status"] = status.description;
    }

    return json;
  }

  @override
  List<Object> get props => [
        this.uid,
        this.email,
        this.avatar,
        this.name,
        this.countryCode,
        this.phone,
        this.age,
        this.about,
        this.height,
        this.weight,
        this.gender,
        this.address,
        this.selectedSport,
        this.status,
        this.searchBy,
        this.userType,
      ];
}
