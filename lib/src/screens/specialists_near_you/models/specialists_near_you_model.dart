import "dart:convert";

class SpecialistsNearYouModel {
  String? name;
  String? category;
  String? image;
  String? distance;
  String? address;

  SpecialistsNearYouModel({
    this.name,
    this.category,
    this.image,
    this.distance,
    this.address,
  });

  SpecialistsNearYouModel copyWith({
    String? name,
    String? category,
    String? image,
    String? distance,
    String? address,
  }) => SpecialistsNearYouModel(
    name: name ?? this.name,
    category: category ?? this.category,
    image: image ?? this.image,
    distance: distance ?? this.distance,
    address: address ?? this.address,
  );

  factory SpecialistsNearYouModel.fromJson(String str) =>
      SpecialistsNearYouModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SpecialistsNearYouModel.fromMap(Map<String, dynamic> json) =>
      SpecialistsNearYouModel(
        name: json["name"],
        category: json["category"],
        image: json["image"],
        distance: json["distance"],
        address: json["address"],
      );

  Map<String, dynamic> toMap() => {
    "name": name,
    "category": category,
    "image": image,
    "distance": distance,
    "address": address,
  };
}
