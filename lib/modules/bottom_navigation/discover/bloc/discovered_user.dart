// To parse this JSON data, do
//
//     final discoveredApiResponse = discoveredApiResponseFromMap(jsonString);

import 'dart:convert';

import 'package:yopp/modules/_common/sports/data/requirements/cycling_requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/running-requirements.dart';
import 'package:yopp/modules/_common/sports/data/requirements/sports_requirements.dart';
import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

class DiscoveredApiResponse {
  DiscoveredApiResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  final int statusCode;
  final String message;
  final DiscoverData data;

  DiscoveredApiResponse copyWith({
    int statusCode,
    String message,
    DiscoverData data,
  }) =>
      DiscoveredApiResponse(
        statusCode: statusCode ?? this.statusCode,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DiscoveredApiResponse.fromJson(String str) =>
      DiscoveredApiResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiscoveredApiResponse.fromMap(Map<String, dynamic> json) =>
      DiscoveredApiResponse(
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : DiscoverData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "statusCode": statusCode == null ? null : statusCode,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toMap(),
      };
}

class DiscoverData {
  DiscoverData({
    this.interest,
    this.category,
    this.subCategory,
    this.users,
  });

  final DataInterest interest;
  final DataCategory category;
  final SubCategory subCategory;
  final Users users;

  DiscoverData copyWith({
    DataInterest interest,
    DataCategory category,
    SubCategory subCategory,
    Users users,
  }) =>
      DiscoverData(
        interest: interest ?? this.interest,
        category: category ?? this.category,
        subCategory: subCategory ?? this.subCategory,
        users: users ?? this.users,
      );

  factory DiscoverData.fromJson(String str) =>
      DiscoverData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiscoverData.fromMap(Map<String, dynamic> json) => DiscoverData(
        interest: json["interest"] == null
            ? null
            : DataInterest.fromMap(json["interest"]),
        category: json["category"] == null
            ? null
            : DataCategory.fromMap(json["category"]),
        subCategory: json["subCategory"] == null
            ? null
            : SubCategory.fromMap(json["subCategory"]),
        users: json["users"] == null ? null : Users.fromMap(json["users"]),
      );

  Map<String, dynamic> toMap() => {
        "interest": interest == null ? null : interest.toMap(),
        "category": category == null ? null : category.toMap(),
        "subCategory": subCategory == null ? null : subCategory.toMap(),
        "users": users == null ? null : users.toMap(),
      };
}

class DataCategory {
  DataCategory({
    this.categories,
    this.total,
  });

  final List<CategoryElement> categories;
  final int total;

  DataCategory copyWith({
    List<CategoryElement> categories,
    int total,
  }) =>
      DataCategory(
        categories: categories ?? this.categories,
        total: total ?? this.total,
      );

  factory DataCategory.fromJson(String str) =>
      DataCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataCategory.fromMap(Map<String, dynamic> json) => DataCategory(
        categories: json["categories"] == null
            ? null
            : List<CategoryElement>.from(
                json["categories"].map((x) => CategoryElement.fromMap(x))),
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toMap() => {
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories.map((x) => x.toMap())),
        "total": total == null ? null : total,
      };
}

class CategoryElement {
  CategoryElement({
    this.online,
    this.total,
    this.name,
    this.id,
  });

  final int online;
  final int total;
  final String name;
  final String id;

  CategoryElement copyWith({
    int online,
    int total,
    String name,
    String id,
  }) =>
      CategoryElement(
        online: online ?? this.online,
        total: total ?? this.total,
        name: name ?? this.name,
        id: id ?? this.id,
      );

  factory CategoryElement.fromJson(String str) =>
      CategoryElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CategoryElement.fromMap(Map<String, dynamic> json) => CategoryElement(
        online: json["online"] == null ? null : json["online"],
        total: json["total"] == null ? null : json["total"],
        name: json["name"] == null ? null : json["name"],
        id: json["id"] == null ? null : json["id"],
      );

  Map<String, dynamic> toMap() => {
        "online": online == null ? null : online,
        "total": total == null ? null : total,
        "name": name == null ? null : name,
        "id": id == null ? null : id,
      };
}

class DataInterest {
  DataInterest({
    this.online,
    this.total,
  });

  final int online;
  final int total;

  DataInterest copyWith({
    int online,
    int total,
  }) =>
      DataInterest(
        online: online ?? this.online,
        total: total ?? this.total,
      );

