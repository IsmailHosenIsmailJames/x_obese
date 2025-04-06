import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/screens/marathon/components/onsite_marathon_card.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';
import 'package:x_obese/src/screens/marathon/components/virtual_marathon_cards.dart';

class MarathonPage extends StatefulWidget {
  final PageController pageController;
  const MarathonPage({super.key, required this.pageController});

  @override
  State<MarathonPage> createState() => _MarathonPageState();
}

class _MarathonPageState extends State<MarathonPage> {
  int selectedIndex = 0;
  PageController pageController = PageController();
  AllInfoController allInfoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
            child: Row(
              children: [
                getBackbutton(
                  context,
                  () => widget.pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Marathon Program',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.string(
                    '''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
                    <path d="M22 22L20 20M2 11.5C2 6.25329 6.25329 2 11.5 2C16.7467 2 21 6.25329 21 11.5C21 16.7467 16.7467 21 11.5 21C6.25329 21 2 16.7467 2 11.5Z" stroke="#28303F" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>''',
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),

          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
            child: Container(
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: MyAppColors.third,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedIndex == 0
                              ? MyAppColors.primary
                              : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      foregroundColor:
                          selectedIndex == 0 ? MyAppColors.third : Colors.white,
                    ),
                    onPressed: () {
                      pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear,
                      );
                    },
                    child: const Text(' Virtual Marathon '),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedIndex == 1
                              ? MyAppColors.primary
                              : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      foregroundColor:
                          selectedIndex == 1 ? MyAppColors.third : Colors.white,
                    ),
                    onPressed: () {
                      pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.linear,
                      );
                    },
                    child: const Text(' Onsite marathon '),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              children: [
                Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 15,
                      right: 15,
                    ),
                    itemCount: allInfoController.marathonList.length,
                    itemBuilder: (context, index) {
                      if (allInfoController.marathonList[index].type ==
                          'virtual') {
                        return getMarathonCard(
                          marathonData: allInfoController.marathonList[index],
                          context: context,
                          margin: const EdgeInsets.only(top: 20),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
                Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      left: 15,
                      right: 15,
                    ),
                    itemCount: allInfoController.marathonList.length,
                    itemBuilder: (context, index) {
                      if (allInfoController.marathonList[index].type !=
                          'virtual') {
                        return getOnsiteMarathon(
                          context: context,
                          marathonData: allInfoController.marathonList[index],
                          margin: const EdgeInsets.only(top: 20),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
