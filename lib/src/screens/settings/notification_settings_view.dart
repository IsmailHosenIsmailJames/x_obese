import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/app_bar.dart";
import "package:x_obese/src/widgets/back_button.dart";

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  AllInfoController allInfoController = Get.find();
  bool isNotificationOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              getAppBar(
                backButton: getBackButton(
                  context,
                  () => Navigator.pop(context),
                ),
                title: "Notifications",
                showLogo: true,
              ),
              const Gap(22),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {},

                  child: Row(
                    children: [
                      const Text(
                        "Real-time Notification",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),

                      Switch.adaptive(
                        value: isNotificationOn,
                        activeTrackColor: MyAppColors.third,
                        onChanged: (value) {
                          setState(() {
                            isNotificationOn = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Image.asset(
                "assets/img/radient_logo.png",
                height: 50,
                width: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
