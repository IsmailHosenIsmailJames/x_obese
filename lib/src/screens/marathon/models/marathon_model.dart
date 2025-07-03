import "dart:convert";

class MarathonModel {
  String? id;
  String? title;
  String? description;
  String? about;
  int? distanceKm;
  String? location;
  DateTime? startDate;
  DateTime? endDate;
  String? imagePath;
  String? type;
  dynamic createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? joined;

  MarathonModel({
    this.id,
    this.title,
    this.description,
    this.about,
    this.distanceKm,
    this.location,
    this.startDate,
    this.endDate,
    this.imagePath,
    this.type,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.joined,
  });

  MarathonModel copyWith({
    String? id,
    String? title,
    String? description,
    String? about,
    int? distanceKm,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    String? imagePath,
    String? type,
    dynamic createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? joined,
  }) => MarathonModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    about: about ?? this.about,
    distanceKm: distanceKm ?? this.distanceKm,
    location: location ?? this.location,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    imagePath: imagePath ?? this.imagePath,
    type: type ?? this.type,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    joined: joined ?? this.joined,
  );

  factory MarathonModel.fromJson(String str) =>
      MarathonModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MarathonModel.fromMap(Map<String, dynamic> json) => MarathonModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    about: json["about"],
    distanceKm: json["distanceKm"],
    location: json["location"],
    startDate:
        json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    imagePath: json["imagePath"],
    type: json["type"],
    createdBy: json["createdBy"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    joined: json["joined"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "about": about,
    "distanceKm": distanceKm,
    "location": location,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "imagePath": imagePath,
    "type": type,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "joined": joined,
  };
}
