import "dart:async";
import "dart:developer";
import "dart:io";

import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_svg/svg.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:health/health.dart";
import "package:x_obese/src/core/health/my_health_functions.dart";
import "package:x_obese/src/core/health/util.dart";
import "package:x_obese/src/resources/svg_string.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/theme/colors.dart";

class PointsOverviewWidget extends StatefulWidget {
  const PointsOverviewWidget({super.key});

  @override
  State<PointsOverviewWidget> createState() => _PointsOverviewWidgetState();
}

class _PointsOverviewWidgetState extends State<PointsOverviewWidget> {
  AllInfoController controller = Get.find();

  @override
  void initState() {
    initCall();
    super.initState();
  }

  HealthConnectSdkStatus? sdkStatus;
  bool initCallFinished = false;
  AppState? appState;
  StreamSubscription? streamSubscription;

  Future<void> initCall() async {
    await MyHealthFunctions.init();
    sdkStatus = await MyHealthFunctions.getSdkConfigurationStatus();

    if (sdkStatus == HealthConnectSdkStatus.sdkAvailable) {
      appState =
          await MyHealthFunctions.hasPermissions()
              ? AppState.AUTHORIZED
              : AppState.AUTH_NOT_GRANTED;
      log(appState.toString(), name: "App State on InIt");
    }
    if (appState == AppState.AUTHORIZED) await fetchData();
    streamSubscription = Stream.periodic(const Duration(minutes: 1)).listen((
      event,
    ) {
      if (appState == AppState.AUTHORIZED) fetchData();
    });

    initCallFinished = true;
    setState(() {});
  }

