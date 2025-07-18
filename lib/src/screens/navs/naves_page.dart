import "dart:async";
import "dart:developer";
import "dart:io";

import "package:flutter/material.dart";
// import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_svg/svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:permission_handler/permission_handler.dart";
// import "package:x_obese/src/core/background/background_task.dart";
import "package:x_obese/src/resources/svg_string.dart";
import "package:x_obese/src/screens/activity/workout_page.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/home/home_page.dart";
import "package:x_obese/src/screens/marathon/marathon_page.dart";
import "package:x_obese/src/screens/navs/controller/navs_controller.dart";
import "package:x_obese/src/screens/settings/settings_page.dart";

import "../../theme/colors.dart";

class NavesPage extends StatefulWidget {
  const NavesPage({super.key});

  @override
  State<NavesPage> createState() => _NavesPageState();
}

class _NavesPageState extends State<NavesPage> {
  final NavsController navsController = Get.put(NavsController());
  PageController pageController = PageController();

  final userBox = Hive.box("user");
  AllInfoController allInfoController = Get.put(AllInfoController());

  Future<void> _requestPermissions() async {
    final PermissionStatus notificationPermission =
        await Permission.notification.status;
    if (notificationPermission != PermissionStatus.granted) {
      await Permission.notification.request();
    }

    var ignoreBatteryOpt = await Permission.ignoreBatteryOptimizations.status;
    if (ignoreBatteryOpt != PermissionStatus.granted && Platform.isAndroid) {
      ignoreBatteryOpt = await Permission.ignoreBatteryOptimizations.request();
    }

    if (Platform.isAndroid) {
      if (!await Permission.ignoreBatteryOptimizations.isGranted) {
        await Permission.ignoreBatteryOptimizations.request();
      }

      if (!await Permission.scheduleExactAlarm.isGranted) {
        await Permission.scheduleExactAlarm.request();
      }
    }
    try {
      if (Platform.isAndroid) {
        bool status = await Permission.activityRecognition.isGranted;
        if (!status) {
          PermissionStatus requestStatus =
              await Permission.activityRecognition.request();
          if (!requestStatus.isGranted) {
            Fluttertoast.showToast(
              msg: "Please allow access Physical activity",
            );
            await openAppSettings();
          }
        }
        log(status.toString(), name: "Permission status");
      }
    } catch (e) {
      log(e.toString(), name: "Permission error");
    }
  }

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
      await _requestPermissions();
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
