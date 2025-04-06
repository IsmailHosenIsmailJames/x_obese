import 'dart:convert';

class GetBlogModel {
  String? id;
  dynamic createdBy;
  String? title;
  int? readTime;
  String? description;
  String? details;
  String? imagePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetBlogModel({
    this.id,
    this.createdBy,
    this.title,
    this.readTime,
    this.description,
    this.details,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
  });

  GetBlogModel copyWith({
    String? id,
    dynamic createdBy,
    String? title,
    int? readTime,
    String? description,
    String? details,
    String? imagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GetBlogModel(
    id: id ?? this.id,
    createdBy: createdBy ?? this.createdBy,
    title: title ?? this.title,
    readTime: readTime ?? this.readTime,
    description: description ?? this.description,
    details: details ?? this.details,
    imagePath: imagePath ?? this.imagePath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory GetBlogModel.fromJson(String str) =>
      GetBlogModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetBlogModel.fromMap(Map<String, dynamic> json) => GetBlogModel(
    id: json["id"],
    createdBy: json["createdBy"],
    title: json["title"],
    readTime: json["readTime"],
    description: json["description"],
    details: json["details"],
    imagePath: json["imagePath"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "createdBy": createdBy,
    "title": title,
    "readTime": readTime,
    "description": description,
    "details": details,
    "imagePath": imagePath,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
