import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:o_xbese/src/screens/activity/workout_page.dart';
import 'package:o_xbese/src/screens/controller/info_collector/controller/controller.dart';
import 'package:o_xbese/src/screens/home/home_page.dart';
import 'package:o_xbese/src/resources/svg_string.dart';
import 'package:o_xbese/src/screens/marathon/marathon_page.dart';
import 'package:o_xbese/src/screens/navs/controller/navs_controller.dart';
import 'package:o_xbese/src/screens/settings/settings_page.dart';

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
            const HomePage(),
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
