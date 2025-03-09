import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../theme/colors.dart';
import '../controller/controller.dart';

class GenderCollector extends StatefulWidget {
  final PageController pageController;

  const GenderCollector({super.key, required this.pageController});

  @override
  State<GenderCollector> createState() => _GenderCollectorState();
}

class _GenderCollectorState extends State<GenderCollector> {
  final AllInfoController controller = Get.find();
  @override
  void initState() {
    controller.allInfo.value.gender = 'Male';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: () {
                      widget.pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    icon: SvgPicture.string(
                      '''<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <rect x="0.5" y="0.5" width="39" height="39" rx="19.5" stroke="#F3F3F3"/>
                      <path d="M18 16L14 20M14 20L18 24M14 20L26 20" stroke="#047CEC" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                      </svg>
                      ''',
                    ),
                  ),
                ),
              ),
              const Gap(32),
              LinearProgressIndicator(
                value: 2 / 5,
                borderRadius: BorderRadius.circular(7),
                color: MyAppColors.third,
              ),
              const Gap(32),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Choice Your Gender 👨‍👩‍👦‍👦',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const Gap(32),
              SizedBox(
                width: double.infinity,
                height: 53,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.allInfo.value.gender == 'Male'
                            ? MyAppColors.third
                            : MyAppColors.transparentGray,
                    foregroundColor:
                        controller.allInfo.value.gender == 'Male'
                            ? MyAppColors.primary
                            : MyAppColors.third,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.allInfo.value.gender = 'Male';
                    });
                  },
                  child: const Text(
                    'Male',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                height: 53,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.allInfo.value.gender == 'Female'
                            ? MyAppColors.third
                            : MyAppColors.transparentGray,
                    foregroundColor:
                        controller.allInfo.value.gender == 'Female'
                            ? MyAppColors.primary
                            : MyAppColors.third,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.allInfo.value.gender = 'Female';
                    });
                  },
                  child: const Text(
                    'Female',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
