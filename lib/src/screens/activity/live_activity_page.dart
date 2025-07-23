import "dart:async";
import "dart:convert";
import "dart:developer";

import "package:dio/dio.dart" as dio;
import "package:dio/dio.dart";
import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:flutter_svg/svg.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:geolocator/geolocator.dart";
import "package:get/get.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:permission_handler/permission_handler.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:wakelock_plus/wakelock_plus.dart";
import "package:x_obese/src/apis/middleware/jwt_middleware.dart";
import "package:x_obese/src/common_functions/common_functions.dart";
import "package:x_obese/src/core/common/functions/calculate_distance.dart"
    as workout_calculator;
import "package:x_obese/src/core/common/functions/calculate_distance.dart";
import "package:x_obese/src/core/common/functions/format_sec_to_time.dart";
import "package:x_obese/src/core/permissions/permission.dart";
import "package:x_obese/src/screens/activity/controller/activity_controller.dart";
import "package:x_obese/src/screens/activity/controller/lock_controller.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/marathon/details_marathon/model/full_marathon_data_model.dart";
import "package:x_obese/src/screens/marathon/models/marathon_user_model.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";
import "package:x_obese/src/widgets/loading_popup.dart";

import "foreground/foreground_exercise_service.dart";

class LiveActivityPage extends StatefulWidget {
  final workout_calculator.ActivityType workoutType;
  final MarathonUserModel? marathonUserModel;
  final FullMarathonDataModel? marathonData;
  final Position initialLatLon;

  const LiveActivityPage({
    super.key,
    required this.workoutType,
    required this.initialLatLon,
    this.marathonUserModel,
    this.marathonData,
  });

  @override
  State<LiveActivityPage> createState() => _LiveActivityPageState();
}

class _LiveActivityPageState extends State<LiveActivityPage> {
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  double distanceEveryPaused = 0;
  late List<Position> latLonOfPositions = [widget.initialLatLon];
  int workoutDurationSec = 1;
  bool isPaused = false;
  late AllInfoController controller;

  late StreamSubscription streamSubscription;

