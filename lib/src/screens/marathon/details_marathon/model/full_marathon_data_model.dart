import 'package:json_annotation/json_annotation.dart';

part 'full_marathon_data_model.g.dart';

@JsonSerializable()
class FullMarathonDataModel {
  final bool? success;
  final String? message;
  final Data? data;
  final int? totalParticiants;
  final List<Particiant>? particiants;

  FullMarathonDataModel({
    this.success,
    this.message,
    this.data,
    this.totalParticiants,
    this.particiants,
  });

  factory FullMarathonDataModel.fromJson(Map<String, dynamic> json) =>
      _$FullMarathonDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$FullMarathonDataModelToJson(this);

  FullMarathonDataModel copyWith({
    bool? success,
    String? message,
    Data? data,
    int? totalParticiants,
    List<Particiant>? particiants,
  }) =>
      FullMarathonDataModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
        totalParticiants: totalParticiants ?? this.totalParticiants,
        particiants: particiants ?? this.particiants,
      );

  // Manual fromMap to maintain backward compatibility if needed, 
  // but fromJson is the standard for json_serializable.
  factory FullMarathonDataModel.fromMap(Map<String, dynamic> map) =>
      FullMarathonDataModel.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}

@JsonSerializable()
class Data {
  final String? id;
  final String? title;
  final String? description;
  final String? about;
  final int? distanceKm;
  final dynamic location;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? imagePath;
  final String? type;
  bool? joined;
  final String? marathonUserId;
  final dynamic createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  @JsonKey(name: 'Rewards')
  final List<dynamic>? rewards;

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

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

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
  }) =>
      Data(
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

  factory Data.fromMap(Map<String, dynamic> map) => Data.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}

@JsonSerializable()
class Particiant {
  final String? id;
  final String? fullName;
  final String? image;
  final String? imagePath;

  Particiant({this.id, this.fullName, this.image, this.imagePath});

  factory Particiant.fromJson(Map<String, dynamic> json) =>
      _$ParticiantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticiantToJson(this);

  Particiant copyWith({
    String? id,
    String? fullName,
    String? image,
    String? imagePath,
  }) =>
      Particiant(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        image: image ?? this.image,
        imagePath: imagePath ?? this.imagePath,
      );

  factory Particiant.fromMap(Map<String, dynamic> map) => Particiant.fromJson(map);

  Map<String, dynamic> toMap() => toJson();
}
