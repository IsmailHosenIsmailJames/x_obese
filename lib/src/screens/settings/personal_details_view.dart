import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";

class PersonalDetailsView extends StatelessWidget {
  const PersonalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    AllInfoController allInfoController = Get.find();
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  getBackButton(context, () {
                    Navigator.pop(context);
                  }),
                  const Gap(55),
                  const Text(
                    "Personal Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Gap(22),

              SizedBox(
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),

                  child: Row(
                    children: [
                      const Text("Gender"),
                      const Spacer(),
                      Text(
                        allInfoController.allInfo.value.gender.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                      const Gap(15),
                      arrowIcon,
                    ],
                  ),
                ),
              ),
              const Gap(12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),

                  child: Row(
                    children: [
                      const Text("Date Of Birth"),
                      const Spacer(),
                      Text(
                        DateFormat(
                          "yyyy-MM-dd",
                        ).format(allInfoController.allInfo.value.birth!),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                      const Gap(15),
                      arrowIcon,
                    ],
                  ),
                ),
              ),
              const Gap(12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),

                  child: Row(
                    children: [
                      const Text("Height"),
                      const Spacer(),
                      Text(
                        "${allInfoController.allInfo.value.heightFt} feet ${allInfoController.allInfo.value.heightIn} inch",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                      const Gap(15),
                      arrowIcon,
                    ],
                  ),
                ),
              ),
              const Gap(12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),

                  child: Row(
                    children: [
                      const Text("Weight"),
                      const Spacer(),
                      Text(
                        "${allInfoController.allInfo.value.weight} kg",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: MyAppColors.mutedGray,
                        ),
                      ),
                      const Gap(15),
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

Widget arrowIcon = SvgPicture.string(
  '''<svg width="6" height="12" viewBox="0 0 6 12" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M1 1L5 6L1 11" stroke="#737373" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''',
);

// Gender
// Date of Birth
// Height
// Weight
