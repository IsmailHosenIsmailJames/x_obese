import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_activity_recognition/models/activity.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:o_xbese/src/core/background/background_task.dart';
import 'package:o_xbese/src/core/common/functions/request_and_check_activity_permission.dart';
import 'package:o_xbese/src/screens/activity/workout_page.dart';
import 'package:o_xbese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:o_xbese/src/screens/home/home_page.dart';
import 'package:o_xbese/src/resources/svg_string.dart';
import 'package:o_xbese/src/screens/marathon/marathon_page.dart';
import 'package:o_xbese/src/screens/navs/controller/navs_controller.dart';
import 'package:o_xbese/src/screens/settings/settings_page.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/colors.dart';

class NavesPage extends StatefulWidget {
  const NavesPage({super.key});

  @override
  State<NavesPage> createState() => _NavesPageState();
}

class _NavesPageState extends State<NavesPage> {
  final NavsController navsController = Get.put(NavsController());
  PageController pageController = PageController();

  final userBox = Hive.box('user');
  AllInfoController allInfoController = Get.put(AllInfoController());

  Future<void> _requestPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      // Use this utility only if you provide services that require long-term survival,
      // such as exact alarm service, healthcare service, or Bluetooth communication.
      //
      // This utility requires the "android.permission.SCHEDULE_EXACT_ALARM" permission.
      // Using this permission may make app distribution difficult due to Google policy.
      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        // When you call this function, will be gone to the settings page.
        // So you need to explain to the user why set it.
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }
  }

  void _initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(id: 'btn_hello', text: 'hello'),
        ],
        notificationInitialRoute: '/second',
        callback: startCallback,
      );
    }
  }

  void _onReceiveTaskData(Object data) {
    log('onReceiveTaskData: $data');
    allInfoController.stepsCount.value = data as int;
  }

  // end of foreground service
  @override
  void initState() {
    checkActivityStream();
    super.initState();

    // Add a callback to receive data sent from the TaskHandler.
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request permissions and initialize the service.
      _requestPermissions();
      _initService();
      _startService();
    });
  }

  final ValueNotifier<Object?> stepsCountListenable = ValueNotifier(null);

  StreamSubscription<Activity>? activitySubscription;

  Future<void> subscribeActivityStream() async {
    if (await checkAndRequestPermission()) {
      activitySubscription = FlutterActivityRecognition.instance.activityStream
          .listen((event) {
            log(event.type.toString());
          });
    }
  }

  Stream<StepCount>? _stepCountStream;

  Future<void> initPlatformState() async {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen((event) {
      log(event.toString());
    });
  }

  Future<void> checkActivityStream() async {
    bool status = await checkAndRequestPermission();
    if (!status) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('We need to access you activity.'),
            content: const Text(
              'Please grant to access your activity. Without this, app can\'t function properly',
            ),
            actions: [
              ElevatedButton.icon(
                onPressed: () async {
                  SystemNavigator.pop();
                },
                label: const Text('Quit App'),
                icon: const Icon(Icons.close, color: Colors.red),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  bool status = await checkAndRequestPermission();
                  if (status) {
                    if (activitySubscription == null) {
                      subscribeActivityStream();
                    }
                    Navigator.pop(context);
                  } else {
                    await openAppSettings();
                    Navigator.pop(context);
                    log('message');
                  }
                },
                label: const Text('Allow'),
                icon: const Icon(Icons.done, color: Colors.green),
              ),
            ],
          );
        },
      );
    } else {
      if (activitySubscription == null) {
        subscribeActivityStream();
      }
      initPlatformState();
    }
  }

  @override
  void dispose() {
    activitySubscription?.cancel();
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
            const SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: GetX<NavsController>(
        builder:
            (controller) => BottomNavigationBar(
              onTap: (value) {
                controller.changeBottomNav(value);
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                );
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
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.string(activityOutLine),
                  activeIcon: SvgPicture.string(activityFill),
                  label: 'Activity',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.string(marathonOutLine),
                  activeIcon: SvgPicture.string(marathonFill),
                  label: 'Marathon',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.string(settingsOutLine),
                  activeIcon: SvgPicture.string(settingsFill),
                  label: 'Settings',
                ),
              ],
            ),
      ),
    );
  }
}
