import 'dart:convert';

class WorkStatusModel {
  int? heartPts;
  int? calories;
  double? distanceKm;
  int? steps;
  int? durationMs;

  WorkStatusModel({
    this.heartPts,
    this.calories,
    this.distanceKm,
    this.steps,
    this.durationMs,
  });

  WorkStatusModel copyWith({
    int? heartPts,
    int? calories,
    double? distanceKm,
    int? steps,
    int? durationMs,
  }) => WorkStatusModel(
    heartPts: heartPts ?? this.heartPts,
    calories: calories ?? this.calories,
    distanceKm: distanceKm ?? this.distanceKm,
    steps: steps ?? this.steps,
    durationMs: durationMs ?? this.durationMs,
  );

  factory WorkStatusModel.fromJson(String str) =>
      WorkStatusModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WorkStatusModel.fromMap(Map<String, dynamic> json) => WorkStatusModel(
    heartPts: json["heartPts"],
    calories: json["calories"],
    distanceKm: json["distanceKm"]?.toDouble(),
    steps: json["steps"],
    durationMs: json["durationMs"],
  );

  Map<String, dynamic> toMap() => {
    "heartPts": heartPts,
    "calories": calories,
    "distanceKm": distanceKm,
    "steps": steps,
    "durationMs": durationMs,
  };
}
