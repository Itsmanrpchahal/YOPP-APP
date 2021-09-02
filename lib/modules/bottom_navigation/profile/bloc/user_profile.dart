import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geocoder/geocoder.dart';
import 'package:yopp/modules/_common/sports/data/requirements/cycling_requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/running-requirements.dart';

import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';

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
    this.birthDate,
    this.about,
    this.height,
    this.gender,
    this.address,
    this.status,
    this.blocked,
    this.blockedBy,
    this.interests = const [],
    this.selectedInterest,
    this.location,
    this.online,
    this.connection,
  });

  final String avatar;
  final String phone;
  final String countryCode;
  final bool online;

  final String id;
  final String uid;
  final String name;
  final String email;
  final int age;
  final int dob;
  final DateTime birthDate;
  final String about;

  final int height;

  final Gender gender;
  final Address address;
  final Interest selectedInterest;

  final UserStatus status;

  final List<String> blocked;
  final List<String> blockedBy;

  final List<Interest> interests;
  final Location location;
  final List<Connection> connection;

  UserProfile copyWith({
    String id,
    String uid,
    String name,
    String phone,
    int height,
    UserStatus status,
    String countryCode,
    String email,
    Interest selectedInterest,
    List<Interest> interest,
    String userId,
    Address address,
    String about,
    int age,
    int dob,
    DateTime birthDate,
    Gender gender,
    String avatar,
    Location location,
    bool online,
    List<Connection> connection,
    List<String> blocked,
    List<String> blockedBy,
  }) {
    return UserProfile(
      blocked: blocked ?? this.blocked,
      blockedBy: blockedBy ?? this.blockedBy,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      selectedInterest: selectedInterest ?? this.selectedInterest,
      about: about ?? this.about,
      dob: dob ?? this.dob,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      interests: interests ?? this.interests,
      location: location ?? this.location,
      online: online ?? this.online,
      connection: connection ?? this.connection,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var data = UserProfile(
      id: json["id"] == null ? null : json["_id"],
      uid: json["uid"] == null ? null : json["uid"],
      email: json["email"] == null ? null : json["email"],
      phone: json['phone'] == null ? null : json['phone'],
      countryCode: json['countryCode'] == null ? null : json["countryCode"],
      avatar: json["avatar"] == null ? null : json["avatar"],
      name: json["name"] == null ? null : json["name"],
      dob: json["dob"] == null ? null : json["dob"],
      birthDate: json["birthDate"] == null
          ? null
          : DateTime.tryParse(json["birthDate"]),
      about: json["about"] == null ? null : json["about"],
      height: json["height"] == null ? null : json["height"].toInt(),
      gender: json["gender"] == null
          ? null
          : json["gender"] == Gender.male.name
              ? Gender.male
              : Gender.female,
      address:
          json["address"] == null ? null : Address.fromMap(json["address"]),
      location:
          json["location"] == null ? null : Location.fromJson(json["location"]),
      status: json["status"] == null ? null : getStatus(json['status']),
      blocked: json["blocked"] == null
          ? []
          : List<String>.from(json["blocked"].map((x) => x)),
      blockedBy: json["blocked_by"] == null
          ? []
          : List<String>.from(json["blocked_by"].map((x) => x)),
      selectedInterest: json["selected_interest"] == null
          ? null
          : Interest.fromJson(json["selected_interest"]),
      interests: json["interest"] == null
          ? null
          : List<Interest>.from(
              json["interest"].map(
                (x) => Interest.fromJson(x),
              ),
            ),
      online: json["online"] == null ? null : json["online"],
      connection: json["connection"] == null
          ? null
          : List<Connection>.from(
              json["connection"].map(
                (x) => Connection.fromMap(x),
              ),
            ),
    );

    if (data.dob != null) {
      final age = DateTime.now().year - data.dob;
      data = data.copyWith(age: age);
    }

    if (data.birthDate != null) {
      final age = DateTime.now().difference(data.birthDate).inDays / 365;
      data = data.copyWith(age: age.toInt());
    }

    return data;
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();

    if (id != null) {
      json["_id"] = id;
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

    if (birthDate != null) {
      json["birthDate"] = birthDate.toIso8601String();
    }
    if (about != null) {
      json["about"] = about;
    }

    if (height != null) {
      json["height"] = height;
    }

    if (gender != null) {
      json["gender"] = gender.name;
    }

    // if (address != null) {
    //   json["address"] = address.toMap();
    // }

    if (selectedInterest != null) {
      json["selected_interest"] = selectedInterest;
    }

    if (status != null) {
      json["status"] = status.description;
    }

    if (interests != null) {
      json["interests"] = List<dynamic>.from(interests.map((x) => x.toJson()));
    }

    if (address != null) {
      json["location"] = {
        "type": "Point",
        "coordinates": [
          address.coordinates.longitude,
          address.coordinates.latitude
        ],
      };
    }

    if (location != null) {
      json["location"] = location;
    }

    if (connection != null) {
      json["connection"] = List<dynamic>.from(connection.map((x) => x.toMap()));
    }

    if (blocked != null) {
      json["blocked"] = blocked;
    }

    if (blockedBy != null) {
      json["blocked_by"] = blockedBy;
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
        this.gender,
        this.address,
        this.selectedInterest,
        this.interests,
        this.status,
        this.location,
        this.online,
        this.blocked,
        this.blockedBy,
      ];

  String getSelectedInterestDescription() {
    var interestText = "";
    if (selectedInterest?.interest != null) {
      interestText = selectedInterest.interest.name;
    }
    if (selectedInterest?.category != null) {
      interestText += " > " + selectedInterest.category.name;
    }
    if (selectedInterest?.subCategory != null) {
      interestText += " > " + selectedInterest.subCategory.name;
    }
    return interestText;
  }
}

class Interest {
  Interest({
    this.id,
    this.interest,
    this.category,
    this.subCategory,
    this.skill,
    this.pace,
    this.cyclingLevel,
    this.runningLevel,
    this.gender,
    this.image,
  });

  final String id;
  final IdNameImage interest;
  final IdNameImage category;
  final IdNameImage subCategory;
  final SkillLevel skill;
  final PaceLevel pace;
  final CyclingLevel cyclingLevel;
  final RunningLevel runningLevel;

  final Gender gender;
  final String image;

  Interest copyWith({
    String id,
    IdNameImage interest,
    IdNameImage category,
    IdNameImage subCategory,
    SkillLevel skill,
    PaceLevel pace,
    CyclingLevel cyclingLevel,
    RunningLevel runningLevel,
    Gender gender,
    String image,
  }) =>
      Interest(
        id: id ?? this.id,
        interest: interest ?? this.interest,
        category: category ?? this.category,
        subCategory: subCategory ?? this.subCategory,
        skill: skill ?? this.skill,
        pace: pace ?? this.pace,
        cyclingLevel: cyclingLevel ?? this.cyclingLevel,
        runningLevel: runningLevel ?? this.runningLevel,
        gender: gender ?? this.gender,
        image: image ?? this.image,
      );

  factory Interest.fromRawJson(String str) =>
      Interest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        id: json["_id"] == null ? null : json["_id"],
        interest: json["interest"] == null
            ? null
            : IdNameImage.fromJson(json["interest"]),
        category: json["category"] == null
            ? null
            : IdNameImage.fromJson(json["category"]),
        subCategory: json["subCategory"] == null
            ? null
            : IdNameImage.fromJson(json["subCategory"]),
        skill: json["skill"] == null
            ? null
            : parseSkillLevelFromString(json["skill"]),
        pace: json["pace"] == null
            ? null
            : PaceLevel.values.firstWhere(
                (element) => element.index == json["pace"],
                orElse: () => PaceLevel.intermediate),
        cyclingLevel: json["cyclingLevel"] == null
            ? null
            : CyclingLevel.values.firstWhere(
                (element) => element.index == json["cyclingLevel"],
                orElse: () => CyclingLevel.level0),
        runningLevel: json["runningLevel"] == null
            ? null
            : RunningLevel.values.firstWhere(
                (element) => element.index == json["runningLevel"],
                orElse: () => RunningLevel.level0),
        gender: json["gender"] == null
            ? null
            : parseGenderFromString(json["gender"]),
      );

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    if (id != null) {
      json["_id"] = id;
    }
    if (interest?.id != null) {
      json["interest"] = interest.id;
    }
    if (category?.id != null) {
      json["category"] = category.id;
    }

    if (subCategory?.id != null) {
      json["subCategory"] = subCategory.id;
    }
    if (skill != null) {
      json["skill"] = skill.name;
    }

    if (pace != null) {
      json["pace"] = pace.index.toString();
    }

    if (cyclingLevel != null) {
      json["cyclingLevel"] = cyclingLevel.index.toString();
    }

    if (runningLevel != null) {
      json["runningLevel"] = runningLevel.index.toString();
    }

    if (gender != null) {
      json["gender"] = gender.name;
    }

    return json;
  }

  String getInterestName() {
    if (subCategory?.name != null) {
      return subCategory.name;
    }
    if (category?.name != null) {
      return category.name;
    }

    if (interest?.name != null) {
      return interest.name;
    }
    return "";
  }
}

