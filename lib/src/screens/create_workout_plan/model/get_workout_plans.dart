import 'dart:convert';

class GetWorkoutPlans {
  String? id;
  String? userId;
  String? bmi;
  int? weightGoal;
  String? goalType;
  dynamic workoutTimeMs;
  String? workoutDays;
  bool? activateReminder;
  DateTime? reminderTime;
  int? totalDays;
  int? caloriesGoal;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  GetWorkoutPlans({
    this.id,
    this.userId,
    this.bmi,
    this.weightGoal,
    this.goalType,
    this.workoutTimeMs,
    this.workoutDays,
    this.activateReminder,
    this.reminderTime,
    this.totalDays,
    this.caloriesGoal,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  GetWorkoutPlans copyWith({
    String? id,
    String? userId,
    String? bmi,
    int? weightGoal,
    String? goalType,
    dynamic workoutTimeMs,
    String? workoutDays,
    bool? activateReminder,
    DateTime? reminderTime,
    int? totalDays,
    int? caloriesGoal,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GetWorkoutPlans(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    bmi: bmi ?? this.bmi,
    weightGoal: weightGoal ?? this.weightGoal,
    goalType: goalType ?? this.goalType,
    workoutTimeMs: workoutTimeMs ?? this.workoutTimeMs,
    workoutDays: workoutDays ?? this.workoutDays,
    activateReminder: activateReminder ?? this.activateReminder,
    reminderTime: reminderTime ?? this.reminderTime,
    totalDays: totalDays ?? this.totalDays,
    caloriesGoal: caloriesGoal ?? this.caloriesGoal,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory GetWorkoutPlans.fromJson(String str) =>
      GetWorkoutPlans.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetWorkoutPlans.fromMap(Map<String, dynamic> json) => GetWorkoutPlans(
    id: json['id'],
    userId: json['userId'],
    bmi: json['bmi'],
    weightGoal: json['weightGoal'],
    goalType: json['goalType'],
    workoutTimeMs: json['workoutTimeMs'],
    workoutDays: json['workoutDays'],
    activateReminder: json['activateReminder'],
    reminderTime:
        json['reminderTime'] == null
            ? null
            : DateTime.parse(json['reminderTime']),
    totalDays: json['totalDays'],
    caloriesGoal: json['caloriesGoal'],
    startDate:
        json['startDate'] == null ? null : DateTime.parse(json['startDate']),
    endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
    createdAt:
        json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    updatedAt:
        json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'bmi': bmi,
    'weightGoal': weightGoal,
    'goalType': goalType,
    'workoutTimeMs': workoutTimeMs,
    'workoutDays': workoutDays,
    'activateReminder': activateReminder,
    'reminderTime': reminderTime?.toIso8601String(),
    'totalDays': totalDays,
    'caloriesGoal': caloriesGoal,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };
}
