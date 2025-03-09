import 'dart:convert';

class AllInfoModel {
  String? name;
  String? email;
  String? gender;
  DateTime? dateOfBirth;
  double? height;
  double? weight;
  String? address;

  AllInfoModel({
    this.name,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.address,
  });

  AllInfoModel copyWith({
    String? name,
    String? email,
    String? gender,
    DateTime? dateOfBirth,
    double? height,
    double? weight,
    String? address,
  }) => AllInfoModel(
    name: name ?? this.name,
    email: email ?? this.email,
    gender: gender ?? this.gender,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    address: address ?? this.address,
  );

  factory AllInfoModel.fromJson(String str) =>
      AllInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AllInfoModel.fromMap(Map<String, dynamic> json) => AllInfoModel(
    name: json['name'],
    email: json['email'],
    gender: json['gender'],
    dateOfBirth:
        json['date_of_birth'] == null
            ? null
            : DateTime.parse(json['date_of_birth']),
    height: json['height']?.toDouble(),
    weight: json['weight']?.toDouble(),
    address: json['address'],
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'gender': gender,
    'date_of_birth':
        "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
    'height': height,
    'weight': weight,
    'address': address,
  };
}