class IdNameImage {
  IdNameImage({
    this.id,
    this.name,
    this.image,
  });

  final String id;
  final String name;
  final String image;

  IdNameImage copyWith({
    String id,
    String name,
    String image,
  }) =>
      IdNameImage(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
      );

  factory IdNameImage.fromRawJson(String str) =>
      IdNameImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IdNameImage.fromJson(Map<String, dynamic> json) => IdNameImage(
      id: json["_id"] == null ? null : json["_id"],
      name: json["name"] == null ? null : json["name"],
      image: json["image"] == null ? null : json["image"]);

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image
      };
}

class Location {
  Location({
    this.coordinates,
    this.type,
  });

  final List<double> coordinates;
  final String type;

  Location copyWith({
    List<double> coordinates,
    String type,
  }) =>
      Location(
        coordinates: coordinates ?? this.coordinates,
        type: type ?? this.type,
      );

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        coordinates: json["coordinates"] == null
            ? null
            : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates == null
            ? null
            : List<dynamic>.from(coordinates.map((x) => x)),
        "type": type == null ? null : type,
      };
}

class Connection {
  Connection({
    this.id,
    this.user,
    this.connectedAt,
    this.connectionId,
    this.interest,
  });

  final String id;
  final String user;
  final String connectedAt;
  final String connectionId;
  final String interest;

  Connection copyWith({
    String id,
    String user,
    String connectedAt,
    String connectionId,
    String interest,
  }) =>
      Connection(
        id: id ?? this.id,
        user: user ?? this.user,
        connectedAt: connectedAt ?? this.connectedAt,
        connectionId: connectionId ?? this.connectionId,
        interest: interest ?? this.interest,
      );

  factory Connection.fromJson(String str) =>
      Connection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Connection.fromMap(Map<String, dynamic> json) => Connection(
        id: json["_id"] == null ? null : json["_id"],
        user: json["user"] == null ? null : json["user"],
        connectedAt: json["connected_at"] == null ? null : json["connected_at"],
        connectionId:
            json["connection_id"] == null ? null : json["connection_id"],
        interest: json["interest"] == null ? null : json["interest"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "user": user == null ? null : user,
        "connected_at": connectedAt == null ? null : connectedAt,
        "connection_id": connectionId == null ? null : connectionId,
        "interest": interest == null ? null : interest,
      };
}
