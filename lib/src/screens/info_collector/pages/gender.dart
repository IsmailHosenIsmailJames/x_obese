import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:x_obese/src/widgets/back_button.dart";

import "../../../theme/colors.dart";
import "../controller/all_info_controller.dart";

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
                child: getBackButton(context, () {
                  widget.pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }),
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
                  "Choose Your Gender ?",
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
                        controller.allInfo.value.gender == "Male"
                            ? MyAppColors.third
                            : MyAppColors.transparentGray,
                    foregroundColor:
                        controller.allInfo.value.gender == "Male"
                            ? MyAppColors.primary
                            : MyAppColors.third,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.allInfo.value.gender = "Male";
                    });
                  },
                  child: const Text(
                    "Male",
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
                        controller.allInfo.value.gender == "Female"
                            ? MyAppColors.third
                            : MyAppColors.transparentGray,
                    foregroundColor:
                        controller.allInfo.value.gender == "Female"
                            ? MyAppColors.primary
                            : MyAppColors.third,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.allInfo.value.gender = "Female";
                    });
                  },
                  child: const Text(
                    "Female",
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
                    if (controller.allInfo.value.gender == null) {
                      Fluttertoast.showToast(msg: "Please select your gender");
                      return;
                    }
                    widget.pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text(
                    "Next",
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
