import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:x_obese/src/resources/svg_string.dart';
import 'package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/theme/colors.dart';

Column pointsOverviewWidget(
  BuildContext context,
  AllInfoController controller,
) {
  return Column(
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                controller.selectedPoints.value.toString(),
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
                        title: 'Steps',
                        points: controller.stepsCount.value.toString(),
                        target: '6000',
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
                        title: 'Calories',
                        points:
                            controller.workStatus.value.first.calories
                                ?.toString() ??
                            '0',
                        target:
                            (controller
                                        .getWorkoutPlansList
                                        .first
                                        .caloriesGoal ??
                                    0)
                                .abs(),
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
                    title: 'Heart Points',
                    points:
                        controller.workStatus.value.first.heartPts
                            ?.toString() ??
                        '0',
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
                    title: 'Workout Time',
                    points:
                        controller.workStatus.value.first.durationMs
                            ?.toString() ??
                        '0',
                    target:
                        ((controller.getWorkoutPlansList.first.workoutTimeMs ??
                                    0)
                                .abs() /
                            60000),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

PieChart getPieChart(AllInfoController controller) {
  return PieChart(
    PieChartData(
      startDegreeOffset: 180,
      sectionsSpace: 3,

      pieTouchData: PieTouchData(
        touchCallback: (p0, p1) {
          final touchedSection = p1?.touchedSection?.touchedSection;
          if (touchedSection != null) {
            if (touchedSection.title.toString() == 'Steps') {
              controller.selectedPoints.value = controller.stepsCount.value;
              controller.selectedCategory.value =
                  touchedSection.title.toString();
            } else {
              controller.selectedPoints.value =
                  touchedSection.value.toInt() - 1;
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
              (controller.workStatus.value.first.heartPts?.toDouble() ?? 0.0) +
              1,
          color: Colors.yellow,
          radius: controller.selectedCategory.value == 'Heart Points' ? 27 : 20,
          title: 'Heart Points',
          showTitle: false,
        ),
        PieChartSectionData(
          value:
              (controller.workStatus.value.first.durationMs?.toDouble() ??
                  0.0) +
              1,
          color: Colors.green,
          radius: controller.selectedCategory.value == 'Duration' ? 27 : 20,
          title: 'Duration',
          showTitle: false,
        ),
        PieChartSectionData(
          value: (controller.stepsCount.toDouble() / 6000),
          color: Colors.red,
          radius: controller.selectedCategory.value == 'Steps' ? 27 : 20,
          title: 'Steps',
          showTitle: false,
        ),

        PieChartSectionData(
          value:
              (controller.workStatus.value.first.calories?.toDouble() ?? 0.0) +
              1,
          color: Colors.blue,
          title: 'Calories',
          radius: controller.selectedCategory.value == 'Calories' ? 27 : 20,
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
                  '/$target',
                  style: TextStyle(fontSize: 13, color: MyAppColors.mutedGray),
                ),
            ],
          ),
        ],
      ),
    ],
  );
}
