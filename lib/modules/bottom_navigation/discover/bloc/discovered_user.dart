import 'dart:convert';

import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

class DiscoveredData {
  DiscoveredData({
    this.data,
    this.meta,
  });

  final List<DiscoveredUser> data;
  final Meta meta;

  factory DiscoveredData.fromJson(String str) =>
      DiscoveredData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiscoveredData.fromMap(Map<String, dynamic> json) => DiscoveredData(
        data: json["data"] == null
            ? null
            : List<DiscoveredUser>.from(
                json["data"].map((x) => DiscoveredUser.fromMap(x))),
        meta: json["meta"] == null ? null : Meta.fromMap(json["meta"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
        "meta": meta == null ? null : meta.toMap(),
      };
}

class Meta {
  Meta({
    this.total,
    this.limit,
    this.page,
    this.pages,
  });

  final int total;
  final int limit;
  final int page;
  final int pages;

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        total: json["total"] == null ? null : json["total"],
        limit: json["limit"] == null ? null : json["limit"],
        page: json["page"] == null ? null : json["page"],
        pages: json["pages"] == null ? null : json["pages"],
      );

  Map<String, dynamic> toMap() => {
        "total": total == null ? null : total,
        "limit": limit == null ? null : limit,
        "page": page == null ? null : page,
        "pages": pages == null ? null : pages,
      };
}

class DiscoveredUser {
  DiscoveredUser({
    this.id,
    this.blocked,
    this.liked,
    this.seen,
    this.uid,
    this.name,
    this.avatar,
    this.phone,
    this.status,
    this.countryCode,
    this.email,
    this.gender,
    this.height,
    this.selectedSport,
    this.about,
    this.dob,
    this.distance,
  });

  final String id;
  final List<dynamic> blocked;
  final List<dynamic> liked;
  final List<dynamic> seen;
  final String uid;
  final String name;
  final String avatar;
  final String phone;
  final String status;
  final String countryCode;
  final String email;
  final Gender gender;
  final int height;
  final String selectedSport;
  final String about;
  final int dob;
  final double distance;

  DiscoveredUser copyWith({
    String id,
    List<dynamic> blocked,
    List<dynamic> liked,
    List<dynamic> seen,
    String uid,
    String name,
    String avatar,
    String phone,
    String status,
    String countryCode,
    String email,
    String gender,
    int height,
    String selectedSport,
    String about,
    int dob,
    double distance,
  }) =>
      DiscoveredUser(
        id: id ?? this.id,
        blocked: blocked ?? this.blocked,
        liked: liked ?? this.liked,
        seen: seen ?? this.seen,
        uid: uid ?? this.uid,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        phone: phone ?? this.phone,
        status: status ?? this.status,
        countryCode: countryCode ?? this.countryCode,
        email: email ?? this.email,
        gender: gender ?? this.gender,
        height: height ?? this.height,
        selectedSport: selectedSport ?? this.selectedSport,
        about: about ?? this.about,
        dob: dob ?? this.dob,
        distance: distance ?? this.distance,
      );

  factory DiscoveredUser.fromJson(String str) =>
      DiscoveredUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiscoveredUser.fromMap(Map<String, dynamic> json) => DiscoveredUser(
        id: json["_id"] == null ? null : json["_id"],
        blocked: json["blocked"] == null
            ? null
            : List<dynamic>.from(json["blocked"].map((x) => x)),
        liked: json["liked"] == null
            ? null
            : List<dynamic>.from(json["liked"].map((x) => x)),
        seen: json["seen"] == null
            ? null
            : List<dynamic>.from(json["seen"].map((x) => x)),
        uid: json["uid"] == null ? null : json["uid"],
        name: json["name"] == null ? null : json["name"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        phone: json["phone"] == null ? null : json["phone"],
        status: json["status"] == null ? null : json["status"],
        countryCode: json["countryCode"] == null ? null : json["countryCode"],
        email: json["email"] == null ? null : json["email"],
        gender: json["gender"] == null
            ? null
            : json["gender"] == Gender.male.name
                ? Gender.male
                : Gender.female,
        height: json["height"] == null ? null : json["height"],
        selectedSport:
            json["selectedSport"] == null ? null : json["selectedSport"],
        about: json["about"] == null ? null : json["about"],
        dob: json["dob"] == null ? null : json["dob"],
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "blocked":
            blocked == null ? null : List<dynamic>.from(blocked.map((x) => x)),
        "liked": liked == null ? null : List<dynamic>.from(liked.map((x) => x)),
        "seen": seen == null ? null : List<dynamic>.from(seen.map((x) => x)),
        "uid": uid == null ? null : uid,
        "name": name == null ? null : name,
        "avatar": avatar == null ? null : avatar,
        "phone": phone == null ? null : phone,
        "status": status == null ? null : status,
        "countryCode": countryCode == null ? null : countryCode,
        "email": email == null ? null : email,
        "gender": gender == null ? null : gender.name,
        "height": height == null ? null : height,
        "selectedSport": selectedSport == null ? null : selectedSport,
        "about": about == null ? null : about,
        "dob": dob == null ? null : dob,
        "distance": distance == null ? null : distance,
      };
}
