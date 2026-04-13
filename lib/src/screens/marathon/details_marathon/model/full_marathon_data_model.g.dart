// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'full_marathon_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullMarathonDataModel _$FullMarathonDataModelFromJson(
  Map<String, dynamic> json,
) => FullMarathonDataModel(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
  totalParticiants: (json['totalParticiants'] as num?)?.toInt(),
  particiants:
      (json['particiants'] as List<dynamic>?)
          ?.map((e) => Particiant.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$FullMarathonDataModelToJson(
  FullMarathonDataModel instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'totalParticiants': instance.totalParticiants,
  'particiants': instance.particiants,
};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  id: json['id'] as String?,
  title: json['title'] as String?,
  description: json['description'] as String?,
  about: json['about'] as String?,
  distanceKm: (json['distanceKm'] as num?)?.toInt(),
  location: json['location'],
  startDate:
      json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
  endDate:
      json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
  imagePath: json['imagePath'] as String?,
  type: json['type'] as String?,
  joined: json['joined'] as bool?,
  marathonUserId: json['marathonUserId'] as String?,
  createdBy: json['createdBy'],
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  rewards: json['Rewards'] as List<dynamic>?,
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'about': instance.about,
  'distanceKm': instance.distanceKm,
  'location': instance.location,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'imagePath': instance.imagePath,
  'type': instance.type,
  'joined': instance.joined,
  'marathonUserId': instance.marathonUserId,
  'createdBy': instance.createdBy,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'Rewards': instance.rewards,
};

Particiant _$ParticiantFromJson(Map<String, dynamic> json) => Particiant(
  id: json['id'] as String?,
  fullName: json['fullName'] as String?,
  image: json['image'] as String?,
  imagePath: json['imagePath'] as String?,
);

Map<String, dynamic> _$ParticiantToJson(Particiant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'image': instance.image,
      'imagePath': instance.imagePath,
    };
