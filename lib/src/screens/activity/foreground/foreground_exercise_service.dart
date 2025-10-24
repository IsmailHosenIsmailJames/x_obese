import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:flutter/foundation.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:geolocator/geolocator.dart" hide ActivityType;
import "package:get/get.dart";
import "package:pedometer/pedometer.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/src/core/common/functions/calculate_distance.dart";

@pragma("vm:entry-point")
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundExerciseTask());
}

class ForegroundExerciseTask extends TaskHandler {
  Stream<PedestrianStatus>? pedestrianStatusStream;
  Stream<StepCount>? stepCountStream;
  Stream<Position>? positionStream;

  StreamSubscription<PedestrianStatus>? pedestrianStatusStreamSubscription;
  StreamSubscription<StepCount>? stepCountStreamSubscription;
  StreamSubscription<Position>? positionStreamSubscription;

  DateTime? startTime;

  Future<void> _handleGeolocationHistory() async {
    startTime = DateTime.now();
    lastPositionTimeStamp = DateTime.now();

    pedestrianStatusStream ??= Pedometer.pedestrianStatusStream;
    stepCountStream ??= Pedometer.stepCountStream;
    positionStream ??= Geolocator.getPositionStream();

    pedestrianStatusStreamSubscription ??= pedestrianStatusStream?.listen((
      event,
    ) {
      onPedestrianStatusReceive(event);
    });

    stepCountStreamSubscription ??= stepCountStream?.listen((event) {
      onStepDataReceive(event);
    });

    positionStreamSubscription ??= positionStream?.listen((event) {
      onPositionDataReceive(event);
    });

    // deprecated
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

    String? activityType =
        sharedPreferences.getString("workout_type") ?? "walking";

    ActivityType activity = ActivityType.values.firstWhere(
      (element) => element.name == activityType,
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

  int activeTimeMS = 0;
  PedestrianStatus? previousPedestrianStatus;
  DateTime? lastUsedPedestrianStatus;
  void onPedestrianStatusReceive(PedestrianStatus status) {
    if (previousPedestrianStatus != null) {
      if ((status.status == "stopped" &&
              previousPedestrianStatus!.status == "walking") ||
          (status.status == "walking" &&
              previousPedestrianStatus!.status == "walking")) {
        activeTimeMS +=
            status.timeStamp
                .difference(previousPedestrianStatus!.timeStamp)
                .abs()
                .inMilliseconds;
        log("onPedestrianStatusReceive -> $activeTimeMS", name: "Steps & GPS");
      }
    } else {
      if (status.status == "walking") {
        activeTimeMS +=
            status.timeStamp.difference(startTime!).abs().inMilliseconds;
      }
    }

    previousPedestrianStatus = status;
    lastUsedPedestrianStatus = DateTime.now();
  }

  StepCount? previousStepData;
  int totalStepCount = 0;
  void onStepDataReceive(StepCount stepCount) {
    if (previousStepData != null) {
      totalStepCount += (stepCount.steps - previousStepData!.steps).abs();
    }
    previousStepData = stepCount;
  }

  Position? lastPosition;
  DateTime? lastPositionTimeStamp;
  Future<void> onPositionDataReceive(Position position) async {
    DateTime now = DateTime.now();
    int totalTimeDifference =
        now.difference(lastPositionTimeStamp!).abs().inMilliseconds;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();

    String? activityTypeString =
        sharedPreferences.getString("workout_type") ?? "walking";

    ActivityType activity = ActivityType.values.firstWhere(
      (element) => element.name == activityTypeString,
    );

    int activeTime = activeTimeMS;
    if (previousPedestrianStatus?.status == "walking") {
      activeTime +=
          lastUsedPedestrianStatus!.difference(now).abs().inMilliseconds;
      lastUsedPedestrianStatus = now;
    }
    log("Active time MS: $activeTime", name: "Steps & GPS");

    double topSpeedMh = 0;
    switch (activity) {
      case ActivityType.walking:
        topSpeedMh = 6400;
      case ActivityType.running:
        topSpeedMh = 10000;
      case ActivityType.cycling:
        topSpeedMh = 20000;
    }
    double topPossibleDistance = ((activeTime / 1000) / (60 * 60)) * topSpeedMh;

    // find the steps difference and top covered distance

    double topStepDistanceCovered = 0;
    switch (activity) {
      case ActivityType.walking:
        topStepDistanceCovered = totalStepCount * 0.8;
      case ActivityType.running:
        topStepDistanceCovered = totalStepCount * 1.5;
      case ActivityType.cycling:
        topStepDistanceCovered = totalStepCount * 1.5;
    }

    // calculate distance provided by GPS
    double gpsDistance = 0;
    if (lastPosition == null) {
      gpsDistance = position.speed * ((totalTimeDifference / 1000) / (60 * 60));
      if (gpsDistance == 0) {
        gpsDistance = topStepDistanceCovered;
      }
    } else {
      gpsDistance = Geolocator.distanceBetween(
        lastPosition!.latitude,
        lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
    }

    // top possible distance by active time
    topPossibleDistance;
    // top possible distance by steps
    topStepDistanceCovered;
    // GPS distance covered
    gpsDistance;

    // clear & replace previous data
    activeTimeMS = 0;
    totalStepCount = 0;

    lastPosition = position;
    lastPositionTimeStamp = DateTime.now();

    Fluttertoast.showToast(
      msg:
          "${previousPedestrianStatus?.status.substring(0, 1) ?? "E"}:${topPossibleDistance.toStringAsPrecision(1)}:${topStepDistanceCovered.toStringAsPrecision(1)}:${gpsDistance.toStringAsPrecision(1)}",
    );
    log(
      "${previousPedestrianStatus?.status.substring(0, 1) ?? "E"}:${topPossibleDistance.toStringAsPrecision(1)}:${topStepDistanceCovered.toStringAsPrecision(1)}:${gpsDistance.toStringAsPrecision(1)}",
      name: "Steps & GPS",
    );
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
