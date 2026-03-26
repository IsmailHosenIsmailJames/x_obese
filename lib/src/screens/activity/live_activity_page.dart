import "dart:async";

import "package:dio/dio.dart" as dio;
import "package:fluentui_system_icons/fluentui_system_icons.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:gap/gap.dart";
import "package:geolocator/geolocator.dart" hide ActivityType;
import "package:get/get.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:permission_handler/permission_handler.dart";
import "package:wakelock_plus/wakelock_plus.dart";
import "package:x_obese/src/common_functions/common_functions.dart";
import "package:x_obese/src/core/common/functions/format_sec_to_time.dart";
import "package:x_obese/src/data/user_db.dart";
import "package:x_obese/src/screens/activity/controller/activity_controller.dart";
import "package:x_obese/src/screens/activity/controller/lock_controller.dart";
import "package:x_obese/src/screens/activity/models/activity_status.dart";
import "package:x_obese/src/screens/activity/models/position_nodes.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/marathon/details_marathon/model/full_marathon_data_model.dart";
import "package:x_obese/src/screens/marathon/models/marathon_user_model.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/app_bar.dart";
import "package:x_obese/src/widgets/back_button.dart";
import "package:x_obese/src/widgets/loading_popup.dart";
import "package:x_obese/src/widgets/popup_for_signup.dart";

import "models/activity_types.dart";

class LiveActivityPage extends StatefulWidget {
  final ActivityType workoutType;
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

  final ActivityController activityController = Get.put(ActivityController());
  final AllInfoController allInfoController = Get.put(AllInfoController());
  final LockController lockController = Get.put(LockController());

