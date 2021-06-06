// To parse this JSON data, do
//
//     final blockedUsers = blockedUsersFromJson(jsonString);

import 'dart:convert';

import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

class BlockedUsersApiResponse {
  BlockedUsersApiResponse({
    this.data,
    this.total,
    this.skip,
    this.limit,
  });

  final List<BlockedUser> data;
  final int total;
  final int skip;
  final int limit;

  BlockedUsersApiResponse copyWith({
    List<BlockedUser> data,
    int total,
    int skip,
    int limit,
  }) =>
      BlockedUsersApiResponse(
        data: data ?? this.data,
        total: total ?? this.total,
        skip: skip ?? this.skip,
        limit: limit ?? this.limit,
      );

  factory BlockedUsersApiResponse.fromRawJson(String str) =>
      BlockedUsersApiResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlockedUsersApiResponse.fromJson(Map<String, dynamic> json) =>
      BlockedUsersApiResponse(
        data: json["data"] == null
            ? null
            : List<BlockedUser>.from(
                json["data"].map((dynamic x) => BlockedUser.fromJson(x))),
        total: json["total"] == null ? null : json["total"],
        skip: json["skip"] == null ? null : json["skip"],
        limit: json["limit"] == null ? null : json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total == null ? null : total,
        "skip": skip == null ? null : skip,
        "limit": limit == null ? null : limit,
      };
}

class BlockedUser {
  BlockedUser({
    this.id,
    this.uid,
    this.name,
    this.status,
    this.gender,
    this.avatar,
  });

  final String id;

  final String uid;
  final String name;
  final String avatar;

  final String status;

  final Gender gender;

  BlockedUser copyWith({
    String id,
    String uid,
    String name,
    String status,
    Gender gender,
    String avatar,
  }) =>
      BlockedUser(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        status: status ?? this.status,
        gender: gender ?? this.gender,
        avatar: avatar ?? this.avatar,
      );

  factory BlockedUser.fromRawJson(String str) =>
      BlockedUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BlockedUser.fromJson(Map<String, dynamic> json) => BlockedUser(
        id: json["_id"] == null ? null : json["_id"],
        uid: json["uid"] == null ? null : json["uid"],
        name: json["name"] == null ? null : json["name"],
        status: json["status"] == null ? null : json["status"],
        gender: json["gender"] == null
            ? null
            : json["gender"] == Gender.male.name
                ? Gender.male
                : Gender.female,
        avatar: json["avatar"] == null ? null : json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "uid": uid == null ? null : uid,
        "name": name == null ? null : name,
        "status": status == null ? null : status,
        "gender": gender == null ? null : gender.name,
        "avatar": avatar == null ? null : avatar,
      };
}
