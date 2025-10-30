import "dart:async";
import "dart:developer";

import "package:dartx/dartx.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:geolocator/geolocator.dart" hide ActivityType;
import "package:pedometer/pedometer.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/src/core/common/functions/format_sec_to_time.dart";
import "package:x_obese/src/screens/activity/models/position_nodes.dart";

import "../models/activity_types.dart";

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

    bool isPaused = sharedPreferences.getBool("isPaused") ?? false;

    int activeTime = activeTimeMS;
    if (previousPedestrianStatus?.status == "walking") {
      activeTime +=
          lastUsedPedestrianStatus!.difference(now).abs().inMilliseconds;
      lastUsedPedestrianStatus = now;
    }
    log("Active time MS: $activeTime", name: "Steps & GPS");

    double maxSpeedMh = 0;
    switch (activity) {
      case ActivityType.walking:
        maxSpeedMh = 6400;
      case ActivityType.running:
        maxSpeedMh = 10000;
      case ActivityType.cycling:
        maxSpeedMh = 20000;
    }

    double maxPossibleDistance = ((activeTime / 1000) / (60 * 60)) * maxSpeedMh;

    // find the steps difference and max covered distance

    double maxStepDistanceCovered = 0;
    switch (activity) {
      case ActivityType.walking:
        maxStepDistanceCovered = totalStepCount * 0.8;
      case ActivityType.running:
        maxStepDistanceCovered = totalStepCount * 1.5;
      case ActivityType.cycling:
        maxStepDistanceCovered = totalStepCount * 1.5;
    }

    // calculate distance provided by GPS
    double gpsDistance = 0;
    if (lastPosition == null) {
      gpsDistance = position.speed * ((totalTimeDifference / 1000) / (60 * 60));
      if (gpsDistance == 0) {
        gpsDistance = maxStepDistanceCovered;
      }
    } else {
      gpsDistance = Geolocator.distanceBetween(
        lastPosition!.latitude,
        lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
    }

    // max possible distance by active time
    maxPossibleDistance;
    // max possible distance by steps
    maxStepDistanceCovered;
    // GPS distance covered
    gpsDistance;

    double selectedDistance = 0;
    if (maxStepDistanceCovered > maxPossibleDistance) {
      maxPossibleDistance = maxPossibleDistance;
    }

    if (maxPossibleDistance > gpsDistance) {
      selectedDistance = gpsDistance;
    } else {
      selectedDistance = maxPossibleDistance * 0.8;
    }

    int totalSteps = totalStepCount;

    // clear & replace previous data
    activeTimeMS = 0;
    totalStepCount = 0;

    lastPosition = position;
    lastPositionTimeStamp = DateTime.now();

    if (isPaused) return;

    List<PositionNodes> positionNodes =
        (sharedPreferences.getStringList("activityNodesList") ?? [])
            .map((e) => PositionNodes.fromJson(e))
            .toList();

    if (previousPedestrianStatus?.status != "stopped") {
      positionNodes.add(
        PositionNodes(
          position: position,
          maxPossibleDistance: maxPossibleDistance,
          maxStepDistanceCovered: maxStepDistanceCovered,
          gpsDistance: gpsDistance,
          selectedDistance: selectedDistance,
          durationMS: activeTime,
          steps: totalSteps,
          status: ActivityStatus.values.firstWhere(
            (element) =>
                element.name == (previousPedestrianStatus?.status ?? "unknown"),
          ),
        ),
      );
      await sharedPreferences.setStringList(
        "activityNodesList",
        positionNodes.map((e) => e.toJson()).toList(),
      );
    }

    FlutterForegroundTask.sendDataToMain(
      positionNodes.map((e) => e.toJson()).toList(),
    );
    double distance = positionNodes.map((e) => e.selectedDistance).sum();
    int durationInSec =
        (positionNodes.map((e) => e.durationMS).sum() / 1000).toInt();
    double calculatedSpeed =
        positionNodes.isNotEmpty
            ? ((positionNodes.last.selectedDistance / 1000) /
                ((positionNodes.last.durationMS / 1000) / (60 * 60)))
            : 0;

    ActivityStatus lastActivityType =
        positionNodes.isNotEmpty
            ? positionNodes.last.status
            : ActivityStatus.stopped;
    lastActivityType =
        lastActivityType == ActivityStatus.unknown
            ? ActivityStatus.stopped
            : lastActivityType;
    FlutterForegroundTask.updateService(
      notificationText:
          "Distance: ${distance >= 1000 ? (distance / 1000).toStringAsPrecision(2) : distance.toInt()} ${distance >= 1000 ? "KM" : "Meter"}, "
          "Duration: ${formatSeconds(durationInSec)}, "
          "Last Speed: ${calculatedSpeed > 0 ? calculatedSpeed : "..."} KM/H",
    );
    log(
      "${previousPedestrianStatus?.status.substring(0, 1) ?? "E"}:${maxPossibleDistance.toStringAsPrecision(1)}:${maxStepDistanceCovered.toStringAsPrecision(1)}:${gpsDistance.toStringAsPrecision(1)}:S-$selectedDistance",
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
      FlutterForegroundTask.sendDataToMain("dismiss_workout");
      dismissWorkout();
    }
    if (id == "pause_workout") {
      FlutterForegroundTask.sendDataToMain("pause_workout");
      (await SharedPreferences.getInstance()).setBool("isPaused", true);
      FlutterForegroundTask.updateService(
        notificationTitle: "Your Workout is Paused!",
        notificationButtons: [
          const NotificationButton(
            id: "dismiss_workout",
            text: "Dismiss Workout",
            textColor: Colors.red,
          ),
          const NotificationButton(
            id: "resume_workout",
            text: "Resume Workout",
            textColor: Colors.green,
          ),
        ],
      );
    }
    if (id == "resume_workout") {
      FlutterForegroundTask.sendDataToMain("resume_workout");
      (await SharedPreferences.getInstance()).setBool("isPaused", false);
      FlutterForegroundTask.updateService(
        notificationTitle: "Your Workout is Paused!",
        notificationButtons: [
          const NotificationButton(
            id: "dismiss_workout",
            text: "Dismiss Workout",
            textColor: Colors.red,
          ),
          const NotificationButton(
            id: "resume_workout",
            text: "Pause Workout",
            textColor: Colors.red,
          ),
        ],
      );
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
  await sharedPreferences.remove("activityNodesList");
  await sharedPreferences.remove("workout_type");
  await sharedPreferences.remove("isPaused");
  FlutterForegroundTask.stopService();
}
