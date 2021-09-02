// To parse this JSON data, do
//
//     final userConnection = userConnectionFromMap(jsonString);

import 'dart:convert';

import 'package:yopp/modules/initial_profile_setup/select_gender/bloc/gender.dart';

class UserConnection {
  UserConnection({
    this.data = const [],
    this.total,
    this.skip,
    this.limit,
  });

  final List<ConnectionData> data;
  final int total;
  final int skip;
  final int limit;

  UserConnection copyWith({
    List<ConnectionData> data,
    int total,
    int skip,
    int limit,
  }) =>
      UserConnection(
        data: data ?? this.data,
        total: total ?? this.total,
        skip: skip ?? this.skip,
        limit: limit ?? this.limit,
      );

  factory UserConnection.fromJson(String str) =>
      UserConnection.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserConnection.fromMap(Map<String, dynamic> json) => UserConnection(
        data: json["data"] == null
            ? null
            : List<ConnectionData>.from(
                json["data"].map((x) => ConnectionData.fromMap(x))),
        total: json["total"] == null ? null : json["total"],
        skip: json["skip"] == null ? null : json["skip"],
        limit: json["limit"] == null ? null : json["limit"],
      );

  Map<String, dynamic> toMap() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
        "total": total == null ? null : total,
        "skip": skip == null ? null : skip,
        "limit": limit == null ? null : limit,
      };
}

class ConnectionData {
  ConnectionData({
    this.id,
    this.user,
    this.connectedAt,
    this.connectionId,
    this.interest,
  });

  final String id;
  final ConnectionUser user;
  final String connectedAt;
  final String connectionId;
  final String interest;

  ConnectionData copyWith({
    String id,
    ConnectionUser user,
    String connectedAt,
    String connectionId,
    String interest,
  }) =>
      ConnectionData(
        id: id ?? this.id,
        user: user ?? this.user,
        connectedAt: connectedAt ?? this.connectedAt,
        connectionId: connectionId ?? this.connectionId,
        interest: interest ?? this.interest,
      );

  factory ConnectionData.fromJson(String str) =>
      ConnectionData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConnectionData.fromMap(Map<String, dynamic> json) => ConnectionData(
        id: json["_id"] == null ? null : json["_id"],
        user:
            json["user"] == null ? null : ConnectionUser.fromMap(json["user"]),
        connectedAt: json["connected_at"] == null ? null : json["connected_at"],
        connectionId:
            json["connection_id"] == null ? null : json["connection_id"],
        interest: json["interest"] == null ? null : json["interest"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "user": user == null ? null : user.toMap(),
        "connected_at": connectedAt == null ? null : connectedAt,
        "connection_id": connectionId == null ? null : connectionId,
        "interest": interest == null ? null : interest,
      };
}

class ConnectionUser {
  ConnectionUser({
    this.id,
    this.uid,
    this.v,
    this.createdAt,
    this.status,
    this.updatedAt,
    this.gender,
    this.location,
    this.dob,
    this.name,
    this.about,
    this.avatar,
    this.selectedInterest,
    this.interest,
    this.online,
    this.connection,
  });

  final String id;
  final String uid;
  final int v;
  final DateTime createdAt;

  final String status;
  final DateTime updatedAt;
  final Gender gender;
  final ConnectionLocation location;
  final int dob;
  final String name;
  final String about;
  final String avatar;
  final ConnectionInterest selectedInterest;
  final List<ConnectionInterest> interest;
  final bool online;
  final List<Connection> connection;

  ConnectionUser copyWith({
    String id,
    String uid,
    int v,
    DateTime createdAt,
    String status,
    DateTime updatedAt,
    Gender gender,
    ConnectionLocation location,
    int dob,
    String name,
    String about,
    String avatar,
    ConnectionInterest selectedInterest,
    List<ConnectionInterest> interest,
    bool online,
    List<Connection> connection,
  }) =>
      ConnectionUser(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        v: v ?? this.v,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
        gender: gender ?? this.gender,
        location: location ?? this.location,
        dob: dob ?? this.dob,
        name: name ?? this.name,
        about: about ?? this.about,
        avatar: avatar ?? this.avatar,
        selectedInterest: selectedInterest ?? this.selectedInterest,
        interest: interest ?? this.interest,
        online: online ?? this.online,
        connection: connection ?? this.connection,
      );

