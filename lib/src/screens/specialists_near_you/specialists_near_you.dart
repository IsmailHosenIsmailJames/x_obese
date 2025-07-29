import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:x_obese/src/screens/specialists_near_you/models/specialists_near_you_model.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";
import "package:x_obese/src/widgets/get_specialist_doctor_card.dart";

class SpecialistsNearYou extends StatefulWidget {
  const SpecialistsNearYou({super.key});

  @override
  State<SpecialistsNearYou> createState() => _SpecialistsNearYouState();
}

class _SpecialistsNearYouState extends State<SpecialistsNearYou> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  getBackButton(context, () {
                    Navigator.pop(context);
                  }),
                  const Gap(55),
                  const Text(
                    "Specialists Near You",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: getSpecialistDoctorCard(
                      context: context,
                      data: SpecialistsNearYouModel(
                        image:
                            "https://www.figma.com/file/8frEvJAGHDh0TUQVUTXRF6/image/181a9ed08884107a88ece2bdbbae5d5fa943a40a",
                        address: "Hathazari Medical",
                        category: "General Specialist",
                        distance: "3.5 km",
                        name: "Dr. Ahmed Ali",
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      onTap: () {},
                      catalogFontSize: 13.0,
                      nameFontSize: 20.0,
                      distanceFontSize: 15.0,
                      addressFontSize: 13.0,
                      iconHeight: 18.0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
