import 'dart:convert';

class MarathonUserModel {
  String? id;
  String? userId;
  String? marathonId;
  String? distanceKm;
  int? durationMs;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  MarathonUserModel({
    this.id,
    this.userId,
    this.marathonId,
    this.distanceKm,
    this.durationMs,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  MarathonUserModel copyWith({
    String? id,
    String? userId,
    String? marathonId,
    String? distanceKm,
    int? durationMs,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) => MarathonUserModel(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    marathonId: marathonId ?? this.marathonId,
    distanceKm: distanceKm ?? this.distanceKm,
    durationMs: durationMs ?? this.durationMs,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    user: user ?? this.user,
  );

  factory MarathonUserModel.fromJson(String str) =>
      MarathonUserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MarathonUserModel.fromMap(
    Map<String, dynamic> json,
  ) => MarathonUserModel(
    id: json['id'],
    userId: json['userId'],
    marathonId: json['marathonId'],
    distanceKm: json['distanceKm'],
    durationMs: json['durationMs'],
    createdAt:
        json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt:
        json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    user: json['user'] == null ? null : User.fromMap(json['user']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'marathonId': marathonId,
    'distanceKm': distanceKm,
    'durationMs': durationMs,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'user': user?.toMap(),
  };
}

class User {
  String? fullName;
  String? imagePath;

  User({this.fullName, this.imagePath});

  User copyWith({String? fullName, String? imagePath}) => User(
    fullName: fullName ?? this.fullName,
    imagePath: imagePath ?? this.imagePath,
  );

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) =>
      User(fullName: json['fullName'], imagePath: json['imagePath']);

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'imagePath': imagePath,
  };
}
