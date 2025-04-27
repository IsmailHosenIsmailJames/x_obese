import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:x_obese/src/screens/activity/live_activity_page.dart';
import 'package:x_obese/src/screens/marathon/details_marathon/model/full_marathon_data_model.dart';
import 'package:x_obese/src/screens/marathon/models/marathon_user_model.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';
import 'package:x_obese/src/widgets/loading_popup.dart';
import 'package:x_obese/src/core/common/functions/calculate_distance.dart'
    as workout_calculator;

class ActivityPage extends StatefulWidget {
  final MarathonUserModel? marathonUserModel;
  final FullMarathonDataModel? marathonData;

  final PageController? pageController;
  const ActivityPage({
    super.key,
    this.pageController,
    this.marathonUserModel,
    this.marathonData,
  });

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<workout_calculator.ActivityType> workOutMode = [
    workout_calculator.ActivityType.running,
    workout_calculator.ActivityType.walking,
    workout_calculator.ActivityType.cycling,
  ];
  workout_calculator.ActivityType selectedMode =
      workout_calculator.ActivityType.walking;
  int requestTime = 0;
  @override
  void initState() {
    // for (var element in workOutMode) {
    //   log("${element.name} == ${widget.marathonData?.type?.toLowerCase()}");
    //   if (element.name == widget.marathonData?.type?.toLowerCase()) {
    //     selectedMode = element;
    //   }
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getBackButton(context, () {
                    if (widget.pageController != null) {
                      widget.pageController!.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    } else {
                      Get.back();
                    }
                  }),
                  const Gap(55),
                  const Text(
                    'Workout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Gap(22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(workOutMode.length, (index) {
                  return SizedBox(
                    height: 30,
                    width: ((MediaQuery.of(context).size.width - 48) / 3) - 8,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor:
                            workOutMode[index] == selectedMode
                                ? MyAppColors.third
                                : MyAppColors.transparentGray,
                        foregroundColor:
                            workOutMode[index] == selectedMode
                                ? MyAppColors.primary
                                : MyAppColors.third,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMode = workOutMode[index];
                        });
                      },
                      child: Text(workOutMode[index].toString()),
                    ),
                  );
                }),
              ),
              const Gap(24),
              Container(
                height: 100,
                width: double.infinity,

                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffFAFAFA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.marathonData != null
                              ? '${(widget.marathonData!.data?.distanceKm ?? 0) - double.parse(widget.marathonUserModel?.distanceKm ?? '0')} '
                              : '0.00 ',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'km',
                            style: TextStyle(
                              fontSize: 16,
                              color: MyAppColors.second,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: SvgPicture.asset('assets/img/workoutPage.svg')),
              const Gap(24),
              Container(
                height: 80,
                width: double.infinity,

                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: MyAppColors.transparentGray,
                        ),
                        onPressed: () {},
                        icon: SvgPicture.string(
                          '''<svg xmlns="http://www.w3.org/2000/svg" width="35" height="34" viewBox="0 0 35 34" fill="none">
                      <path fill-rule="evenodd" clip-rule="evenodd" d="M17.5002 33.6666C26.7049 33.6666 34.1668 26.2047 34.1668 16.9999C34.1668 7.79517 26.7049 0.333252 17.5002 0.333252C8.29542 0.333252 0.833496 7.79517 0.833496 16.9999C0.833496 26.2047 8.29542 33.6666 17.5002 33.6666ZM22.2688 10.4096L11.8182 13.8932C10.5053 14.3308 10.5053 16.188 11.8182 16.6256L15.6773 17.912C16.1073 18.0553 16.4447 18.3928 16.5881 18.8228L17.8744 22.6819C18.3121 23.9948 20.1693 23.9948 20.6069 22.6819L24.0904 12.2313C24.4657 11.1055 23.3946 10.0344 22.2688 10.4096Z" fill="#047CEC"/>
                    </svg>''',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: MyAppColors.transparentGray,
                        ),
                        onPressed: () async {
                          getLocationAndStartActivity();
                        },
                        icon: SvgPicture.string(
                          '''<svg width="33" height="32" viewBox="0 0 33 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M24.1278 17.7363L11.4923 24.9566C10.159 25.7185 8.5 24.7558 8.5 23.2201V15.9998V8.77953C8.5 7.24389 10.159 6.28115 11.4923 7.04305L24.1278 14.2634C25.4714 15.0311 25.4714 16.9685 24.1278 17.7363Z" fill="#047CEC"/>
</svg>
''',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: MyAppColors.transparentGray,
                        ),
                        onPressed: () {},
                        icon: SvgPicture.string(
                          '''<svg xmlns="http://www.w3.org/2000/svg" width="23" height="28" viewBox="0 0 23 28" fill="none">
  <path fill-rule="evenodd" clip-rule="evenodd" d="M7.16683 7.00008C7.16683 4.60685 9.10693 2.66675 11.5002 2.66675C13.8934 2.66675 15.8335 4.60685 15.8335 7.00008V8.66675H7.16683V7.00008ZM5.16683 8.76034V7.00008C5.16683 3.50228 8.00236 0.666748 11.5002 0.666748C14.998 0.666748 17.8335 3.50228 17.8335 7.00008V8.76034C20.301 9.22842 22.1668 11.3964 22.1668 14.0001V22.0001C22.1668 24.9456 19.779 27.3334 16.8335 27.3334H6.16683C3.22131 27.3334 0.833496 24.9456 0.833496 22.0001V14.0001C0.833496 11.3964 2.6993 9.22842 5.16683 8.76034ZM14.1668 18.0001C14.1668 19.4728 12.9729 20.6667 11.5002 20.6667C10.0274 20.6667 8.8335 19.4728 8.8335 18.0001C8.8335 16.5273 10.0274 15.3334 11.5002 15.3334C12.9729 15.3334 14.1668 16.5273 14.1668 18.0001Z" fill="#047CEC"/>
</svg>''',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLocationAndStartActivity() async {
    requestTime++;
    showLoadingPopUp(context, loadingText: 'Getting your location...');
    LocationPermission status = await Geolocator.checkPermission();
    log(status.toString());
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();

      if (status == LocationPermission.denied && requestTime > 2) {
        Fluttertoast.showToast(msg: 'Location Permission is Required');
        await Geolocator.openLocationSettings();
      }
    }
    if (status == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location Permission is Required');
      await Geolocator.openLocationSettings();
    }
    status = await Geolocator.checkPermission();
    if (status == LocationPermission.whileInUse ||
        status == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
      );
      if (position.accuracy > 50) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                title: const Text('The GPS signal is week!'),
                content: Text(
                  'We need to have better GPS signal. Go open sky for get best GPS signal. Found noise around ${position.accuracy.toPrecision(2)} meter',
                ),
                actions: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyAppColors.third,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      getLocationAndStartActivity();
                    },
                    label: const Text(
                      'Try Again',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
        );
        return;
      }
      Navigator.pop(context);
      await Get.to(
        () => LiveActivityPage(
          workoutType: selectedMode,
          initialLatLon: position,
          marathonData: widget.marathonData,
          marathonUserModel: widget.marathonUserModel,
        ),
      );

      requestTime = 0;
      return;
    } else {
      Fluttertoast.showToast(msg: 'Location Permission is Required');
    }
    Navigator.pop(context);
  }
}