  @override
  void initState() {
    WakelockPlus.enable();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Request permissions and initialize the service.
      await requestPermissions();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.reload();

      String? previousWorkoutType = sharedPreferences.getString("workout_type");
      if (previousWorkoutType != widget.workoutType.name) {
        await dismissWorkout();
      }

      latLonOfPositions =
          (sharedPreferences.getStringList("geolocationHistory") ?? [])
              .map((e) => Position.fromMap(jsonDecode(e)))
              .toList();

      if (latLonOfPositions.isNotEmpty) {
        workoutDurationSec =
            latLonOfPositions.first.timestamp
                .difference(latLonOfPositions.last.timestamp)
                .inSeconds
                .abs();
      } else {
        latLonOfPositions = [widget.initialLatLon];
      }
      await sharedPreferences.setString(
        "workout_type",
        widget.workoutType.name,
      );
      _initService();
      if (await Permission.notification.isGranted &&
          await Permission.locationWhenInUse.isGranted) {
        await _startService();
      }
    });
    streamSubscription = Stream.periodic(const Duration(seconds: 5), (
      computationCount,
    ) {
      return DateTime.now();
    }).listen((event) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.reload();
      isPaused = sharedPreferences.getBool("isPaused") ?? false;
      if (!isPaused) {
        latLonOfPositions =
            (sharedPreferences.getStringList("geolocationHistory") ?? [])
                .map((e) => Position.fromMap(jsonDecode(e)))
                .toList();

        log(
          latLonOfPositions.length.toString(),
          name: "onPage-> latLonOfPositions",
        );

        if (latLonOfPositions.isEmpty) {
          latLonOfPositions = [widget.initialLatLon];
        }

        final controller = await googleMapController.future;
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(
              latLonOfPositions.last.latitude,
              latLonOfPositions.last.longitude,
            ),
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
          sharedPreferences.setStringList("geolocationHistory", []);
        }
      }
      if (!isDispose) setState(() {});
    });

    Timer.periodic(const Duration(seconds: 1), (timer) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.reload();

      isPaused = sharedPreferences.getBool("isPaused") ?? false;

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
    WakelockPlus.disable();
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.dispose();
  }

  AllInfoController allInfoController = Get.find();

  LockController lockController = Get.put(LockController());

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceTypes: [ForegroundServiceTypes.health],
        serviceId: 256,
        notificationTitle: "Your Workout is running",
        notificationText: "Tap to open the app",
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(
            id: "dismiss_workout",
            text: "Dismiss it",
            textColor: Colors.red,
          ),
        ],
        notificationInitialRoute: "/workout",
        callback: startCallback,
      );
    }
  }

  void _initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: "foreground_service_workout",
        channelName: "Workout is running",
        channelDescription:
            "This notification appears when the workout is running.",
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  void _onReceiveTaskData(Object data) {
    if (data is Map<String, dynamic>) {
      final dynamic timestampMillis = data["timestampMillis"];
      if (timestampMillis != null) {
        final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
          timestampMillis,
          isUtc: true,
        );
        print("timestamp: ${timestamp.toString()}");
      }
    }
  }

  bool showBackWarning = true;

  @override
  Widget build(BuildContext context) {
    workout_calculator.WorkoutCalculationResult workoutCalculationResult =
        workout_calculator.WorkoutCalculator(
          rawPositions: latLonOfPositions,
          activityType: widget.workoutType,
        ).processData();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        await Future.delayed(const Duration(milliseconds: 200));
        if (showBackWarning) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text(
                    "Are you sure?",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: const Text(
                    "Are you sure you want to cancel the workout?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        dismissWorkout();
                      },
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
          );
        }
      },
      child: Scaffold(
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
                    getBackButton(context, () {
                      showBackWarning = false;
                      showCancelAndBackPopup();
                    }),
                    const Gap(70),
                    const Text(
                      "Workout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          widget.initialLatLon.latitude,
                          widget.initialLatLon.longitude,
                        ),
                        zoom: 16.5,
                      ),

                      onMapCreated: (controller) {
                        googleMapController.complete(controller);
                      },
                      polylines: getPolylineFromLatLonList(
                        workoutCalculationResult.filteredPath,
                      ),
                      zoomControlsEnabled: false,
                      markers: {
                        Marker(
                          markerId: const MarkerId("start"),
                          infoWindow: InfoWindow(
                            title: "${widget.workoutType} Starting point",
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue,
                          ),
                          position: LatLng(
                            latLonOfPositions.first.latitude,
                            latLonOfPositions.first.longitude,
                          ),
                        ),
                        Marker(
                          markerId: const MarkerId("start"),
                          infoWindow: InfoWindow(
                            title: "${widget.workoutType} Starting point",
                          ),
                          position: LatLng(
                            latLonOfPositions.last.latitude,
                            latLonOfPositions.last.longitude,
                          ),
                        ),
                      },
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
                                      " km",
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
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
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
                                      "${((latLonOfPositions.last.speed == 0.0 ? workoutCalculationResult.averageSpeed : latLonOfPositions.last.speed) * 3.6).toPrecision(2)} km/h",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      "Avg pace",
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
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
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
                                      "Duration",
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

                        GetX<LockController>(
                          builder:
                              (controller) => Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  height: 80,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,

                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Row(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        decoration: BoxDecoration(
                                          color: MyAppColors.transparentGray
                                              .withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                        height: 60,
                                        width:
                                            controller.isLocked.value
                                                ? (MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.9) -
                                                    20
                                                : 0,
                                        alignment: Alignment.centerRight,
                                        child:
                                            controller.isLocked.value
                                                ? SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: IconButton(
                                                    style: IconButton.styleFrom(
                                                      backgroundColor:
                                                          MyAppColors
                                                              .transparentGray,
                                                    ),
                                                    onPressed: () {
                                                      controller
                                                          .isLocked
                                                          .value = false;
                                                    },
                                                    icon: Icon(
                                                      FluentIcons
                                                          .lock_open_24_filled,
                                                      size: 30,
                                                      color: MyAppColors.third,
                                                    ),
                                                  ),
                                                )
                                                : null,
                                      ),

                                      if (!controller.isLocked.value)
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: IconButton(
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  MyAppColors.transparentGray,
                                            ),
                                            onPressed: () {
                                              controller.isLocked.value = true;
                                            },
                                            icon: SvgPicture.string(
                                              '''<svg xmlns="http://www.w3.org/2000/svg" width="23" height="28" viewBox="0 0 23 28" fill="none">
                          <path fill-rule="evenodd" clip-rule="evenodd" d="M7.16683 7.00008C7.16683 4.60685 9.10693 2.66675 11.5002 2.66675C13.8934 2.66675 15.8335 4.60685 15.8335 7.00008V8.66675H7.16683V7.00008ZM5.16683 8.76034V7.00008C5.16683 3.50228 8.00236 0.666748 11.5002 0.666748C14.998 0.666748 17.8335 3.50228 17.8335 7.00008V8.76034C20.301 9.22842 22.1668 11.3964 22.1668 14.0001V22.0001C22.1668 24.9456 19.779 27.3334 16.8335 27.3334H6.16683C3.22131 27.3334 0.833496 24.9456 0.833496 22.0001V14.0001C0.833496 11.3964 2.6993 9.22842 5.16683 8.76034ZM14.1668 18.0001C14.1668 19.4728 12.9729 20.6667 11.5002 20.6667C10.0274 20.6667 8.8335 19.4728 8.8335 18.0001C8.8335 16.5273 10.0274 15.3334 11.5002 15.3334C12.9729 15.3334 14.1668 16.5273 14.1668 18.0001Z" fill="#047CEC"/>
                        </svg>''',
                                            ),
                                          ),
                                        ),
                                      if (!controller.isLocked.value)
                                        const Spacer(),

                                      if (!controller.isLocked.value)
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: IconButton(
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  MyAppColors.transparentGray,
                                            ),
                                            onPressed: () async {
                                              isPaused = !isPaused;

                                              SharedPreferences
                                              sharedPreferences =
                                                  await SharedPreferences.getInstance();
                                              await sharedPreferences.reload();

                                              await sharedPreferences.setBool(
                                                "isPaused",
                                                isPaused,
                                              );
                                              setState(() {});
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
                                      if (!controller.isLocked.value)
                                        const Spacer(),

                                      if (!controller.isLocked.value)
                                        SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: IconButton(
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  MyAppColors.transparentGray,
                                            ),
                                            onPressed: () {
                                              showBackWarning = false;
                                              showSaveWorkoutPopupWithInfo(
                                                context,
                                                workoutCalculationResult,
                                              );
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
                        ),
                      ],
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

  void showCancelAndBackPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Exit without saving!"),
          content: const Text(
            "Are you sure that you want to exit workout without saving?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                dismissWorkout();
              },
              child: const Text(
                "Exit Workout",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showBackWarning = true;
              },
              child: const Text(
                "Continue Workout",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void showSaveWorkoutPopupWithInfo(
    BuildContext context,
    WorkoutCalculationResult workoutCalculationResult,
  ) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => Dialog(
            insetPadding: const EdgeInsets.all(10),

            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Are you sure?",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      const Text(
                        "Distance:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Gap(10),
                      Text(
                        "${((distanceEveryPaused + workoutCalculationResult.totalDistance) / 1000).toStringAsFixed(2)} km",
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Duration:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Gap(10),
                      Text("${formatSeconds(workoutDurationSec)} Minutes"),
                    ],
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyAppColors.transparentGray,
                        ),
                        onPressed: () {
                          showBackWarning = false;
                          Navigator.pop(dialogContext);
                        },
                        icon: const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.green,
                        ),
                        label: const Text("Continue"),
                      ),
                      const Gap(20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyAppColors.transparentGray,
                        ),
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          await saveWorkout(context, workoutCalculationResult);
                          await dismissWorkout();
                        },
                        icon: const Icon(Icons.done, color: Colors.green),
                        label: const Text("Save Now"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> saveWorkout(
    BuildContext context,
    workout_calculator.WorkoutCalculationResult workoutCalculationResult,
  ) async {
    if (!mounted) return;
    if (await checkConnectivity() == false) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              title: const Text("No internet Connection!"),
              content: const Text(
                "To save the data to the server, we required internet connection. Please check your internet connection.",
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyAppColors.third,
                    foregroundColor: MyAppColors.primary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    saveWorkout(context, workoutCalculationResult);
                  },
                  child: const Text("Try Again"),
                ),
              ],
            ),
      );
      return;
    }

    showLoadingPopUp(context, loadingText: "Saving...");

    // make a api call
    final activityController = Get.put(ActivityController());
    try {
      dio.Response? response;

      if (widget.marathonUserModel != null) {
        var res = await activityController.saveMarathonUserActivity({
          "distanceKm":
              ((distanceEveryPaused + workoutCalculationResult.totalDistance) /
                      1000)
                  .toString(),
          "durationMs": workoutDurationSec * 1000,
        }, widget.marathonData!.data!.marathonUserId!);
        if (res != null) response = res;
      }
      var res = await activityController.saveActivity({
        "distanceKm":
            (distanceEveryPaused + workoutCalculationResult.totalDistance) /
            1000,
        "type": widget.workoutType.toString(),
        "durationMs": workoutDurationSec * 1000,
        // "steps": 1000, // optional
      });

      allInfoController.dataAsync();

      if (res != null) response = res;

      if (!mounted) return;
      Navigator.pop(context); // Pop loading

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        Fluttertoast.showToast(msg: "Saved successfully");
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        Fluttertoast.showToast(msg: "Unable to save, try again");
      }
    } on DioException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "An error occurred while saving.");
      }
      printResponse(e.response!);
    }
  }

  Set<Polyline> getPolylineFromLatLonList(List<LatLng> latLonList) {
    Set<Polyline> polyline = {};
    polyline.add(
      Polyline(
        polylineId: const PolylineId("Workout Paths"),
        points: latLonList,
        color: MyAppColors.second,
        width: 5,
      ),
    );

    return polyline;
  }
}
