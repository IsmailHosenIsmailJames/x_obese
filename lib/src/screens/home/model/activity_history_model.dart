class ActivityHistoryModel {
  final ActivitySummary summary;
  final ActivityCharts charts;
  final String view;

  ActivityHistoryModel({
    required this.summary,
    required this.charts,
    required this.view,
  });

  factory ActivityHistoryModel.fromJson(Map<String, dynamic> json) {
    return ActivityHistoryModel(
      summary: ActivitySummary.fromJson(json['summary'] ?? {}),
      charts: ActivityCharts.fromJson(json['charts'] ?? {}),
      view: json['view'] ?? 'daily',
    );
  }
}

class ActivitySummary {
  final int steps;
  final double calories;
  final double heartPts;
  final int workoutTimeMs;
  final double distanceKm;

  ActivitySummary({
    required this.steps,
    required this.calories,
    required this.heartPts,
    required this.workoutTimeMs,
    required this.distanceKm,
  });

  factory ActivitySummary.fromJson(Map<String, dynamic> json) {
    return ActivitySummary(
      steps: (json['steps'] ?? 0).toInt(),
      calories: (json['calories'] ?? 0.0).toDouble(),
      heartPts: (json['heartPts'] ?? 0.0).toDouble(),
      workoutTimeMs: (json['workoutTimeMs'] ?? 0).toInt(),
      distanceKm: (json['distanceKm'] ?? 0.0).toDouble(),
    );
  }
}

class ActivityCharts {
  final List<ChartPoint> steps;
  final List<ChartPoint> calories;
  final List<ChartPoint> workoutTime;

  ActivityCharts({
    required this.steps,
    required this.calories,
    required this.workoutTime,
  });

  factory ActivityCharts.fromJson(Map<String, dynamic> json) {
    return ActivityCharts(
      steps: (json['steps'] as List? ?? []).map((e) => ChartPoint.fromJson(e)).toList(),
      calories: (json['calories'] as List? ?? []).map((e) => ChartPoint.fromJson(e)).toList(),
      workoutTime: (json['workoutTime'] as List? ?? []).map((e) => ChartPoint.fromJson(e)).toList(),
    );
  }
}

class ChartPoint {
  final String label;
  final double value;

  ChartPoint({
    required this.label,
    required this.value,
  });

  factory ChartPoint.fromJson(Map<String, dynamic> json) {
    return ChartPoint(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0.0).toDouble(),
    );
  }
}
