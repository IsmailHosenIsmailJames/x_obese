import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/screens/activity/activity_page.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 40,
                width: 40,
                color: MyAppColors.transparentGray,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Pierre-Person.jpg/400px-Pierre-Person.jpg?20170622160125',
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
                //  Icon(
                //   FluentIcons.person_24_regular,
                //   size: 30,
                //   color: MyAppColors.mutedGray,
                // ),
              ),
            ),
            const Gap(8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello 👋',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                Text(
                  'My Names',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: MyAppColors.mutedGray,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.string(notificationSvg),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (value) {
          navsController.changeBottomNav(value);
        },
        children: [
          const HomePage(),
          const ActivityPage(),
          const MarathonPage(),
          const SettingsPage(),
        ],
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