  factory DataInterest.fromJson(String str) =>
      DataInterest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataInterest.fromMap(Map<String, dynamic> json) => DataInterest(
        online: json["online"] == null ? null : json["online"],
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toMap() => {
        "online": online == null ? null : online,
        "total": total == null ? null : total,
      };
}

class SubCategory {
  SubCategory({
    this.subCategories,
    this.total,
  });

  final List<CategoryElement> subCategories;
  final int total;

  SubCategory copyWith({
    List<CategoryElement> subCategories,
    int total,
  }) =>
      SubCategory(
        subCategories: subCategories ?? this.subCategories,
        total: total ?? this.total,
      );

  factory SubCategory.fromJson(String str) =>
      SubCategory.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubCategory.fromMap(Map<String, dynamic> json) => SubCategory(
        subCategories: json["subCategories"] == null
            ? null
            : List<CategoryElement>.from(
                json["subCategories"].map((x) => CategoryElement.fromMap(x))),
        total: json["total"] == null ? null : json["total"],
      );

  Map<String, dynamic> toMap() => {
        "subCategories": subCategories == null
            ? null
            : List<dynamic>.from(subCategories.map((x) => x.toMap())),
        "total": total == null ? null : total,
      };
}

class Users {
  Users({
    this.data,
    this.meta,
  });

  final List<DiscoveredUserData> data;
  final Meta meta;

  Users copyWith({
    List<DiscoveredUserData> data,
    Meta meta,
  }) =>
      Users(
        data: data ?? this.data,
        meta: meta ?? this.meta,
      );

  factory Users.fromJson(String str) => Users.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        data: json["data"] == null
            ? null
            : List<DiscoveredUserData>.from(
                json["data"].map((x) => DiscoveredUserData.fromMap(x))),
        meta: json["meta"] == null ? null : Meta.fromMap(json["meta"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
        "meta": meta == null ? null : meta.toMap(),
      };
}

class DiscoveredUserData {
  DiscoveredUserData({
    this.avatar,
    this.age,
    this.about,
    this.id,
    this.uid,
    this.name,
    this.status,
    this.gender,
    this.online,
    this.selectedInterest,
    this.distance,
    this.height,
  });

  final int age;
  final String about;
  final String avatar;
  final int height;

  final String id;

  final String uid;
  final String name;

  final String status;

  final Gender gender;

  final bool online;

  final SelectedInterestElement selectedInterest;

  final double distance;

  DiscoveredUserData copyWith({
    String id,
    String uid,
    String name,
    int age,
    int height,
    String status,
    Gender gender,
    String avatar,
    bool online,
    SelectedInterestElement selectedInterest,
    double distance,
  }) =>
      DiscoveredUserData(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        age: age ?? this.age,
        avatar: avatar ?? this.avatar,
        status: status ?? this.status,
        gender: gender ?? this.gender,
        online: online ?? this.online,
        selectedInterest: selectedInterest ?? this.selectedInterest,
        distance: distance ?? this.distance,
        height: height ?? this.height,
        about: this.about,
      );

  factory DiscoveredUserData.fromJson(String str) =>
      DiscoveredUserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiscoveredUserData.fromMap(Map<String, dynamic> json) {
    var data = DiscoveredUserData(
      id: json["_id"] == null ? null : json["_id"],
      uid: json["uid"] == null ? null : json["uid"],
      name: json["name"] == null ? "Yopp User" : json["name"],
      status: json["status"] == null ? null : json["status"],
      gender: json["gender"] == null
          ? null
          : json["gender"] == Gender.male.name
              ? Gender.male
              : Gender.female,
      online: json["online"] == null ? null : json["online"],
      selectedInterest: json["selected_interest"] == null
          ? null
          : SelectedInterestElement.fromMap(json["selected_interest"]),
      distance: json["distance"] == null ? null : json["distance"].toDouble(),
      avatar: json["avatar"] == null ? null : json["avatar"],
      about: json["about"] == null ? null : json["about"],
      height: json["height"] == null ? null : json["height"].toInt(),
    );

    if (json["dob"] != null) {
      data = data.copyWith(age: DateTime.now().year - json["dob"]);
    }

    if (json["birthDate"] != null) {
      final birthdate = DateTime.tryParse(json['birthDate']);
      final age = DateTime.now().difference(birthdate).inDays / 365;
      data = data.copyWith(age: age.toInt());
    }
    return data;
  }

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "uid": uid == null ? null : uid,
        "name": name == null ? null : name,
        "status": status == null ? null : status,
        "gender": gender == null ? null : gender.name,
        "online": online == null ? null : online,
        "selected_interest":
            selectedInterest == null ? null : selectedInterest.toMap(),
        "distance": distance == null ? null : distance,
        "height": height == null ? null : height,
      };

