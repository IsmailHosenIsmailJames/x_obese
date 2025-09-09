import "dart:convert";

class UserInfoModel {
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
  bool isGuest;

  UserInfoModel({
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
    this.isGuest = false,
  });

  UserInfoModel copyWith({
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
    bool? isGuest,
  }) => UserInfoModel(
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
    isGuest: isGuest ?? this.isGuest,
  );

  factory UserInfoModel.fromJson(String str) =>
      UserInfoModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserInfoModel.fromMap(Map<String, dynamic> json) {
    return UserInfoModel(
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
      isGuest: json["isGuest"] ?? false,
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
    "isGuest": isGuest,
  };
}
