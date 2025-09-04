import "dart:convert";

class AllInfoModel {
  String? id;
  String? mobile;
  String? fullName;
  String? email;
  String? image;
  String? imagePath;
  String? gender;
  String? address;
  DateTime? birth;
  int? heightFt;
  int? heightIn;
  int? weight;

  AllInfoModel({
    this.id,
    this.mobile,
    this.fullName,
    this.email,
    this.image,
    this.imagePath,
    this.gender,
    this.address,
    this.birth,
    this.heightFt,
    this.heightIn,
    this.weight,
  });

  AllInfoModel copyWith({
    String? id,
    String? mobile,
    String? fullName,
    String? email,
    String? image,
    String? imagePath,
    String? gender,
    String? address,
    DateTime? birth,
    int? heightFt,
    int? heightIn,
    int? weight,
  }) => AllInfoModel(
    id: id ?? this.id,
    mobile: mobile ?? this.mobile,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    image: image ?? this.image,
    imagePath: imagePath ?? this.imagePath,
    gender: gender ?? this.gender,
    address: address ?? this.address,
    birth: birth ?? this.birth,
    heightFt: heightFt ?? this.heightFt,
    heightIn: heightIn ?? this.heightIn,
    weight: weight ?? this.weight,
  );

  factory AllInfoModel.fromJson(String str) =>
      AllInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AllInfoModel.fromMap(Map<String, dynamic> json) {
    return AllInfoModel(
      id: json["id"],
      mobile: json["mobile"],
      fullName: json["fullName"],
      email: json["email"],
      image: json["image"],
      imagePath: json["imagePath"],
      gender: json["gender"],
      address: json["address"],
      birth: json["birth"] != null ? DateTime.parse(json["birth"]) : null,
      heightFt: json["heightFt"],
      heightIn: json["heightIn"],
      weight: json["weight"],
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "mobile": mobile,
    "fullName": fullName,
    "email": email,
    "image": image,
    "imagePath": image,
    "gender": gender,
    "address": address,
    "birth": birth?.toIso8601String(),
    "heightFt": heightFt,
    "heightIn": heightIn,
    "weight": weight,
  };
}
