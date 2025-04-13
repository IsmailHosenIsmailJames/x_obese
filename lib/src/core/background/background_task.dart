import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x_obese/src/apis/apis_url.dart';
import 'package:x_obese/src/apis/middleware/jwt_middleware.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  StreamSubscription? streamSubscription;
  SharedPreferences? preferences;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    streamSubscription = Pedometer.stepCountStream.listen((event) async {
      String dateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String stepsKey = 'stepsCount_$dateString';
      preferences ??= await SharedPreferences.getInstance();
      int stepsCount = preferences!.getInt(stepsKey) ?? 0;
      stepsCount++;
      preferences!.setInt(stepsKey, stepsCount);
      Set<String> keysListOfSteps = preferences!.getKeys();
      for (String key in keysListOfSteps) {
        if (key.split('_').last != dateString) {
          // need to backup
          try {
            DioClient dioClient = DioClient(baseAPI);
            final response = await dioClient.dio.post(
              '/api/user/v1/workout/steps',
              data: {'steps': stepsCount, 'createdAt': key.split('_').last},
            );
            printResponse(response);
            if (response.statusCode == 201) {
              await preferences?.remove(key);
              log('Data backed and removed from local');
            }
          } on DioException catch (e) {
            log(e.message ?? '', name: 'DioException');
            if (e.response != null) {
              printResponse(e.response!);
            }
          }
        }
      }
      FlutterForegroundTask.sendDataToMain(event.steps);
      await FlutterForegroundTask.updateService(
        notificationText: 'Tap to return to the app',
        notificationTitle: 'Today\'s Steps Count: ${event.steps}',
      );
    });
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    await streamSubscription?.cancel();
    streamSubscription = Pedometer.stepCountStream.listen((event) async {
      FlutterForegroundTask.sendDataToMain(event.steps);
      await FlutterForegroundTask.updateService(
        notificationText: 'Tap to return to the app',
        notificationTitle: 'Today\'s Steps Count: ${event.steps}',
      );
    });
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
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