  @override
  void initState() {
    WakelockPlus.enable();

    // Animate camera when position updates
    ever(activityController.positionNodes, (List<PositionNodes> nodes) async {
      if (nodes.isNotEmpty && !activityController.isPaused.value) {
        final controller = await googleMapController.future;
        double lat = nodes.last.position.latitude;
        double long = nodes.last.position.longitude;
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, long), 19),
          duration: const Duration(milliseconds: 500),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await Permission.notification.isGranted &&
          await Permission.locationWhenInUse.isGranted) {
        // Start or resume workout via controller
        await activityController.startWorkout(widget.workoutType);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  bool showBackWarning = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !showBackWarning,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        showCancelAndBackPopup();
      },
      child: Scaffold(
        backgroundColor: MyAppColors.primary,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
                child: getAppBar(
                  backButton: getBackButton(context, () {
                    showCancelAndBackPopup();
                  }),
                  title: "${widget.workoutType.name.capitalizeFirst} Activity",
                  showLogo: true,
                ),
              ),
              Expanded(
                child: Obx(() {
                  final positionNodes = activityController.positionNodes;
                  final durationInSec = activityController.durationInSec;
                  final distance = activityController.totalDistance;
                  final calculatedSpeed = activityController.averageSpeed;
                  final lastActivityStatus = activityController.lastActivityStatus;

                  return Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            widget.initialLatLon.latitude,
                            widget.initialLatLon.longitude,
                          ),
                          zoom: 19,
                        ),
                        onMapCreated: (controller) {
                          googleMapController.complete(controller);
                        },
                        polylines: getPolylineFromLatLonList(
                          positionNodes
                              .map((e) => LatLng(e.position.latitude, e.position.longitude))
                              .toList(),
                        ),
                        zoomControlsEnabled: false,
                        markers: positionNodes.isNotEmpty
                            ? {
                                Marker(
                                  markerId: const MarkerId("end"),
                                  infoWindow: InfoWindow(
                                    title: "${widget.workoutType.name} ending point",
                                  ),
                                  position: LatLng(
                                    positionNodes.last.position.latitude,
                                    positionNodes.last.position.longitude,
                                  ),
                                ),
                              }
                            : {},
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
                                      distance >= 1000
                                          ? (distance / 1000).toStringAsFixed(2)
                                          : distance.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 3),
                                      child: Text(
                                        distance >= 1000 ? " KM" : " Meter",
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
                                _buildStatCard(
                                  context,
                                  icon: Icons.speed,
                                  value: "${calculatedSpeed.toStringAsFixed(2)} km/h",
                                  label: "Avg pace",
                                  iconColor: MyAppColors.second,
                                ),
                                _buildStatCard(
                                  context,
                                  icon: Icons.timer_outlined,
                                  value: formatSeconds(durationInSec),
                                  label: "Duration",
                                  iconColor: lastActivityStatus == ActivityStatus.stopped
                                      ? Colors.redAccent
                                      : MyAppColors.third,
                                  backgroundColor: lastActivityStatus == ActivityStatus.stopped
                                      ? const Color.fromARGB(255, 255, 235, 235)
                                      : const Color(0xffFAFAFA),
                                ),
                              ],
                            ),
                          ),
                          const Gap(10),
                          if (lastActivityStatus == ActivityStatus.stopped)
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xffFAFAFA),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "You stopped",
                                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          const Spacer(),
                          _buildControlPanel(context),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
    Color backgroundColor = const Color(0xffFAFAFA),
  }) {
    return Container(
      height: 90,
      width: ((MediaQuery.of(context).size.width - 70) / 2) - 10,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const Gap(5),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: MyAppColors.transparentGray),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(BuildContext context) {
    return GetX<LockController>(
      builder: (lock) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              if (lock.isLocked.value)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      style: IconButton.styleFrom(backgroundColor: MyAppColors.transparentGray),
                      onPressed: () => lock.isLocked.value = false,
                      icon: Icon(FluentIcons.lock_open_24_filled, color: MyAppColors.third),
                    ),
                  ),
                )
              else ...[
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: MyAppColors.transparentGray),
                  onPressed: () => lock.isLocked.value = true,
                  icon: Icon(FluentIcons.lock_closed_24_regular, color: MyAppColors.second),
                ),
                const Spacer(),
                Obx(() => IconButton(
                  style: IconButton.styleFrom(backgroundColor: MyAppColors.transparentGray),
                  onPressed: () => activityController.togglePause(),
                  icon: Icon(
                    activityController.isPaused.value ? Icons.play_arrow : Icons.pause,
                    color: activityController.isPaused.value ? Colors.blue : Colors.yellow.shade700,
                    size: 30,
                  ),
                )),
                const Spacer(),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: MyAppColors.transparentGray),
                  onPressed: () {
                    showBackWarning = false;
                    showSaveWorkoutPopupWithInfo(context);
                  },
                  icon: Icon(Icons.stop_rounded, size: 36, color: MyAppColors.third),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void showCancelAndBackPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit without saving!"),
        content: const Text("Are you sure that you want to exit workout without saving?"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Dialog
              await activityController.stopWorkout();
              if (mounted) Navigator.pop(context); // Page
            },
            child: const Text("Exit Workout", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showBackWarning = true;
            },
            child: const Text("Continue Workout", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void showSaveWorkoutPopupWithInfo(BuildContext context) {
    if (UserDB.userAllInfo()?.isGuest ?? true) {
      showSignupPopup(context);
    } else {
      showDialog(
        context: context,
        builder: (dialogContext) => Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Are you sure?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500)),
                const Gap(20),
                _buildSummaryRow("Distance:", "${(activityController.totalDistance / 1000).toStringAsFixed(2)} km"),
                _buildSummaryRow("Duration:", "${formatSeconds(activityController.durationInSec)} Minutes"),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text("Continue"),
                    ),
                    const Gap(10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: MyAppColors.third, foregroundColor: Colors.white),
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await saveWorkout(context);
                      },
                      icon: const Icon(Icons.done),
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
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Gap(10),
          Text(value),
        ],
      ),
    );
  }

  Future<void> saveWorkout(BuildContext context) async {
    if (await checkConnectivity() == false) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("No internet Connection!"),
          content: const Text("Please check your internet connection to save data."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
      return;
    }

    showLoadingPopUp(context, loadingText: "Saving...");

    try {
      dio.Response? response;
      if (widget.marathonUserModel != null) {
        response = await activityController.saveMarathonUserActivity(
          {
            "distanceKm": (activityController.totalDistance / 1000).toString(),
            "durationMs": (activityController.durationInSec * 1000),
          },
          activityController.totalSteps,
          widget.marathonData?.data?.marathonUserId ?? "",
        );
      }
      
      var res = await activityController.saveActivity({
        "distanceKm": activityController.totalDistance / 1000,
        "type": widget.workoutType.name,
        "durationMs": (activityController.durationInSec * 1000),
        "steps": activityController.totalSteps,
      }, activityController.totalSteps);

      allInfoController.dataAsync();
      if (res != null) response = res;

      if (!mounted) return;
      Navigator.pop(context); // Pop loading

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        Fluttertoast.showToast(msg: "Saved successfully");
        await activityController.stopWorkout();
        if (mounted) Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: "Unable to save, try again");
      }
    } on dio.DioException catch (_) {
      if (mounted) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "An error occurred while saving.");
      }
    }
  }

  Set<Polyline> getPolylineFromLatLonList(List<LatLng> latLonList) {
    return {
      Polyline(
        polylineId: const PolylineId("Workout Paths"),
        points: latLonList,
        color: MyAppColors.second,
        width: 5,
      ),
    };
  }
}
