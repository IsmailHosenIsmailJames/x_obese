import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
import "package:health/health.dart";
import "package:permission_handler/permission_handler.dart";
import "package:x_obese/src/core/health/util.dart";

class MyHealthFunctions {
  static final _health = Health();

  static List<HealthDataType> get types =>
      (Platform.isAndroid)
          ? dataTypesAndroid
          : (Platform.isIOS)
          ? dataTypesIOS
          : [];

  static List<HealthDataAccess> get permissions =>
      types.map((type) => HealthDataAccess.READ).toList();

  static Future<void> init() async {
    await _health.configure();
    log("health initialized", name: "health");
  }

  static Future<HealthConnectSdkStatus?> getSdkConfigurationStatus() async {
    // configure the health plugin before use and check the Health Connect status
    await init();
    if (Platform.isIOS) {
      return HealthConnectSdkStatus.sdkAvailable;
    }
    return await _health.getHealthConnectSdkStatus();
  }

  static Future<void> installHealthConnect() async =>
      await _health.installHealthConnect();

  static Future<bool> hasPermissions() async {
    // Check if we have health permissions
    bool? hasPermissions = await _health.hasPermissions(
      types,
      permissions: permissions,
    );
    return hasPermissions ?? false;
  }

  static Future<AppState> authorizePermissions() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    log(types.length.toString());
    log(permissions.length.toString());

    // Check if we have health permissions
    bool? hasPermissions = await _health.hasPermissions(
      types,
      permissions: permissions,
    );

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;

    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized = await _health.requestAuthorization(
          types,
          permissions: permissions,
        );

        // request access to read historic data
        await _health.requestHealthDataHistoryAuthorization();

        // request access in background
        await _health.requestHealthDataInBackgroundAuthorization();
      } catch (error) {
        debugPrint("Exception in authorize: $error");
      }
    }

    if (authorized == true) {
      log(hasPermissions.toString(), name: "hasPermissions");
      return AppState.AUTHORIZED;
    } else {
      return AppState.AUTH_NOT_GRANTED;
    }
  }

  static Future<List<HealthDataPoint>?> fetchData({
    required List<HealthDataType> types,
    required List<RecordingMethod> recordingMethodsToFilter,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    // setState(() => _state = AppState.FETCHING_DATA);

    // Clear old data points
    // _healthDataList.clear();

    try {
      // fetch health data
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        types: types,
        startTime: startTime,
        endTime: endTime,
        recordingMethodsToFilter: recordingMethodsToFilter,
      );

      debugPrint(
        "Total number of data points: ${healthData.length}. "
        '${healthData.length > 100 ? 'Only showing the first 100.' : ''}',
      );

      // sort the data points by date
      healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));
      return healthData;
      // save all the new data points (only the first 100)
      // _healthDataList.addAll(
      //   (healthData.length < 100) ? healthData : healthData.sublist(0, 100),
      // );
    } catch (error) {
      debugPrint("Exception in getHealthDataFromTypes: $error");
    }

    return null;

    // filter out duplicates
    // _healthDataList = health.removeDuplicates(_healthDataList);

    // for (var data in _healthDataList) {
    //   debugPrint(toJsonString(data));
    // }

    // update the UI to display the results
    // setState(() {
    //   _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
    // });
  }

  static Future<int?> fetchSteps(DateTime startTime, DateTime endTime) async {
    return await _health.getTotalStepsInInterval(startTime, endTime);
  }

  static Future<double> fetchCalories(
    DateTime startTime,
    DateTime endTime,
  ) async {
    double calories = 0;
    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startTime,
        endTime: endTime,
      );

      log(healthData.toString(), name: "MyHealthFunctions");
      for (final dataPoint in healthData) {
        log(dataPoint.value.toString(), name: "MyHealthFunctions");
        final value = dataPoint.value as NumericHealthValue?;
        if (value != null) {
          calories += value.numericValue.toDouble();
        }
      }
    } catch (e) {
      log("Error fetching calories: $e", name: "MyHealthFunctions");
    }
    return calories;
  }

  static Future<int> fetchHeartPoints(
    DateTime startTime,
    DateTime endTime,
  ) async {
    int heartPoints = 0;
    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startTime,
        endTime: endTime,
      );

      for (final dataPoint in healthData) {
        final value = dataPoint.value as NumericHealthValue?;
        if (value != null) {
          heartPoints += value.numericValue.toInt();
        }
      }
    } catch (e) {
      log("Error fetching heart points: $e", name: "MyHealthFunctions");
    }
    return heartPoints;
  }

  static Future<int> fetchWorkoutTime(
    DateTime startTime,
    DateTime endTime,
  ) async {
    int workoutTime = 0;
    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: startTime,
        endTime: endTime,
      );

      for (final dataPoint in healthData) {
        final value = dataPoint.value as WorkoutHealthValue?;
        if (value != null) {
          workoutTime +=
              (dataPoint.dateTo.millisecondsSinceEpoch -
                  dataPoint.dateFrom.millisecondsSinceEpoch);
        }
      }
    } catch (e) {
      log('Error fetching workout time: $e', name: 'MyHealthFunctions');
    }
    return workoutTime;
  }
}
