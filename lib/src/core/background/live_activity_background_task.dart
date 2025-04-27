import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_obese/src/apis/apis_url.dart';
import 'package:x_obese/src/apis/middleware/jwt_middleware.dart';

@pragma('vm:entry-point')
void startCallbackLiveActivityBackgroundTask() {
  FlutterForegroundTask.setTaskHandler(LiveActivityBackgroundTask());
}

class LiveActivityBackgroundTask extends TaskHandler {
  StreamSubscription? streamSubscription;
  SharedPreferences? preferences;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _handleGeolocationEvent();
  }

  void _handleGeolocationEvent() {
    streamSubscription ??= Geolocator.getPositionStream(
      locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) async {
      preferences = await SharedPreferences.getInstance();
      await preferences!.reload();
      // TODO
      List<String> positionData =
          preferences!.getStringList('LiveActivityBackgroundTask') ?? [];
      positionData.add(jsonEncode(position.toJson()));
      FlutterForegroundTask.sendDataToMain(positionData);
      await FlutterForegroundTask.updateService(
        notificationText: 'Tap to return to Workout page',
        notificationTitle: 'Your location is tracking',
      );
    });
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    _handleGeolocationEvent();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    if (kDebugMode) {
      print('onDestroy');
    }
  }

  @override
  void onReceiveData(Object data) {
    if (kDebugMode) {
      print('onReceiveData: $data');
    }
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (kDebugMode) {
      print('onNotificationButtonPressed: $id');
    }
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
    if (kDebugMode) {
      print('onNotificationPressed');
    }
  }

  @override
  void onNotificationDismissed() {
    if (kDebugMode) {
      print('onNotificationDismissed');
    }
  }
}
