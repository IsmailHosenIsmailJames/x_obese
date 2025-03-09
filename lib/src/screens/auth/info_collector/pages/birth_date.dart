import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:o_xbese/src/theme/colors.dart';

import '../controller/controller.dart';

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
    if (controller.allInfo.value.dateOfBirth != null) {
      DateTime birthDate = controller.allInfo.value.dateOfBirth!;
      month = birthDate.month;
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
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: () {
                      widget.pageController.animateToPage(
                        1,
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
                      controller.allInfo.value.dateOfBirth = DateTime(
                        year!,
                        month!,
                        day!,
                      );
                      setState(() {});
                      widget.pageController.animateToPage(
                        3,
                        duration: const Duration(milliseconds: 500),
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
