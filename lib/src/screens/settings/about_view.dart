import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/screens/settings/personal_details_view.dart';
import 'package:x_obese/src/widgets/back_button.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    AllInfoController allInfoController = Get.find();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  getBackButton(context, () {
                    Get.back();
                  }),
                  const Gap(80),
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Gap(22),
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
                    Get.to(() => AboutView());
                  },

                  child: Row(
                    children: [
                      const Text(
                        'Term & Conditions',
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
                    Get.to(() => AboutView());
                  },

                  child: Row(
                    children: [
                      const Text(
                        'Privacy Policy',
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
        ),
      ),
    );
  }
}