  Future<void> fetchData() async {
    DateTime now = DateTime.now();
    int? steps = await MyHealthFunctions.fetchSteps(
      DateTime(now.year, now.month, now.day),
      now,
    );
    if (steps != null) {
      controller.stepsCount.value = steps;
      log(steps.toString(), name: "Steps");
    }

    // double calories = await MyHealthFunctions.fetchCalories(
    //   DateTime(now.year, now.month, now.day),
    //   now,
    // );
    // controller.workStatus.value.calories = calories.toString();
    // log(calories.toString(), name: "Calories");

    // int heartPoints = await MyHealthFunctions.fetchHeartPoints(
    //   // this week
    //   DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7)),
    //   now,
    // );
    // controller.workStatus.value.heartPts = heartPoints.toString();

    // log(heartPoints.toString(), name: "Heart Points");

    // int workoutTime = await MyHealthFunctions.fetchWorkoutTime(
    //   DateTime(now.year, now.month, now.day),
    //   now,
    // );
    // controller.workStatus.value.durationMs = workoutTime * 60000;
    // log(workoutTime.toString(), name: "Workout Time");
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initCallFinished
        ? sdkStatus == HealthConnectSdkStatus.sdkAvailable
            ? appState == AppState.AUTHORIZED
                ? Column(
                  children: [
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MyAppColors.cardsBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 134,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: MyAppColors.primary,
                                      child: Obx(
                                        () => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              controller.selectedPoints.value
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              controller.selectedCategory.value,
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: MyAppColors.mutedGray,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Obx(() => getPieChart(controller)),
                                ],
                              ),
                            ),
                          ),
                          const Gap(8),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: MyAppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Obx(
                                    () => getPointsWidget(
                                      context: context,
                                      svg: stepsIconRed,
                                      title: "Steps",
                                      points:
                                          controller.stepsCount.value
                                              .toString(),
                                      target: "6000",
                                    ),
                                  ),
                                ),
                                const Gap(6),

                                Container(
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: MyAppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Obx(
                                    () => getPointsWidget(
                                      context: context,
                                      svg: calorieIconBlue,
                                      title: "Calories",
                                      points:
                                          controller.workStatus.value.calories
                                              ?.toString() ??
                                          "0",
                                      target:
                                          controller.getWorkoutPlansList.isNotEmpty ?
                                          (controller
                                                      .getWorkoutPlansList
                                                      .first
                                                      .caloriesGoal ??
                                                  0)
                                              .abs() : 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MyAppColors.cardsBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: MyAppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Obx(
                                () => getPointsWidget(
                                  context: context,
                                  svg: heartIconSVGYellow,
                                  title: "Heart Points",
                                  points: double.parse(
                                    controller.workStatus.value.heartPts ?? "0",
                                  ).toStringAsFixed(2),
                                ),
                              ),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: MyAppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Obx(
                                () => getPointsWidget(
                                  context: context,
                                  svg: workOutIconSVGGreen,
                                  title: "Workout Time",
                                  points:
                                      controller.workStatus.value.durationMs
                                          ?.toStringAsFixed(2) ??
                                      "0",
                                  target:
                                      controller.getWorkoutPlansList.isNotEmpty ?
                                      (int.parse(
                                            "${(controller.getWorkoutPlansList.first.workoutTimeMs ?? 0)}",
                                          ).abs() /
                                          60000) : 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: MyAppColors.cardsBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Data Read from ${Platform.isAndroid ? "Google Health Connect" : "Apple Health"} is not Granted. To Grant it, click the button below.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyAppColors.second,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text("Grant Permissions"),
                        onPressed: () async {
                          AppState appState =
                              await MyHealthFunctions.authorizePermissions();
                          log(appState.toString(), name: "AppState");
                        },
                      ),
                    ],
                  ),
                )
            : Container(
              height: 200,
              decoration: BoxDecoration(
                color: MyAppColors.cardsBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "${Platform.isAndroid ? "Google Health Connect" : "Apple Health"} is not available. You need to install it first. Click the button below.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyAppColors.second,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Install ${Platform.isAndroid ? "Google Health Connect" : "Apple Health"}",
                    ),
                    onPressed: () async {
                      await MyHealthFunctions.installHealthConnect();
                    },
                  ),
                ],
              ),
            )
        : Container(
              height: 200,
              decoration: BoxDecoration(
                color: MyAppColors.cardsBackground,
                borderRadius: BorderRadius.circular(8),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF));
  }

  PieChart getPieChart(AllInfoController controller) {
    double targetCalBran = 1.0;
    if (controller.getWorkoutPlansList.isNotEmpty) {
      targetCalBran =
          controller.getWorkoutPlansList.value.first.caloriesGoal
              ?.toDouble()
              .abs() ??
              1.0;
    }

    if (!(targetCalBran > 0)) targetCalBran = 1;

    double targetWorkout = 1.0;
    if (controller.getWorkoutPlansList.isNotEmpty) {
      targetWorkout = double.parse(
        controller.getWorkoutPlansList.value.first.workoutTimeMs ?? "0",
      );
    }
    targetWorkout /= 60000;
    if (!(targetWorkout > 0)) targetWorkout = 1;

    double targetHartPoints = 50;

    return PieChart(
      PieChartData(
        startDegreeOffset: 180,
        sectionsSpace: 3,

        pieTouchData: PieTouchData(
          touchCallback: (p0, p1) {
            final touchedSection = p1?.touchedSection?.touchedSection;
            if (touchedSection != null) {
              log(touchedSection.title.toString());
              if (touchedSection.title.toString() == "Steps") {
                controller.selectedPoints.value =
                    controller.stepsCount.value.toDouble();
                controller.selectedCategory.value =
                    touchedSection.title.toString();
              } else if (touchedSection.title.toString() == "Heart Points") {
                controller.selectedPoints.value = double.parse(
                  controller.workStatus.value.heartPts ?? "0",
                ).toPrecision(2);
                controller.selectedCategory.value =
                    touchedSection.title.toString();
              } else if (touchedSection.title.toString() == "Calories") {
                controller.selectedPoints.value = double.parse(
                  controller.workStatus.value.calories ?? "0",
                ).toPrecision(2);
                controller.selectedCategory.value =
                    touchedSection.title.toString();
              } else if (touchedSection.title.toString() == "Duration") {
                controller
                    .selectedPoints
                    .value = (controller.workStatus.value.durationMs ?? 0)
                    .toPrecision(2);
                controller.selectedCategory.value =
                    touchedSection.title.toString();
              } else {
                controller.selectedPoints.value = touchedSection.value
                    .toDouble()
                    .toPrecision(2);
                controller.selectedCategory.value =
                    touchedSection.title.toString();
              }
            }
          },
          enabled: true,
          longPressDuration: const Duration(milliseconds: 400),
        ),
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            value:
                double.parse(controller.workStatus.value.heartPts ?? "0.0") /
                targetHartPoints,
            color: Colors.yellow,
            radius:
                controller.selectedCategory.value == "Heart Points" ? 27 : 20,
            title: "Heart Points",
            showTitle: false,
          ),
          PieChartSectionData(
            value:
                (controller.workStatus.value.durationMs?.toDouble() ?? 1) /
                targetWorkout,
            color: Colors.green,
            radius: controller.selectedCategory.value == "Duration" ? 27 : 20,
            title: "Duration",
            showTitle: false,
          ),
          PieChartSectionData(
            value: controller.stepsCount.toDouble() / 6000,
            color: Colors.red,
            radius: controller.selectedCategory.value == "Steps" ? 27 : 20,
            title: "Steps",
            showTitle: false,
          ),

          PieChartSectionData(
            value:
                double.parse(controller.workStatus.value.calories ?? "0.0") /
                targetCalBran,
            color: Colors.blue,
            title: "Calories",
            radius: controller.selectedCategory.value == "Calories" ? 27 : 20,
            showTitle: false,
          ),
        ],
      ),

      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  Widget getPointsWidget({
    required BuildContext context,
    required String svg,
    required String title,
    required String points,
    dynamic target,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 22, height: 22, child: SvgPicture.string(svg)),
        const Gap(7),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: MyAppColors.mutedGray,
                fontWeight: FontWeight.w300,
              ),
            ),
            Row(
              children: [
                Text(
                  points,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (target != null)
                  Text(
                    "/$target",
                    style: TextStyle(
                      fontSize: 13,
                      color: MyAppColors.mutedGray,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
