import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:flutter/foundation.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:geolocator/geolocator.dart" hide ActivityType;
import "package:get/get.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/src/core/common/functions/calculate_distance.dart";

@pragma("vm:entry-point")
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundExerciseTask());
}

class ForegroundExerciseTask extends TaskHandler {
  Future<void> _handleGeolocationHistory() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    bool isPaused = sharedPreferences.getBool("isPaused") ?? false;
    if (isPaused) return;
    Position position = await Geolocator.getCurrentPosition();
    List<String> geolocationHistory =
        sharedPreferences.getStringList("geolocationHistory") ?? [];
    geolocationHistory.add(jsonEncode(position));
    await sharedPreferences.setStringList(
      "geolocationHistory",
      geolocationHistory,
    );

    String? activityType = sharedPreferences.getString("workout_type");
    String sh = activityType ??= "walking";
    ActivityType activity = ActivityType.values.firstWhere(
      (element) => element.name == sh,
    );
    List<Position> positions =
        geolocationHistory.map((e) => Position.fromMap(jsonDecode(e))).toList();
    WorkoutCalculationResult workoutCalculationResult =
        WorkoutCalculator(
          rawPositions: positions,
          activityType: activity,
        ).processData();
    double distanceEveryPaused =
        sharedPreferences.getDouble("distanceEveryPaused") ?? 0.0;

    if (positions.isEmpty) {
      return;
    }
    int durationInSec =
        positions.first.timestamp.difference(DateTime.now()).inSeconds.abs();
    FlutterForegroundTask.updateService(
      notificationTitle: "Workout is running",
      notificationText:
          "Distance: ${(distanceEveryPaused + workoutCalculationResult.totalDistance / 1000).toPrecision(2)} km, Duration: ${durationInSec ~/ 60}:${durationInSec % 60} min, Avg speed: ${((positions.last.speed == 0.0 ? workoutCalculationResult.averageSpeed : positions.last.speed) * 3.6).toPrecision(2)} km/h",
      callback: startCallback,
    );

    log("geolocationHistory: ${geolocationHistory.length}");
    FlutterForegroundTask.sendDataToMain(geolocationHistory);
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _handleGeolocationHistory();
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    _handleGeolocationHistory();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    if (kDebugMode) {
      print("onDestroy");
    }
  }

  @override
  void onReceiveData(Object data) {
    if (kDebugMode) {
      print("onReceiveData: $data");
    }
  }

  @override
  void onNotificationButtonPressed(String id) async {
    if (id == "dismiss_workout") {
      dismissWorkout();
    }
    if (kDebugMode) {
      print("onNotificationButtonPressed: $id");
    }
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/workout");
    if (kDebugMode) {
      print("onNotificationPressed");
    }
  }

  @override
  void onNotificationDismissed() {
    if (kDebugMode) {
      print("onNotificationDismissed");
    }
  }
}

Future dismissWorkout() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.remove("geolocationHistory");
  await sharedPreferences.remove("workout_type");
  await sharedPreferences.remove("isPaused");
  FlutterForegroundTask.stopService();
}
