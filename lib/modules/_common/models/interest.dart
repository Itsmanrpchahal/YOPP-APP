// To parse this JSON data, do
//
//     final interestOption = interestOptionFromJson(jsonString);

import 'dart:convert';

List<InterestOption> interestOptionsFromJson(String str) =>
    List<InterestOption>.from(
        json.decode(str).map((x) => InterestOption.fromJson(x)));

String interestOptionsToJson(List<InterestOption> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InterestOption {
  InterestOption({
    this.category = const [],
    this.id,
    this.name,
    this.image,
  });

  final List<CategoryOption> category;
  final String id;
  final String name;
  final String image;

  InterestOption copyWith({
    List<CategoryOption> category,
    String id,
    String name,
    String image,
  }) =>
      InterestOption(
          category: category ?? this.category,
          id: id ?? this.id,
          name: name ?? this.name,
          image: image ?? this.image);

  factory InterestOption.fromRawJson(String str) =>
      InterestOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InterestOption.fromJson(Map<String, dynamic> json) => InterestOption(
        category: json["category"] == null
            ? null
            : List<CategoryOption>.from(
                json["category"].map((x) => CategoryOption.fromJson(x))),
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image_png"] == null ? null : json["image_png"],
      );

  Map<String, dynamic> toJson() => {
        "category": category == null
            ? null
            : List<dynamic>.from(category.map((x) => x.toJson())),
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
      };
}

class CategoryOption {
  CategoryOption({
    this.subCategory = const [],
    this.id,
    this.name,
    this.image,
  });

  final List<SubCategoryOption> subCategory;
  final String id;
  final String name;
  final String image;

  CategoryOption copyWith({
    List<SubCategoryOption> subCategory,
    String id,
    String name,
    String image,
  }) =>
      CategoryOption(
        subCategory: subCategory ?? this.subCategory,
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
      );

  factory CategoryOption.fromRawJson(String str) =>
      CategoryOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryOption.fromJson(Map<String, dynamic> json) => CategoryOption(
        subCategory: json["subCategory"] == null
            ? null
            : List<SubCategoryOption>.from(
                json["subCategory"].map((x) => SubCategoryOption.fromJson(x))),
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "subCategory": subCategory == null
            ? null
            : List<dynamic>.from(subCategory.map((x) => x.toJson())),
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
      };
}

class SubCategoryOption {
  SubCategoryOption({
    this.id,
    this.name,
    this.image,
  });

  final String id;
  final String name;
  final String image;

  SubCategoryOption copyWith({
    String id,
    String name,
    String image,
  }) =>
      SubCategoryOption(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
      );

  factory SubCategoryOption.fromRawJson(String str) =>
      SubCategoryOption.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubCategoryOption.fromJson(Map<String, dynamic> json) =>
      SubCategoryOption(
        id: json["_id"] == null ? null : json["_id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
      };
}
