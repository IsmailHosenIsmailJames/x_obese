import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/screens/controller/info_collector/controller/controller.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:o_xbese/src/widgets/back_button.dart';

class HeightWeigthCollector extends StatefulWidget {
  final PageController pageController;

  const HeightWeigthCollector({super.key, required this.pageController});

  @override
  State<HeightWeigthCollector> createState() => _HeightWeigthCollectorState();
}

class _HeightWeigthCollectorState extends State<HeightWeigthCollector> {
  final AllInfoController controller = Get.find();
  int? fit;
  int? inch;
  int? weight;
  @override
  void initState() {
    if (controller.allInfo.value.heightFt != null &&
        controller.allInfo.value.weight != null) {
      fit = controller.allInfo.value.heightFt;
      inch = controller.allInfo.value.heightIn;
      weight = controller.allInfo.value.weight!.toInt();
    }
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
                child: getBackbutton(context, () {
                  widget.pageController.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                }),
              ),
              const Gap(32),
              LinearProgressIndicator(
                value: 4 / 5,
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
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceAround, // Added mainAxisAlignment here
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Height',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              color: MyAppColors.transparentGray,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: ListView.builder(
                              itemCount: 8,
                              scrollDirection: Axis.vertical,
                              itemBuilder:
                                  (context, index) => getButtonSelection(
                                    index: index + 1,
                                    toCompare: fit,
                                    text: '${index + 1} Ft',
                                    onPressed: () {
                                      setState(() {
                                        fit = index + 1;
                                      });
                                    },
                                  ),
                            ),
                          ),
                          const Gap(10),
                          Container(
                            width: 60,
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                              color: MyAppColors.transparentGray,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: ListView.builder(
                              itemCount: 12,
                              scrollDirection: Axis.vertical,
                              itemBuilder:
                                  (context, index) => getButtonSelection(
                                    index: index,
                                    toCompare: inch,
                                    text: '$index in',
                                    onPressed: () {
                                      setState(() {
                                        inch = index;
                                      });
                                    },
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Weight',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Gap(20),
                      Container(
                        width: 70,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          color: MyAppColors.transparentGray,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: ListView.builder(
                          itemCount: 300,
                          itemBuilder:
                              (context, index) => getButtonSelection(
                                index: index + 25,
                                toCompare: weight,
                                text: '${index + 25} kg',

                                onPressed: () {
                                  setState(() {
                                    weight = index + 25;
                                  });
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (fit != null && weight != null) {
                      controller.allInfo.value.heightFt = fit;
                      controller.allInfo.value.heightIn = inch;
                      controller.allInfo.value.weight = weight;
                      widget.pageController.animateToPage(
                        4,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
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

  Widget getButtonSelection({
    required int index,
    int? toCompare,
    required String text,
    required Function() onPressed,
  }) {
    return Container(
      height: 37,
      padding: const EdgeInsets.all(2.0),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor:
              index == toCompare ? MyAppColors.third : MyAppColors.mutedGray,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: index == toCompare ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