  String getSelectedInterestDescription() {
    var interestText = "";
    if (selectedInterest?.interest != null) {
      interestText = selectedInterest.interest;
    }
    if (selectedInterest?.category != null) {
      interestText += " > " + selectedInterest.category;
    }
    if (selectedInterest?.subCategory != null) {
      interestText += " > " + selectedInterest.subCategory;
    }
    return interestText;
  }
}

class SelectedInterestElement {
  SelectedInterestElement({
    this.id,
    this.interest,
    this.category,
    this.subCategory,
    this.skill,
    this.pace,
    this.cyclingLevel,
    this.runningLevel,
    this.gender,
  });

  final Gender gender;
  final String id;
  final String interest;
  final String category;
  final String subCategory;
  final SkillLevel skill;

  final PaceLevel pace;
  final CyclingLevel cyclingLevel;
  final RunningLevel runningLevel;

  SelectedInterestElement copyWith({
    String id,
    String interest,
    String category,
    String subCategory,
    SkillLevel skill,
    PaceLevel pace,
    CyclingLevel cyclingLevel,
    RunningLevel runningLevel,
    Gender gender,
  }) =>
      SelectedInterestElement(
        id: id ?? this.id,
        interest: interest ?? this.interest,
        category: category ?? this.category,
        subCategory: subCategory ?? this.subCategory,
        skill: skill ?? this.skill,
        pace: pace ?? this.pace,
        cyclingLevel: cyclingLevel ?? this.cyclingLevel,
        runningLevel: runningLevel ?? this.runningLevel,
        gender: gender ?? this.gender,
      );

  factory SelectedInterestElement.fromJson(String str) =>
      SelectedInterestElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SelectedInterestElement.fromMap(Map<String, dynamic> json) =>
      SelectedInterestElement(
        id: json["_id"] == null ? null : json["_id"],
        interest: json["interest"] == null ? null : json["interest"],
        category: json["category"] == null ? null : json["category"],
        subCategory: json["subCategory"] == null ? null : json["subCategory"],
        skill: json["skill"] == null
            ? null
            : SkillLevel.values.firstWhere(
                (element) =>
                    element.name.toLowerCase() ==
                    json["skill"].toString().toLowerCase(),
                orElse: () => SkillLevel.beginner),
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
            : json["gender"] == Gender.male.name
                ? Gender.male
                : Gender.female,
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "interest": interest == null ? null : interest,
        "category": category == null ? null : category,
        "subCategory": subCategory == null ? null : subCategory,
        "skill": skill == null ? null : skill.name,
        "pace": pace == null ? null : pace.index,
        "cyclingLevel": cyclingLevel == null ? null : cyclingLevel.index,
        "runningLevel": runningLevel == null ? null : runningLevel.index,
        "gender": gender == null ? null : gender.name,
      };
}

class Location {
  Location({
    this.type,
    this.coordinates,
  });

  final String type;
  final List<double> coordinates;

  Location copyWith({
    String type,
    List<double> coordinates,
  }) =>
      Location(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory Location.fromJson(String str) => Location.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        type: json["type"] == null ? null : json["type"],
        coordinates: json["coordinates"] == null
            ? null
            : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toMap() => {
        "type": type == null ? null : type,
        "coordinates": coordinates == null
            ? null
            : List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Meta {
  Meta({
    this.total,
    this.limit,
    this.skip,
  });

  final int total;
  final int limit;
  final int skip;

  Meta copyWith({
    int total,
    int limit,
    int skip,
  }) =>
      Meta(
        total: total ?? this.total,
        limit: limit ?? this.limit,
        skip: skip ?? this.skip,
      );

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        total: json["total"] == null ? null : json["total"],
        limit: json["limit"] == null ? null : json["limit"],
        skip: json["skip"] == null ? null : json["skip"],
      );

  Map<String, dynamic> toMap() => {
        "total": total == null ? null : total,
        "limit": limit == null ? null : limit,
        "skip": skip == null ? null : skip,
      };
}
