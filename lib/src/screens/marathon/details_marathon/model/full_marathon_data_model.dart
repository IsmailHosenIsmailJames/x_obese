import "dart:convert";

class FullMarathonDataModel {
  bool? success;
  String? message;
  Data? data;
  int? totalParticiants;
  List<Particiant>? particiants;

  FullMarathonDataModel({
    this.success,
    this.message,
    this.data,
    this.totalParticiants,
    this.particiants,
  });

  FullMarathonDataModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? totalParticiants,
    List<Particiant>? particiants,
  }) => FullMarathonDataModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
    totalParticiants: totalParticiants ?? this.totalParticiants,
    particiants: particiants ?? this.particiants,
  );

  factory FullMarathonDataModel.fromJson(String str) =>
      FullMarathonDataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FullMarathonDataModel.fromMap(Map<String, dynamic> json) =>
      FullMarathonDataModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
        totalParticiants: json["totalParticiants"],
        particiants:
            json["particiants"] == null
                ? []
                : List<Particiant>.from(
                  json["particiants"]!.map((x) => Particiant.fromMap(x)),
                ),
      );

  Map<String, dynamic> toMap() => {
    "success": success,
    "message": message,
    "data": data?.toMap(),
    "totalParticiants": totalParticiants,
    "particiants":
        particiants == null
            ? []
            : List<dynamic>.from(particiants!.map((x) => x.toMap())),
  };
}

class Data {
  String? id;
  String? title;
  String? description;
  String? about;
  int? distanceKm;
  dynamic location;
  DateTime? startDate;
  DateTime? endDate;
  String? imagePath;
  String? type;
  bool? joined;
  String? marathonUserId;
  dynamic createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? rewards;

  Data({
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
    this.joined,
    this.marathonUserId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.rewards,
  });

  Data copyWith({
    String? id,
    String? title,
    String? description,
    String? about,
    int? distanceKm,
    dynamic location,
    DateTime? startDate,
    DateTime? endDate,
    String? imagePath,
    String? type,
    bool? joined,
    String? marathonUserId,
    dynamic createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<dynamic>? rewards,
  }) => Data(
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
    joined: joined ?? this.joined,
    marathonUserId: marathonUserId ?? this.marathonUserId,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    rewards: rewards ?? this.rewards,
  );

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
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
    joined: json["joined"],
    marathonUserId: json["marathonUserId"],
    createdBy: json["createdBy"],
    createdAt:
        json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt:
        json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    rewards:
        json["Rewards"] == null
            ? []
            : List<dynamic>.from(json["Rewards"]!.map((x) => x)),
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
    "joined": joined,
    "marathonUserId": marathonUserId,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "Rewards":
        rewards == null ? [] : List<dynamic>.from(rewards!.map((x) => x)),
  };
}

class Particiant {
  String? id;
  String? fullName;
  String? image;
  String? imagePath;

  Particiant({this.id, this.fullName, this.image, this.imagePath});

  Particiant copyWith({
    String? id,
    String? fullName,
    String? image,
    String? imagePath,
  }) => Particiant(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    image: image ?? this.image,
    imagePath: imagePath ?? this.imagePath,
  );

  factory Particiant.fromJson(String str) =>
      Particiant.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Particiant.fromMap(Map<String, dynamic> json) => Particiant(
    id: json["id"],
    fullName: json["fullName"],
    image: json["image"],
    imagePath: json["imagePath"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "fullName": fullName,
    "image": image,
    "imagePath": imagePath,
  };
}
