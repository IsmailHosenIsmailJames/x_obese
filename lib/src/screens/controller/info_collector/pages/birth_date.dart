import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';

import '../controller/all_info_controller.dart';

class BirthDateCollector extends StatefulWidget {
  final PageController pageController;

  const BirthDateCollector({super.key, required this.pageController});

  @override
  State<BirthDateCollector> createState() => _BirthDateCollectorState();
}

class _BirthDateCollectorState extends State<BirthDateCollector> {
  final AllInfoController controller = Get.find();
  int? month;
  int? day;
  int? year;
  List<String> months3Char = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  @override
  void initState() {
    if (controller.allInfo.value.birth != null) {
      DateTime birthDate = controller.allInfo.value.birth!;
      month = birthDate.month - 1;
      day = birthDate.day;
      year = birthDate.year;
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
                child: getBackButton(context, () {
                  widget.pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }),
              ),
              const Gap(32),
              LinearProgressIndicator(
                value: 3 / 5,
                borderRadius: BorderRadius.circular(7),
                color: MyAppColors.third,
              ),
              const Gap(32),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'When Where Are You Born.?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const Gap(32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Month'),
                      const Gap(5),
                      SizedBox(
                        width:
                            ((MediaQuery.of(context).size.width - 48) / 10) * 3,
                        child: DropdownButtonFormField(
                          value: month,
                          decoration: getDropDownInputDecoration(
                            hintText: 'Month',
                          ),
                          items: List.generate(
                            12,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text(months3Char[index]),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              month = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Day'),
                      const Gap(5),
                      SizedBox(
                        width:
                            ((MediaQuery.of(context).size.width - 48) / 10) *
                            2.7,
                        child: DropdownButtonFormField(
                          value: day,
                          decoration: getDropDownInputDecoration(
                            hintText: 'Day',
                          ),
                          items: List.generate(
                            31,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text('${index + 1}'),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              day = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Year'),
                      const Gap(5),
                      SizedBox(
                        width:
                            ((MediaQuery.of(context).size.width - 48) / 10) * 3,
                        child: DropdownButtonFormField(
                          value: year == null ? null : (year! - 1940),
                          decoration: getDropDownInputDecoration(
                            hintText: 'Year',
                          ),
                          items: List.generate(
                            100,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: Text('${1940 + index}'),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              year = 1940 + (value ?? 0);
                            });
                          },
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
                    if (day != null && month != null && year != null) {
                      controller.allInfo.value.birth = DateTime(
                        year!,
                        month!,
                        day!,
                      );
                      setState(() {});
                      widget.pageController.animateToPage(
                        3,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    } else {
                      Fluttertoast.showToast(msg: 'Please select all fields');
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

  InputDecoration getDropDownInputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(4),
      ),
      filled: true,
      fillColor: MyAppColors.transparentGray,
      contentPadding: const EdgeInsets.all(3),
    );
  }
}
