import "dart:async";
import "dart:developer";

import "package:dartx/dartx.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:geolocator/geolocator.dart" hide ActivityType;
import "package:pedometer/pedometer.dart";
import "package:x_obese/src/core/common/functions/format_sec_to_time.dart";
import "package:x_obese/src/screens/activity/data/workout_repository.dart";
import "package:x_obese/src/screens/activity/models/activity_status.dart";
import "package:x_obese/src/screens/activity/models/position_nodes.dart";

import "../models/activity_types.dart";

@pragma("vm:entry-point")
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundExerciseTask());
}

class ForegroundExerciseTask extends TaskHandler {
  final WorkoutRepository _repository = WorkoutRepository();

  Stream<PedestrianStatus>? pedestrianStatusStream;
  Stream<StepCount>? stepCountStream;
  Stream<Position>? positionStream;

  StreamSubscription<PedestrianStatus>? pedestrianStatusStreamSubscription;
  StreamSubscription<StepCount>? stepCountStreamSubscription;
  StreamSubscription<Position>? positionStreamSubscription;

  DateTime? startTime;

  Future<void> _handleGeolocationHistory() async {
    log("_handleGeolocationHistory starting streams...", name: "ActivityDebug");
    startTime = DateTime.now();
    lastPositionTimeStamp = DateTime.now();

    try {
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
      log("Streams initialized success.", name: "ActivityDebug");
    } catch (e) {
      log("Error initializing streams: $e", name: "ActivityDebug");
    }
  }


  int activeTimeMS = 0;
  PedestrianStatus? previousPedestrianStatus;
  DateTime? lastUsedPedestrianStatus;
  void onPedestrianStatusReceive(PedestrianStatus status) {
    log("onPedestrianStatusReceive: ${status.status}", name: "ActivityDebug");
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
        log("activeTimeMS accumulated: $activeTimeMS", name: "ActivityDebug");
      }
    } else {
      if (status.status == "walking") {
        activeTimeMS +=
            status.timeStamp.difference(startTime!).abs().inMilliseconds;
        log("Initial walking activeTimeMS: $activeTimeMS", name: "ActivityDebug");
      }
    }

    previousPedestrianStatus = status;
    lastUsedPedestrianStatus = DateTime.now();
  }

  StepCount? previousStepData;
  int totalStepCount = 0;
  void onStepDataReceive(StepCount stepCount) {
    log("onStepDataReceive: ${stepCount.steps}", name: "ActivityDebug");
    if (previousStepData != null) {
      totalStepCount += (stepCount.steps - previousStepData!.steps).abs();
    }
    previousStepData = stepCount;
  }

  Position? lastPosition;
  DateTime? lastPositionTimeStamp;
  Future<void> onPositionDataReceive(Position position) async {
    log("onPositionDataReceive: lat=${position.latitude}, lon=${position.longitude}, status=${previousPedestrianStatus?.status}", name: "ActivityDebug");
    DateTime now = DateTime.now();
    int totalTimeDifference =
        now.difference(lastPositionTimeStamp!).abs().inMilliseconds;

    ActivityType activity =
        await _repository.getWorkoutType() ?? ActivityType.walking;
    bool isPaused = await _repository.getIsPaused();

    int activeTime = activeTimeMS;
    if (previousPedestrianStatus?.status == "walking") {
      activeTime +=
          lastUsedPedestrianStatus!.difference(now).abs().inMilliseconds;
      lastUsedPedestrianStatus = now;
    }
    log("Calculated activeTime this tick: $activeTime, isPaused: $isPaused", name: "ActivityDebug");


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

    double maxStepDistanceCovered = 0;
    switch (activity) {
      case ActivityType.walking:
        maxStepDistanceCovered = totalStepCount * 0.8;
      case ActivityType.running:
        maxStepDistanceCovered = totalStepCount * 1.5;
      case ActivityType.cycling:
        maxStepDistanceCovered = totalStepCount * 1.5;
    }

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

    activeTimeMS = 0;
    totalStepCount = 0;

    lastPosition = position;
    lastPositionTimeStamp = DateTime.now();

    if (isPaused) return;

    List<PositionNodes> positionNodes = await _repository.getPositionNodes();

    if (previousPedestrianStatus?.status == "walking") {
      log("Adding walking node. selectedDistance: $selectedDistance, steps: $totalSteps", name: "ActivityDebug");
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
            orElse: () => ActivityStatus.unknown,
          ),
        ),
      );
      await _repository.savePositionNodes(positionNodes);
    } else {
      log("Skipping node addition. Status is: ${previousPedestrianStatus?.status}", name: "ActivityDebug");
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

    FlutterForegroundTask.updateService(
      notificationText:
          "Distance: ${distance >= 1000 ? (distance / 1000).toStringAsPrecision(2) : distance.toInt()} ${distance >= 1000 ? "KM" : "Meter"}, "
          "Duration: ${formatSeconds(durationInSec)}, "
          "Last Speed: ${calculatedSpeed > 0 ? calculatedSpeed.toStringAsPrecision(2) : "..."} KM/H",
    );
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    log("ForegroundExerciseTask onStart called at $timestamp", name: "ActivityDebug");
    await _handleGeolocationHistory();
  }


  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    await _handleGeolocationHistory();
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
    if (data == "pause_workout") {
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
    } else if (data == "resume_workout") {
      FlutterForegroundTask.updateService(
        notificationTitle: "Your Workout is running",
        notificationButtons: [
          const NotificationButton(
            id: "dismiss_workout",
            text: "Dismiss Workout",
            textColor: Colors.red,
          ),
          const NotificationButton(
            id: "pause_workout",
            text: "Pause Workout",
            textColor: Colors.red,
          ),
        ],
      );
    }
  }

  @override
  void onNotificationButtonPressed(String id) async {
    if (id == "dismiss_workout") {
      FlutterForegroundTask.sendDataToMain("dismiss_workout");
      await _repository.clearWorkoutData();
      FlutterForegroundTask.stopService();
    }
    if (id == "pause_workout") {
      FlutterForegroundTask.sendDataToMain("pause_workout");
      await _repository.saveIsPaused(true);
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
      await _repository.saveIsPaused(false);
      FlutterForegroundTask.updateService(
        notificationTitle: "Your Workout is running",
        notificationButtons: [
          const NotificationButton(
            id: "dismiss_workout",
            text: "Dismiss Workout",
            textColor: Colors.red,
          ),
          const NotificationButton(
            id: "pause_workout",
            text: "Pause Workout",
            textColor: Colors.red,
          ),
        ],
      );
    }
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/live-activity-resume");
  }

  @override
  void onNotificationDismissed() {}
}

Future<void> dismissWorkout() async {
  await WorkoutRepository().clearWorkoutData();
  FlutterForegroundTask.stopService();
}
