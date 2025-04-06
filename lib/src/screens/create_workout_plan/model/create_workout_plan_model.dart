import 'dart:convert';

class CreateWorkoutPlanModel {
  String? weightGoal;
  String? goalType;
  bool? activateReminder;
  String? reminderTime;
  String? workoutTime;
  String? workoutDays;
  DateTime? startDate;
  DateTime? endDate;

  CreateWorkoutPlanModel({
    this.weightGoal,
    this.goalType,
    this.activateReminder,
    this.reminderTime,
    this.workoutTime,
    this.workoutDays,
    this.startDate,
    this.endDate,
  });

  CreateWorkoutPlanModel copyWith({
    String? weightGoal,
    String? goalType,
    bool? activateReminder,
    String? reminderTime,
    String? workoutTime,
    String? workoutDays,
    DateTime? startDate,
    DateTime? endDate,
  }) => CreateWorkoutPlanModel(
    weightGoal: weightGoal ?? this.weightGoal,
    goalType: goalType ?? this.goalType,
    activateReminder: activateReminder ?? this.activateReminder,
    reminderTime: reminderTime ?? this.reminderTime,
    workoutTime: workoutTime ?? this.workoutTime,
    workoutDays: workoutDays ?? this.workoutDays,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
  );

  factory CreateWorkoutPlanModel.fromJson(String str) =>
      CreateWorkoutPlanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreateWorkoutPlanModel.fromMap(
    Map<String, dynamic> json,
  ) => CreateWorkoutPlanModel(
    weightGoal: json['weightGoal'],
    goalType: json['goalType'],
    activateReminder: json['activateReminder'],
    reminderTime: json['reminderTime'],
    workoutTime: json['workoutTime'],
    workoutDays: json['workoutDays'],
    startDate:
        json['startDate'] == null ? null : DateTime.parse(json['startDate']),
    endDate: json['endDate'] == null ? null : DateTime.parse(json['endDate']),
  );

  Map<String, dynamic> toMap() => {
    'weightGoal': weightGoal,
    'goalType': goalType,
    'activateReminder': activateReminder,
    'reminderTime': reminderTime,
    'workoutTime': workoutTime,
    'workoutDays': workoutDays,
    'startDate':
        startDate != null
            ? "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}"
            : null,
    'endDate':
        endDate != null
            ? "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}"
            : null,
  };
}
