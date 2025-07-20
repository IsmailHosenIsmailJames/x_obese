import 'dart:convert';

class BannerModel {
  String? id;
  String? title;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imagePath;

  BannerModel({
    this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
  });

  BannerModel copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imagePath,
  }) => BannerModel(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    imagePath: imagePath ?? this.imagePath,
  );

  factory BannerModel.fromJson(String str) =>
      BannerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BannerModel.fromMap(Map<String, dynamic> json) => BannerModel(
    id: json["id"],
    title: json["title"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    imagePath: json["imagePath"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "imagePath": imagePath,
  };
}
