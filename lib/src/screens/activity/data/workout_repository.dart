import "package:shared_preferences/shared_preferences.dart";
import "../models/position_nodes.dart";
import "../models/activity_types.dart";

class WorkoutRepository {
  static const String _keyActivityNodes = "activityNodesList";
  static const String _keyWorkoutType = "workout_type";
  static const String _keyIsPaused = "isPaused";

  Future<void> savePositionNodes(List<PositionNodes> nodes) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonData = nodes.map((node) => node.toJson()).toList();
    await prefs.setStringList(_keyActivityNodes, jsonData);
  }

  Future<List<PositionNodes>> getPositionNodes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final List<String>? jsonData = prefs.getStringList(_keyActivityNodes);
    if (jsonData == null) return [];
    return jsonData.map((data) => PositionNodes.fromJson(data)).toList();
  }

  Future<void> saveWorkoutType(ActivityType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWorkoutType, type.name);
  }

  Future<ActivityType?> getWorkoutType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final String? typeName = prefs.getString(_keyWorkoutType);
    if (typeName == null) return null;
    return ActivityType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => ActivityType.walking,
    );
  }

  Future<void> saveIsPaused(bool isPaused) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsPaused, isPaused);
  }

  Future<bool> getIsPaused() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    return prefs.getBool(_keyIsPaused) ?? false;
  }

  Future<void> clearWorkoutData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyActivityNodes);
    await prefs.remove(_keyWorkoutType);
    await prefs.remove(_keyIsPaused);
  }
}
