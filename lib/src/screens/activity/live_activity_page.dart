import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:x_obese/src/apis/middleware/jwt_middleware.dart';
import 'package:x_obese/src/core/common/functions/calculate_distance.dart'
    as workout_calculator;
import 'package:x_obese/src/core/common/functions/format_sec_to_time.dart';
import 'package:x_obese/src/screens/activity/controller/activity_controller.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/widgets/back_button.dart';
import 'package:x_obese/src/widgets/loading_popup.dart';

class LiveActivityPage extends StatefulWidget {
  final workout_calculator.ActivityType workoutType;
  final LatLng initialLatLon;
  const LiveActivityPage({
    super.key,
    required this.workoutType,
    required this.initialLatLon,
  });

  @override
  State<LiveActivityPage> createState() => _LiveActivityPageState();
}

class _LiveActivityPageState extends State<LiveActivityPage> {
  bool isPaused = false;
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  double distanceEveryPaused = 0;
  List<Position> latLonOfPositions = [];
  int workoutDurationSec = 1;
  late Map<String, Marker> markersSet = {
    'start': Marker(
      markerId: const MarkerId('start'),
      infoWindow: InfoWindow(title: '${widget.workoutType} Starting point'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: widget.initialLatLon,
    ),
  };

  late StreamSubscription streamSubscription;

  @override
  void initState() {
    streamSubscription = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
    ).listen((event) async {
      log(event.accuracy.toString());
      if (!isPaused) {
        latLonOfPositions.add(event);
        markersSet['end'] = Marker(
          markerId: const MarkerId('end'),
          infoWindow: const InfoWindow(title: 'Your position'),
          position: LatLng(event.latitude, event.longitude),
        );
        final controller = await googleMapController.future;
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(event.latitude, event.longitude),
            16.5,
          ),
        );
      } else {
        if (latLonOfPositions.isNotEmpty) {
          distanceEveryPaused +=
              workout_calculator.WorkoutCalculator(
                rawPositions: latLonOfPositions,
                activityType: widget.workoutType,
              ).processData().totalDistance;
          latLonOfPositions = [];
        }
      }
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPaused == false) {
        workoutDurationSec++;
        if (!isDispose) setState(() {});
      }
    });
    super.initState();
  }

  bool isDispose = false;
  @override
  void dispose() {
    streamSubscription.cancel();
    isDispose = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    workout_calculator.WorkoutCalculationResult workoutCalculationResult =
        workout_calculator.WorkoutCalculator(
          rawPositions: latLonOfPositions,
          activityType: widget.workoutType,
        ).processData();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 10,
                bottom: 0,
                right: 20,
              ),
              child: Row(
                children: [
                  getBackbutton(context, () {
                    Get.back();
                  }),
                  const Gap(70),
                  const Text(
                    'Workout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: widget.initialLatLon,
                      zoom: 16.5,
                    ),

                    onMapCreated: (controller) {
                      googleMapController.complete(controller);
                    },
                    polylines: getPolylineFromLatLonList(
                      workoutCalculationResult.filteredPath,
                    ),
                    zoomControlsEnabled: false,
                    markers: markersSet.values.toSet(),
                  ),
                  Column(
                    children: [
                      const Gap(12),
                      Container(
                        height: 100,
                        width: double.infinity,

                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(left: 20, right: 20),
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
                                  (distanceEveryPaused +
                                          workoutCalculationResult
                                                  .totalDistance /
                                              1000)
                                      .toPrecision(2)
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    ' km',
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
                      const Gap(20),
                      Container(
                        height: 110,
                        width: double.infinity,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 90,
                              width:
                                  ((MediaQuery.of(context).size.width - 70) /
                                      2) -
                                  10,
                              decoration: BoxDecoration(
                                color: const Color(0xffFAFAFA),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: MyAppColors.second,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: SvgPicture.string(
                                      '''<svg xmlns="http://www.w3.org/2000/svg" width="10" height="11" viewBox="0 0 10 11" fill="none">
                                    <path d="M2.36328 1.83777L0.878906 1.83777C0.716973 1.83777 0.585938 1.9688 0.585938 2.13074C0.585938 2.29267 0.716973 2.4237 0.878906 2.4237L2.36328 2.4237C2.52521 2.4237 2.65625 2.29267 2.65625 2.13074C2.65625 1.9688 2.52521 1.83777 2.36328 1.83777ZM2.36328 4.18152L0.878906 4.18152C0.716973 4.18152 0.585938 4.31255 0.585938 4.47449C0.585938 4.63642 0.716973 4.76745 0.878906 4.76745L2.36328 4.76745C2.52521 4.76745 2.65625 4.63642 2.65625 4.47449C2.65625 4.31255 2.52521 4.18152 2.36328 4.18152ZM1.77734 3.00964L0.292969 3.00964C0.131035 3.00964 0 3.14068 0 3.30261C0 3.46454 0.131035 3.59558 0.292969 3.59558L1.77734 3.59558C1.93928 3.59558 2.07031 3.46454 2.07031 3.30261C2.07031 3.14068 1.93928 3.00964 1.77734 3.00964ZM9.41406 4.47449L7.63672 4.47449L7.63672 3.30261C7.63672 2.78804 7.00725 2.5171 6.63633 2.88851L4.29275 5.23208C4.06387 5.46097 4.06387 5.83175 4.29275 6.06064L5.63629 7.40417L3.99979 9.04068C3.7709 9.26956 3.7709 9.64035 3.99979 9.86923C4.22865 10.0981 4.59945 10.0981 4.82834 9.86923L6.87912 7.81845C7.10801 7.58956 7.10801 7.21878 6.87912 6.9899L5.53559 5.64636L6.46484 4.7171L6.46484 5.06042C6.46484 5.384 6.72721 5.64636 7.05078 5.64636L9.41406 5.64636C9.73764 5.64636 10 5.384 10 5.06042C10 4.73685 9.73764 4.47449 9.41406 4.47449ZM5.47148 1.49675C5.23859 1.34197 4.92961 1.37259 4.73219 1.56999L3.12086 3.18132C2.89197 3.41021 2.89197 3.78099 3.12086 4.00988C3.34975 4.23876 3.72055 4.23874 3.94943 4.00986L5.22115 2.73814L5.64955 3.04673L6.22193 2.47435C6.31768 2.37861 6.43061 2.30429 6.5541 2.24626L5.47148 1.49675Z" fill="white"/>
                                    <path d="M3.87848 6.47504C3.73002 6.32658 3.63092 6.14387 3.57868 5.94629L0.484165 9.0408C0.255278 9.26969 0.255278 9.64047 0.484165 9.86936C0.713032 10.0982 1.08383 10.0982 1.31272 9.86936L4.29276 6.88932L3.87848 6.47504Z" fill="white"/>
                                    <path d="M7.92969 2.7168C8.41509 2.7168 8.80859 2.3233 8.80859 1.83789C8.80859 1.35248 8.41509 0.958984 7.92969 0.958984C7.44428 0.958984 7.05078 1.35248 7.05078 1.83789C7.05078 2.3233 7.44428 2.7168 7.92969 2.7168Z" fill="white"/>
                                  </svg>''',
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(
                                    '${(workoutCalculationResult.averageSpeed * 3.6).toPrecision(2)} km/h',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Avg pace',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: MyAppColors.mutedGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 90,
                              width:
                                  ((MediaQuery.of(context).size.width - 70) /
                                      2) -
                                  10,

                              decoration: BoxDecoration(
                                color: const Color(0xffFAFAFA),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 25,
                                    width: 25,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: MyAppColors.third,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: SvgPicture.string(
                                      '''<svg xmlns="http://www.w3.org/2000/svg" width="12" height="11" viewBox="0 0 12 11" fill="none">
                              <path d="M6 3.5V6L7.5 7M8.40171 0.5C9.46349 0.964305 10.3649 1.72706 11 2.6822M1 2.6822C1.63506 1.72706 2.53651 0.964305 3.59829 0.5M10.5 10.5L9.37856 9M1.5 10.5L2.62136 9M10.5 6C10.5 8.48528 8.48528 10.5 6 10.5C3.51472 10.5 1.5 8.48528 1.5 6C1.5 3.51472 3.51472 1.5 6 1.5C8.48528 1.5 10.5 3.51472 10.5 6Z" stroke="white" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>''',
                                    ),
                                  ),
                                  const Gap(5),
                                  Text(
                                    formatSeconds(workoutDurationSec),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'Duration',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: MyAppColors.mutedGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
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
                                    backgroundColor:
                                        MyAppColors.transparentGray,
                                  ),
                                  onPressed: () {},
                                  icon: SvgPicture.string(
                                    '''<svg xmlns="http://www.w3.org/2000/svg" width="27" height="29" viewBox="0 0 27 29" fill="none">
                              <path fill-rule="evenodd" clip-rule="evenodd" d="M17.4081 9.95593C18.5825 8.55089 20.1665 6.34482 20.1665 4.66675C20.1665 2.00008 18.3756 0.666748 16.1665 0.666748C13.9574 0.666748 12.1665 2.00008 12.1665 4.9456C12.1665 6.75874 13.6822 8.76013 14.8475 10.031C15.5549 10.8023 16.7369 10.7589 17.4081 9.95593ZM16.1665 6.00008C16.9029 6.00008 17.4998 5.40313 17.4998 4.66675C17.4998 3.93037 16.9029 3.33341 16.1665 3.33341C15.4301 3.33341 14.8332 3.93037 14.8332 4.66675C14.8332 5.40313 15.4301 6.00008 16.1665 6.00008ZM5.49984 27.3334C8.1665 27.3334 10.8332 22.2789 10.8332 19.3334C10.8332 16.3879 8.44536 14.0001 5.49984 14.0001C2.55432 14.0001 0.166504 16.3879 0.166504 19.3334C0.166504 22.2789 2.83317 27.3334 5.49984 27.3334ZM5.49984 21.3334C6.60441 21.3334 7.49984 20.438 7.49984 19.3334C7.49984 18.2288 6.60441 17.3334 5.49984 17.3334C4.39527 17.3334 3.49984 18.2288 3.49984 19.3334C3.49984 20.438 4.39527 21.3334 5.49984 21.3334ZM17.1665 12.6667C17.1665 12.1145 16.7188 11.6667 16.1665 11.6667C15.6142 11.6667 15.1665 12.1145 15.1665 12.6667V15.3334C15.1665 18.0948 17.4051 20.3334 20.1665 20.3334H21.4998C23.1567 20.3334 24.4998 21.6766 24.4998 23.3334C24.4998 24.9903 23.1567 26.3334 21.4998 26.3334H10.8332C10.2809 26.3334 9.83317 26.7811 9.83317 27.3334C9.83317 27.8857 10.2809 28.3334 10.8332 28.3334H21.4998C24.2613 28.3334 26.4998 26.0948 26.4998 23.3334C26.4998 20.572 24.2613 18.3334 21.4998 18.3334H20.1665C18.5097 18.3334 17.1665 16.9903 17.1665 15.3334V12.6667Z" fill="#047CEC"/>
                            </svg>''',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        MyAppColors.transparentGray,
                                  ),
                                  onPressed: () {
                                    log('message');
                                    setState(() {
                                      isPaused = !isPaused;
                                    });
                                  },
                                  icon: SvgPicture.string(
                                    isPaused
                                        ? '''<svg width="33" height="32" viewBox="0 0 33 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M24.1278 17.7363L11.4923 24.9566C10.159 25.7185 8.5 24.7558 8.5 23.2201V15.9998V8.77953C8.5 7.24389 10.159 6.28115 11.4923 7.04305L24.1278 14.2634C25.4714 15.0311 25.4714 16.9685 24.1278 17.7363Z" fill="#047CEC"/>
</svg>
'''
                                        : '''<svg xmlns="http://www.w3.org/2000/svg" width="23" height="20" viewBox="0 0 23 20" fill="none">
                                <path fill-rule="evenodd" clip-rule="evenodd" d="M2.83301 0.666748C1.72844 0.666748 0.833008 1.56218 0.833008 2.66675V17.3334C0.833008 18.438 1.72844 19.3334 2.83301 19.3334H6.83301C7.93758 19.3334 8.83301 18.438 8.83301 17.3334V2.66675C8.83301 1.56218 7.93758 0.666748 6.83301 0.666748H2.83301ZM16.1663 0.666748C15.0618 0.666748 14.1663 1.56218 14.1663 2.66675V17.3334C14.1663 18.438 15.0618 19.3334 16.1663 19.3334H20.1663C21.2709 19.3334 22.1663 18.438 22.1663 17.3334V2.66675C22.1663 1.56218 21.2709 0.666748 20.1663 0.666748H16.1663Z" fill="#FFDE1A"/>
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
                                    backgroundColor:
                                        MyAppColors.transparentGray,
                                  ),
                                  onPressed: () async {
                                    showLoadingPopUp(
                                      context,
                                      loadingText: 'Saving...',
                                    );

                                    // make a api call
                                    final activityController = Get.put(
                                      ActivityController(),
                                    );
                                    try {
                                      final response = await activityController
                                          .saveActivity({
                                            'distance':
                                                (distanceEveryPaused +
                                                    workoutCalculationResult
                                                        .totalDistance) /
                                                1000,
                                            'type':
                                                widget.workoutType.toString(),
                                            'duration':
                                                workoutDurationSec * 1000,
                                            // "steps": 1000, // optional
                                          });
                                      Navigator.pop(context);
                                      if (response != null) {
                                        Fluttertoast.showToast(
                                          msg: 'Saved successfully',
                                        );
                                        Get.back();
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: 'Unable to save, try again',
                                        );
                                      }
                                    } on DioException catch (e) {
                                      printResponse(e.response!);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.stop_rounded,
                                    size: 36,
                                    color: MyAppColors.third,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Set<Polyline> getPolylineFromLatLonList(List<LatLng> latLonList) {
    Set<Polyline> polyline = {};
    polyline.add(
      Polyline(
        polylineId: const PolylineId('Workout Paths'),
        points: latLonList,
        color: MyAppColors.second,
        width: 5,
      ),
    );

    return polyline;
  }
}
