import 'package:intl/intl.dart';

class WorkoutModel {
  final String id;
  final String userId;
  final double calories;
  final double distanceKm;
  final int durationMs;
  final double heartPts;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutModel({
    required this.id,
    required this.userId,
    required this.calories,
    required this.distanceKm,
    required this.durationMs,
    required this.heartPts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      calories: double.parse((map['calories'] ?? '0').toString()),
      distanceKm: double.parse((map['distanceKm'] ?? '0').toString()),
      durationMs: (map['durationMs'] ?? 0).toInt(),
      heartPts: double.parse((map['heartPts'] ?? '0').toString()),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get formattedDate => DateFormat('MMM dd, yyyy').format(createdAt);
  String get formattedTime => DateFormat('hh:mm a').format(createdAt);
  String get durationMinutes => (durationMs / (60 * 1000)).toStringAsFixed(1);
}

class WorkoutHistoryResponse {
  final List<WorkoutModel> data;
  final int count;
  final int page;
  final int size;

  WorkoutHistoryResponse({
    required this.data,
    required this.count,
    required this.page,
    required this.size,
  });

  factory WorkoutHistoryResponse.fromMap(Map<String, dynamic> map) {
    return WorkoutHistoryResponse(
      data: (map['data'] as List? ?? [])
          .map((x) => WorkoutModel.fromMap(x))
          .toList(),
      count: map['count'] ?? 0,
      page: map['page'] ?? 1,
      size: map['size'] ?? 10,
    );
  }
}
