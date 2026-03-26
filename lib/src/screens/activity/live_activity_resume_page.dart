import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:get/get.dart";
import "package:go_router/go_router.dart";
import "package:x_obese/src/screens/activity/controller/activity_controller.dart";
import "package:x_obese/src/theme/colors.dart";

class LiveActivityResumePage extends StatefulWidget {
  const LiveActivityResumePage({super.key});

  @override
  State<LiveActivityResumePage> createState() => _LiveActivityResumePageState();
}

class _LiveActivityResumePageState extends State<LiveActivityResumePage> {
  final ActivityController activityController = Get.put(ActivityController());

  @override
  void initState() {
    super.initState();
    _resumeActivity();
  }

  Future<void> _resumeActivity() async {
    // Ensure the persisted state is fully loaded
    await activityController.loadPersistedState();

    if (!mounted) return;

    if (activityController.isServiceRunning.value &&
        activityController.workoutType.value != null) {
      Position initialPosition;

      if (activityController.positionNodes.isNotEmpty) {
        initialPosition = activityController.positionNodes.last.position;
      } else {
        // Fallback to fetching current location if nodes are empty
        initialPosition = await Geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(accuracy: LocationAccuracy.high),
        );
      }

      if (mounted) {
        context.pushReplacement(
          "/live-activity",
          extra: {
            "workoutType": activityController.workoutType.value!,
            "initialLatLon": initialPosition,
          },
        );
      }
    } else {
      // If service is not running, redirect to home
      context.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
