import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
// import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_svg/svg.dart";
import "package:geolocator/geolocator.dart" hide ActivityType;
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/main.dart";
import "package:x_obese/src/core/common/functions/calculate_distance.dart";
import "package:x_obese/src/core/in_app_update/in_app_android_update/in_app_update_android.dart";
import "package:x_obese/src/core/permissions/permission.dart";
// import "package:x_obese/src/core/background/background_task.dart";
import "package:x_obese/src/resources/svg_string.dart";
import "package:x_obese/src/screens/activity/live_activity_page.dart";
import "package:x_obese/src/screens/activity/workout_page.dart";
import "package:x_obese/src/screens/home/home_page.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/marathon/marathon_page.dart";
import "package:x_obese/src/screens/navs/controller/navs_controller.dart";
import "package:x_obese/src/screens/settings/settings_page.dart";

import "../../theme/colors.dart";

class NavesPage extends StatefulWidget {
  final bool? autoNavToWorkout;

  const NavesPage({super.key, this.autoNavToWorkout});

  @override
  State<NavesPage> createState() => _NavesPageState();
}

class _NavesPageState extends State<NavesPage> {
  final NavsController navsController = Get.put(NavsController());
  PageController pageController = PageController();

  final userBox = Hive.box("user");
  AllInfoController allInfoController = Get.put(AllInfoController());

  // void _initService() {
  // FlutterForegroundTask.init(
  //   androidNotificationOptions: AndroidNotificationOptions(
  //     channelId: "foreground_service",
  //     channelName: "Foreground Service Notification",
  //     channelDescription:
  //         "This notification appears when the foreground service is running.",
  //     onlyAlertOnce: true,
  //   ),
  //   iosNotificationOptions: const IOSNotificationOptions(
  //     showNotification: false,
  //     playSound: false,
  //   ),
  //   foregroundTaskOptions: ForegroundTaskOptions(
  //     eventAction: ForegroundTaskEventAction.repeat(1000),
  //     autoRunOnBoot: true,
  //     autoRunOnMyPackageReplaced: true,
  //     allowWakeLock: true,
  //     allowWifiLock: true,
  //   ),
  // );
  // }

  // Future<ServiceRequestResult> _startService() async {
  //   if (await FlutterForegroundTask.isRunningService) {
  //     return FlutterForegroundTask.restartService();
  //   } else {
  //     return FlutterForegroundTask.startService(
  //       serviceId: 256,
  //       notificationTitle: "Foreground Service is running",
  //       notificationText: "Tap to return to the app",
  //       notificationIcon: null,
  //       notificationButtons: [
  //         const NotificationButton(id: "btn_hello", text: "hello"),
  //       ],
  //       notificationInitialRoute: "/home",
  //       // callback: startCallback,
  //     );
  //   }
  // }

  // void _onReceiveTaskData(Object data) {
  //   log("onReceiveTaskData: $data");
  //   allInfoController.stepsCount.value = data as int;
  // }

  @override
  void initState() {
    super.initState();

    // FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await requestPermissions();
      // Schedule update check after MaterialApp is built

      if (isUpdateChecked != true) {
        if (Platform.isAndroid) {
          inAppUpdateAndroid(context);
        }
      }

      if (widget.autoNavToWorkout == true) {
        navsController.changeBottomNav(1);
        pageController.jumpToPage(1);
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.reload();
        String? workoutType = sharedPreferences.getString("workout_type");
        log("workoutType: $workoutType");
        if (workoutType == null) {
          ActivityType? activityType = ActivityType.values.firstWhereOrNull(
            (element) => element.name == workoutType,
          );
          log(activityType.toString(), name: "activityType");
          if (activityType == null) {
            return;
          }
          List<String> geolocationHistory =
              sharedPreferences.getStringList("geolocationHistory") ?? [];
          if (geolocationHistory.isEmpty) {
            log("geolocationHistory is empty");
            return;
          }
          log("Auto Nav: ${geolocationHistory.length}");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => LiveActivityPage(
                      workoutType: activityType,
                      initialLatLon: Position.fromMap(
                        jsonDecode(geolocationHistory.first),
                      ),
                    ),
              ),
            );
          });
        }
      }
    });
  }

  final ValueNotifier<Object?> stepsCountListenable = ValueNotifier(null);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,

      body: SafeArea(
        child: PageView(
          controller: pageController,
          onPageChanged: (value) {
            navsController.changeBottomNav(value);
          },
          children: [
            HomePage(pageController: pageController),
            ActivityPage(pageController: pageController),
            MarathonPage(pageController: pageController),
            SettingsPage(pageController: pageController),
          ],
        ),
      ),
      bottomNavigationBar: GetX<NavsController>(
        builder:
            (controller) => BottomNavigationBar(
              backgroundColor: Colors.white,

              onTap: (value) {
                controller.changeBottomNav(value);
                pageController.jumpToPage(value);
              },

              currentIndex: controller.bottomNavIndex.value,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: MyAppColors.third,
              unselectedItemColor: MyAppColors.mutedGray,
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.string(homeOutLine),
                  activeIcon: SvgPicture.string(homeFill),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.string(activityOutLine),
                  activeIcon: SvgPicture.string(activityFill),
                  label: "Activity",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.string(marathonOutLine),
                  activeIcon: SvgPicture.string(marathonFill),
                  label: "Marathon",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.string(settingsOutLine),
                  activeIcon: SvgPicture.string(settingsFill),
                  label: "Settings",
                ),
              ],
            ),
      ),
    );
  }
}
