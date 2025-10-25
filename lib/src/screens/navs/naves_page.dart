import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:x_obese/src/resources/svg_string.dart";
import "package:x_obese/src/screens/activity/live_activity_page.dart";
import "package:x_obese/src/screens/activity/workout_page.dart";
import "package:x_obese/src/screens/home/home_page.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/marathon/marathon_page.dart";
import "package:x_obese/src/screens/navs/controller/navs_controller.dart";
import "package:x_obese/src/screens/settings/settings_page.dart";

import "../../theme/colors.dart";
import "../activity/models/activity_types.dart";
import "../activity/models/position_nodes.dart";

class NavesPage extends StatefulWidget {
  final bool? autoNavToWorkout;
  final List<PositionNodes>? positionNodes;
  final ActivityType? activityType;
  final bool? isPaused;
  const NavesPage({
    super.key,
    this.autoNavToWorkout,
    this.positionNodes,
    this.isPaused,
    this.activityType,
  });

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
      if (widget.autoNavToWorkout == true) {
        navsController.changeBottomNav(1);
        pageController.jumpToPage(1);
        log(
          "message ${[widget.activityType != null, widget.positionNodes != null, widget.positionNodes!.isNotEmpty, widget.isPaused != null]}",
        );
        if (widget.activityType != null &&
            widget.positionNodes != null &&
            widget.positionNodes!.isNotEmpty &&
            widget.isPaused != null) {
          log("message999");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => LiveActivityPage(
                    workoutType: widget.activityType!,
                    initialLatLon: widget.positionNodes!.last.position,
                  ),
            ),
          );
        } else {}
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
