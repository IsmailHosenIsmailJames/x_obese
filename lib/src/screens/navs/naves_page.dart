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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool isPermissionAlreadyRequested = Hive.box(
        "user",
      ).get("isPermissionAlreadyRequested", defaultValue: false);
      if (!isPermissionAlreadyRequested) await requestPermissions();
      Hive.box("user").put("isPermissionAlreadyRequested", true);
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
      } else {
        navsController.changeBottomNav(0);
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
