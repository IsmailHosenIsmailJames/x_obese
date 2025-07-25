import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/screens/auth/login/login_signup_page.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/info_collector/info_collector.dart";
import "package:x_obese/src/screens/settings/about_view.dart";
import "package:x_obese/src/screens/settings/notification_settings_view.dart";
import "package:x_obese/src/screens/settings/personal_details_view.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";

class SettingsPage extends StatefulWidget {
  final PageController pageController;
  const SettingsPage({super.key, required this.pageController});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AllInfoController allInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    getBackButton(context, () {
                      widget.pageController.jumpToPage(0);
                    }),
                    const Gap(55),
                    const Text(
                      "Settings",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Gap(22),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: MyAppColors.transparentGray,
                    ),
                    child:
                        (allInfoController.allInfo.value.image != null)
                            ? CachedNetworkImage(
                              imageUrl: allInfoController.allInfo.value.image!,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Icon(
                                  Icons.broken_image,
                                  color: MyAppColors.mutedGray,
                                  size: 18,
                                );
                              },
                            )
                            : const Icon(Icons.person_outline, size: 20),
                  ),
                ),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(allInfoController.allInfo.value.fullName ?? ""),

                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => InfoCollector(
                                  initialData: allInfoController.allInfo.value,
                                ),
                          ),
                        );
                      },
                      icon: SvgPicture.string(
                        '''<svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M1 17H17M10.5861 3.05486C10.5861 3.05486 10.5861 4.50786 12.0391 5.96086C13.4921 7.41386 14.9451 7.41386 14.9451 7.41386M4.83967 14.3227L7.89097 13.8868C8.33111 13.824 8.73898 13.62 9.05337 13.3056L16.3981 5.96085C17.2006 5.15838 17.2006 3.85732 16.3981 3.05485L14.9451 1.60185C14.1427 0.799383 12.8416 0.799382 12.0391 1.60185L4.69437 8.94663C4.37998 9.26102 4.17604 9.66889 4.11317 10.109L3.67727 13.1603C3.5804 13.8384 4.1616 14.4196 4.83967 14.3227Z" stroke="#527AFF" stroke-linecap="round"/>
            </svg>
            ''',
                      ),
                    ),
                  ],
                ),
                const Gap(35),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "My Account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PersonalDetailsView(),
                        ),
                      );
                    },

                    child: Row(
                      children: [
                        const Text(
                          "Personal Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        arrowIcon,
                      ],
                    ),
                  ),
                ),
                const Gap(5),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const NotificationSettingsView(),
                        ),
                      );
                    },

                    child: Row(
                      children: [
                        const Text(
                          "Notification",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        arrowIcon,
                      ],
                    ),
                  ),
                ),
                const Gap(5),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutView(),
                        ),
                      );
                    },

                    child: Row(
                      children: [
                        const Text(
                          "About",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        arrowIcon,
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Align(
              alignment: const Alignment(1, 1),
              child: GestureDetector(
                onTap: () async {
                  await clearTokens();
                  await clearTokens();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginSignupPage(),
                    ),
                    (route) => false,
                  );
                  // showDialog(
                  //   context: context,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       title: Text('Are you sure ?'),
                  //       content: Text(''),
                  //     );
                  //   },
                  // );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded),
                      Gap(20),
                      Text("Signout"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
