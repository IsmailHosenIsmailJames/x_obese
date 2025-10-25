import "package:geolocator/geolocator.dart";

import "dart:convert";

class PositionNodes {
  final Position position;
  final double maxPossibleDistance;
  final double maxStepDistanceCovered;
  final double gpsDistance;
  final double selectedDistance;
  final ActivityStatus status;
  final int durationMS;
  final int steps;
  PositionNodes({
    required this.position,
    required this.maxPossibleDistance,
    required this.maxStepDistanceCovered,
    required this.gpsDistance,
    required this.selectedDistance,
    required this.status,
    required this.durationMS,
    required this.steps,
  });

  Map<String, dynamic> toMap() {
    return {
      "position": position.toJson(),
      "maxPossibleDistance": maxPossibleDistance,
      "maxStepDistanceCovered": maxStepDistanceCovered,
      "gpsDistance": gpsDistance,
      "selectedDistance": selectedDistance,
      "status": status.name,
      "durationMS": durationMS,
      "steps": steps,
    };
  }

  factory PositionNodes.fromMap(Map<String, dynamic> map) {
    return PositionNodes(
      position: Position.fromMap(
        Map<String, dynamic>.from(map["position"] as Map),
      ),
      maxPossibleDistance: (map["maxPossibleDistance"] as num).toDouble(),
      maxStepDistanceCovered: (map["maxStepDistanceCovered"] as num).toDouble(),
      gpsDistance: (map["gpsDistance"] as num).toDouble(),
      selectedDistance: (map["selectedDistance"] as num).toDouble(),
      status: ActivityStatus.values.firstWhere(
        (element) => element.name == map["status"],
      ),
      durationMS: (map["durationMS"] as num).toInt(),
      steps: (map["steps"] as num).toInt(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory PositionNodes.fromJson(String source) =>
      PositionNodes.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

enum ActivityStatus { walking, stopped, unknown }
