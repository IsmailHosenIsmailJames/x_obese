import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:dio/dio.dart" as dio;
import "package:intl/intl.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/activity/data/workout_repository.dart";
import "package:x_obese/src/screens/activity/foreground/foreground_exercise_service.dart";
import "package:x_obese/src/screens/activity/models/activity_status.dart";
import "package:x_obese/src/screens/activity/models/activity_types.dart";
import "package:x_obese/src/screens/activity/models/position_nodes.dart";

class ActivityController extends GetxController {
  final DioClient dioClient = DioClient(baseAPI);
  final WorkoutRepository _repository = WorkoutRepository();

  var positionNodes = <PositionNodes>[].obs;
  var isPaused = false.obs;
  var workoutType = Rxn<ActivityType>();
  var isServiceRunning = false.obs;

  // Computed properties for UI
  double get totalDistance =>
      positionNodes.map((e) => e.selectedDistance).fold(0.0, (a, b) => a + b);

  int get durationInSec =>
      (positionNodes.map((e) => e.durationMS).fold(0.0, (a, b) => a + b) / 1000)
          .toInt();

  double get averageSpeed {
    if (positionNodes.isEmpty) return 0.0;
    final lastNode = positionNodes.last;
    if (lastNode.durationMS == 0) return 0.0;
    // (meters / 1000) / (ms / 1000 / 3600) => km/h
    return (lastNode.selectedDistance / 1000) /
        (lastNode.durationMS / 1000 / 3600);
  }

  ActivityStatus get lastActivityStatus => positionNodes.isNotEmpty
      ? positionNodes.last.status
      : ActivityStatus.stopped;

  int get totalSteps =>
      positionNodes.map((e) => e.steps).fold(0, (a, b) => a + b);

  @override
  void onInit() {
    super.onInit();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    _initForegroundTask();
    loadPersistedState();
  }

  @override
  void onClose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.onClose();
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: "foreground_service_workout",
        channelName: "Workout is running",
        channelDescription:
            "This notification appears when the workout is running.",
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> loadPersistedState() async {
    isPaused.value = await _repository.getIsPaused();
    workoutType.value = await _repository.getWorkoutType();
    positionNodes.assignAll(await _repository.getPositionNodes());
    isServiceRunning.value = await FlutterForegroundTask.isRunningService;

    if (isServiceRunning.value) {
      log("Resuming existing workout session", name: "ActivityController");
    }
  }

  void _onReceiveTaskData(Object data) async {
    try {
      if (data == "dismiss_workout") {
        stopWorkout(shouldPop: true);
        return;
      }
      if (data == "resume_workout") {
        isPaused.value = false;
        await _repository.saveIsPaused(false);
        return;
      }
      if (data == "pause_workout") {
        isPaused.value = true;
        await _repository.saveIsPaused(true);
        return;
      }

      final List<PositionNodes> nodes =
          (data as List)
              .map((e) => PositionNodes.fromJson(e as String))
              .toList();
      log("Received ${nodes.length} nodes from background service.", name: "ActivityDebug");
      positionNodes.assignAll(nodes);
    } catch (e) {
      log(e.toString(), name: "ActivityController_onReceiveTaskData");
    }
  }


  Future<void> startWorkout(ActivityType type) async {
    workoutType.value = type;
    await _repository.saveWorkoutType(type);
    await _repository.saveIsPaused(false);
    isPaused.value = false;

    if (await FlutterForegroundTask.isRunningService) {
      await FlutterForegroundTask.restartService();
    } else {
      await FlutterForegroundTask.startService(
        serviceTypes: [ForegroundServiceTypes.health],
        serviceId: 256,
        notificationTitle: "Your Workout is running",
        notificationText: "Tap to open the app",
        notificationIcon: null,
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
        notificationInitialRoute: "/workout",
        callback: startCallback,
      );
    }
    isServiceRunning.value = true;
  }

  Future<void> togglePause() async {
    isPaused.value = !isPaused.value;
    await _repository.saveIsPaused(isPaused.value);
    
    // Sync with background service
    if (isPaused.value) {
      FlutterForegroundTask.sendDataToTask("pause_workout");
    } else {
      FlutterForegroundTask.sendDataToTask("resume_workout");
    }
  }

  Future<void> stopWorkout({bool shouldPop = false}) async {
    await _repository.clearWorkoutData();
    await FlutterForegroundTask.stopService();
    positionNodes.clear();
    workoutType.value = null;
    isPaused.value = false;
    isServiceRunning.value = false;

    if (shouldPop) {
      Get.back();
    }
  }

  Future<dio.Response?> saveActivity(Map data, int steps) async {
    try {
      log(jsonEncode(data), name: "saveActivity_Data_send");
      final dio.Response response = await dioClient.dio.post(
        "/api/user/v1/workout",
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _saveSteps(steps);
        final message = response.data["message"] ?? "";
        Fluttertoast.showToast(msg: message);
        return response;
      }
    } on dio.DioException catch (e) {
      if (e.response != null) printResponse(e.response!);
    }
    return null;
  }

  Future<dio.Response?> saveMarathonUserActivity(
    Map data,
    int steps,
    String userID,
  ) async {
    try {
      final dio.Response response = await dioClient.dio.patch(
        "/api/marathon/v1/user/$userID",
        data: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _saveSteps(steps);
        final message = response.data["message"] ?? "";
        Fluttertoast.showToast(msg: message);
        return response;
      }
    } on dio.DioException catch (e) {
      if (e.response != null) printResponse(e.response!);
    }
    return null;
  }

  Future<void> _saveSteps(int steps) async {
    try {
      DateTime now = DateTime.now();
      await dioClient.dio.post(
        "/api/user/v1/workout/steps",
        data: {
          "steps": steps,
          "createdAt": DateFormat("yyyy-MM-dd").format(now),
        },
      );
    } on Exception catch (e) {
      log(e.toString(), name: "Steps Save error");
    }
  }
}