  factory ConnectionUser.fromJson(String str) =>
      ConnectionUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConnectionUser.fromMap(Map<String, dynamic> json) => ConnectionUser(
        id: json["_id"] == null ? null : json["_id"],
        uid: json["uid"] == null ? null : json["uid"],
        v: json["__v"] == null ? null : json["__v"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        status: json["status"] == null ? null : json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        gender: json["gender"] == null
            ? null
            : json["gender"] == Gender.male.name
                ? Gender.male
                : Gender.female,
        location: json["location"] == null
            ? null
            : ConnectionLocation.fromMap(json["location"]),
        dob: json["dob"] == null ? null : json["dob"],
        name: json["name"] == null ? null : json["name"],
        about: json["about"] == null ? null : json["about"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        selectedInterest: json["selected_interest"] == null
            ? null
            : ConnectionInterest.fromMap(json["selected_interest"]),
        interest: json["interest"] == null
            ? null
            : List<ConnectionInterest>.from(
                json["interest"].map((x) => ConnectionInterest.fromMap(x))),
        online: json["online"] == null ? null : json["online"],
        connection: json["connection"] == null
            ? null
            : List<Connection>.from(
                json["connection"].map((x) => Connection.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "uid": uid == null ? null : uid,
        "__v": v == null ? null : v,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "status": status == null ? null : status,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "gender": gender == null ? null : gender.name,
        "location": location == null ? null : location.toMap(),
        "dob": dob == null ? null : dob,
        "name": name == null ? null : name,
        "about": about == null ? null : about,
        "avatar": avatar == null ? null : avatar,
        "selected_interest":
            selectedInterest == null ? null : selectedInterest.toMap(),
        "interest": interest == null
            ? null
            : List<dynamic>.from(interest.map((x) => x.toMap())),
        "online": online == null ? null : online,
        "connection": connection == null
            ? null
            : List<dynamic>.from(connection.map((x) => x.toMap())),
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

class ConnectionInterest {
  ConnectionInterest({
    this.id,
    this.interest,
    this.category,
    this.skill,
    this.gender,
    this.subCategory,
  });

  final String id;
  final String interest;
  final String category;
  final String skill;
  final Gender gender;
  final String subCategory;

  ConnectionInterest copyWith({
    String id,
    String interest,
    String category,
    String skill,
    Gender gender,
    String subCategory,
  }) =>
      ConnectionInterest(
        id: id ?? this.id,
        interest: interest ?? this.interest,
        category: category ?? this.category,
        skill: skill ?? this.skill,
        gender: gender ?? this.gender,
        subCategory: subCategory ?? this.subCategory,
      );

  factory ConnectionInterest.fromJson(String str) =>
      ConnectionInterest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConnectionInterest.fromMap(Map<String, dynamic> json) =>
      ConnectionInterest(
        id: json["_id"] == null ? null : json["_id"],
        interest: json["interest"] == null ? null : json["interest"],
        category: json["category"] == null ? null : json["category"],
        skill: json["skill"] == null ? null : json["skill"],
        gender: json["gender"] == null
            ? null
            : json["gender"] == Gender.male.name
                ? Gender.male
                : Gender.female,
        subCategory: json["subCategory"] == null ? null : json["subCategory"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id == null ? null : id,
        "interest": interest == null ? null : interest,
        "category": category == null ? null : category,
        "skill": skill == null ? null : skill,
        "gender": gender == null ? null : gender.name,
        "subCategory": subCategory == null ? null : subCategory,
      };
}

class ConnectionLocation {
  ConnectionLocation({
    this.type,
    this.coordinates,
  });

  final String type;
  final List<double> coordinates;

  ConnectionLocation copyWith({
    String type,
    List<double> coordinates,
  }) =>
      ConnectionLocation(
        type: type ?? this.type,
        coordinates: coordinates ?? this.coordinates,
      );

  factory ConnectionLocation.fromJson(String str) =>
      ConnectionLocation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ConnectionLocation.fromMap(Map<String, dynamic> json) =>
      ConnectionLocation(
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
