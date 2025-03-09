import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:o_xbese/src/resources/svg_string.dart';
import 'package:o_xbese/src/theme/colors.dart';

Column pointsOverviewWidget(BuildContext context) {
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              '150',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Calories',
                              style: TextStyle(
                                fontSize: 8,
                                color: MyAppColors.mutedGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    PieChart(
                      PieChartData(
                        startDegreeOffset: 180,
                        sectionsSpace: 3,
                        pieTouchData: PieTouchData(
                          enabled: true,
                          longPressDuration: const Duration(milliseconds: 200),
                        ),
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: 15,
                            color: Colors.yellow,
                            radius: 18,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 20,
                            color: Colors.green,
                            radius: 18,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 40,
                            color: Colors.red,
                            radius: 18,
                            showTitle: false,
                          ),

                          PieChartSectionData(
                            value: 25,
                            color: Colors.blue,
                            radius: 23,
                            showTitle: false,
                          ),
                        ],
                      ),

                      duration: const Duration(milliseconds: 150),
                      curve: Curves.linear,
                    ),
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
                    child: getPointsWidget(
                      context: context,
                      svg: stepsIconRed,
                      title: 'Steps',
                      points: '3303.0',
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
                    child: getPointsWidget(
                      context: context,
                      svg: calorieIconBlue,
                      title: 'Calories',
                      points: '150.0',
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
                child: getPointsWidget(
                  context: context,
                  svg: heartIconSVGYellow,
                  title: 'Heart Points',
                  points: '5.0',
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
                child: getPointsWidget(
                  context: context,
                  svg: workOutIconSVGGreen,
                  title: 'Workout Time',
                  points: '150.0',
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget getPointsWidget({
  required BuildContext context,
  required String svg,
  required String title,
  required String points,
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
          Text(
            points,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ],
  );
}
