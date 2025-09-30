import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:x_obese/src/apis/apis_url.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/data/user_db.dart";
import "package:x_obese/src/screens/auth/bloc/auth_bloc.dart";
import "package:x_obese/src/screens/auth/login/login_signup_page.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/info_collector/info_collector.dart";
import "package:x_obese/src/screens/info_collector/model/user_info_model.dart";
import "package:x_obese/src/screens/intro/intro_page.dart";
import "package:x_obese/src/screens/settings/about_view.dart";
import "package:x_obese/src/screens/settings/notification_settings_view.dart";
import "package:x_obese/src/screens/settings/personal_details_view.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/app_bar.dart";
import "package:x_obese/src/widgets/back_button.dart";
import "package:x_obese/src/widgets/popup_for_signup.dart";

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
    UserInfoModel? userInfoModel = context.read<AuthBloc>().userInfoModel();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                getAppBar(
                  backButton: getBackButton(context, () {
                    widget.pageController.jumpToPage(0);
                  }),
                  title: "Settings",
                  showLogo: true,
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
                              imageUrl:
                                  "$baseAPI/$imagePath/${allInfoController.allInfo.value.imagePath!}",
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
                      onPressed: () async {
                        if (userInfoModel?.isGuest ?? true) {
                          showSignupPopup(context);
                          return;
                        } else {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => InfoCollector(
                                    initialData:
                                        allInfoController.allInfo.value,
                                  ),
                            ),
                          );
                          allInfoController.dataAsync();
                        }
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
                if (!(userInfoModel?.isGuest ?? true))
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

                if (!(userInfoModel?.isGuest ?? true))
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

                if (!(userInfoModel?.isGuest ?? true))
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
                        showAccountDeletionPopup(context);
                      },

                      child: Row(
                        children: [
                          const Text(
                            "Account Deletion",
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/img/radient_logo.png",
                    height: 50,
                    width: 150,
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: () async {
                      if (userInfoModel?.isGuest ?? true) {
                        await UserDB.deleteUserData();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginSignupPage(),
                          ),
                          (route) => false,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              insetPadding: const EdgeInsets.all(10),
                              title: const Text("Are you sure?"),
                              content: const Text(
                                "Signing out will remove your session from this device. You can sign in again anytime.",
                                style: TextStyle(color: Colors.black87),
                              ),
                              actions: [
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.green,
                                  ),
                                  onPressed: () async {
                                    await clearTokens();
                                    await clearTokens();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const LoginSignupPage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  label: const Text("Cancel"),
                                  icon: const Icon(Icons.close_rounded),
                                  iconAlignment: IconAlignment.start,
                                ),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.redAccent,
                                  ),
                                  onPressed: () async {
                                    await clearTokens();
                                    await clearTokens();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const LoginSignupPage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  label: const Text("Sign Out"),
                                  icon: const Icon(Icons.arrow_forward_rounded),
                                  iconAlignment: IconAlignment.end,
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            (userInfoModel?.isGuest ?? true)
                                ? Colors.green[50]
                                : Colors.red[50],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            (userInfoModel?.isGuest ?? true)
                                ? Icons.login_rounded
                                : Icons.logout_rounded,
                          ),
                          const Gap(20),
                          Text(
                            (userInfoModel?.isGuest ?? true)
                                ? "Sign Up"
                                : "Signout",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAccountDeletionPopup(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 64,
                ),
                const Gap(18),
                const Text(
                  "Delete Account?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "This will permanently delete your account and all associated data. This action cannot be undone.",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: const Text("Cancel"),
                      ),
                    ),
                    const Gap(16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final dioClient = DioClient(baseAPI);
                          await dioClient.dio.delete(
                            "/api/user/v1/profile/token",
                          );
                          await Hive.deleteFromDisk();
                          await Hive.initFlutter();
                          await Hive.openBox("user");
                          await (await SharedPreferences.getInstance()).clear();
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IntroPage(),
                            ),
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.delete_forever),
                        label: const Text("Delete Forever"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
