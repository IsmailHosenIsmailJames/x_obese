import 'dart:convert';

class WorkStatusModel {
  String? heartPts;
  String? calories;
  String? distanceKm;
  double? durationMs;
  int? steps;

  WorkStatusModel({
    this.heartPts,
    this.calories,
    this.distanceKm,
    this.durationMs,
    this.steps,
  });

  WorkStatusModel copyWith({
    String? heartPts,
    String? calories,
    String? distanceKm,
    double? durationMs,
    int? steps,
  }) => WorkStatusModel(
    heartPts: heartPts ?? this.heartPts,
    calories: calories ?? this.calories,
    distanceKm: distanceKm ?? this.distanceKm,
    durationMs: durationMs ?? this.durationMs,
    steps: steps ?? this.steps,
  );

  factory WorkStatusModel.fromJson(String str) =>
      WorkStatusModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WorkStatusModel.fromMap(Map<String, dynamic> json) => WorkStatusModel(
    heartPts: json['heartPts'],
    calories: json['calories'],
    distanceKm: json['distanceKm'],
    durationMs: (json['durationMs']).toDouble(),
    steps: json['steps'],
  );

  Map<String, dynamic> toMap() => {
    'heartPts': heartPts,
    'calories': calories,
    'distanceKm': distanceKm,
    'durationMs': durationMs,
    'steps': steps,
  };
}
