import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:get/get.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/app.dart";
import "package:x_obese/src/core/health/my_health_functions.dart";
import "package:x_obese/src/data/user_db.dart";
import "package:x_obese/src/screens/activity/models/activity_types.dart";
import "package:x_obese/src/screens/activity/models/position_nodes.dart";
import "package:x_obese/src/screens/auth/bloc/auth_bloc.dart";
import "package:x_obese/src/screens/auth/repository/auth_repository.dart";

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterForegroundTask.initCommunicationPort();

  await UserDB.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  await MyHealthFunctions.init();
  final sharedPreferences = await SharedPreferences.getInstance();
  List<PositionNodes>? activityNodesList =
      (sharedPreferences.getStringList(
        "activityNodesList",
      ))?.map((e) => PositionNodes.fromJson(e)).toList();

  bool? isPaused = sharedPreferences.getBool("isPaused");
  String? temActivity = sharedPreferences.getString("workout_type");
  ActivityType? activityType = ActivityType.values.firstWhereOrNull(
    (element) => element.name == temActivity,
  );
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(authRepository: AuthRepository()),
      child: App(
        positionNodes: activityNodesList,
        isPaused: isPaused,
        activityType: activityType,
      ),
    ),
  );
}
