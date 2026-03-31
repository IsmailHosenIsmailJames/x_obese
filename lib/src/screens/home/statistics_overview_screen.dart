import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:gap/gap.dart";
import "package:intl/intl.dart";
import "package:x_obese/src/screens/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/screens/home/model/activity_history_model.dart";

class StatisticsOverviewScreen extends StatefulWidget {
  const StatisticsOverviewScreen({super.key});

  @override
  State<StatisticsOverviewScreen> createState() =>
      _StatisticsOverviewScreenState();
}

class _StatisticsOverviewScreenState extends State<StatisticsOverviewScreen> {
  final AllInfoController controller = Get.find();
  String selectedView = "Weekly"; // Daily, Weekly, Monthly
  bool isLoading = true;
  DateTime referenceDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    await controller.fetchActivityHistory(
      selectedView.toLowerCase(),
      date: referenceDate,
    );
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MyAppColors.third),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Statistics Overview",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            const Gap(10),
            _buildPeriodSelector(),
            const Gap(15),
            _buildDateNavigator(),
            const Gap(20),
            Obx(() {
              final data = controller.activityHistory.value;
              if (isLoading || data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  _buildSummaryCard(data),
                  const Gap(15),
                  _buildStatsGrid(data),
                  const Gap(25),
                  _buildChartSection(
                    title: "Steps",
                    averageValue: (data.summary.steps /
                            (selectedView == "Daily"
                                ? 24
                                : (selectedView == "Weekly" ? 7 : 30)))
                        .toStringAsFixed(0),
                    unit: "Steps",
                    points: data.charts.steps,
                    color: Colors.redAccent,
                  ),
                  const Gap(25),
                  _buildChartSection(
                    title: "Calories",
                    averageValue: (data.summary.calories /
                            (selectedView == "Daily"
                                ? 24
                                : (selectedView == "Weekly" ? 7 : 30)))
                        .toStringAsFixed(0),
                    unit: "Calories",
                    points: data.charts.calories,
                    color: MyAppColors.third,
                  ),
                  const Gap(25),
                  _buildChartSection(
                    title: "Workout Time",
                    averageValue: (data.summary.workoutTimeMs /
                            (1000 *
                                60 *
                                (selectedView == "Daily"
                                    ? 24
                                    : (selectedView == "Weekly" ? 7 : 30))))
                        .toStringAsFixed(0),
                    unit: "Min",
                    points: data.charts.workoutTime,
                    color: Colors.greenAccent,
                  ),
                  const Gap(40),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: MyAppColors.cardsBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children:
            ["Daily", "Weekly", "Monthly"].map((view) {
              bool isSelected = selectedView == view;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => selectedView = view);
                    _fetchData();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow:
                          isSelected
                              ? [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ]
                              : [],
                    ),
                    child: Center(
                      child: Text(
                        view,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.black : MyAppColors.mutedGray,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildDateNavigator() {
    String dateRange = "";
    if (selectedView == "Daily") {
      dateRange = DateFormat("MMMM d, y").format(referenceDate);
    } else if (selectedView == "Weekly") {
      DateTime weekStart = referenceDate.subtract(const Duration(days: 7));
      dateRange =
          "${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d, y').format(referenceDate)}";
    } else {
      DateTime monthStart = referenceDate.subtract(const Duration(days: 30));
      dateRange =
          "${DateFormat('MMM d').format(monthStart)} - ${DateFormat('MMM d, y').format(referenceDate)}";
    }

    bool isFuture =
        referenceDate.isAfter(DateTime.now()) ||
        DateFormat('yMd').format(referenceDate) ==
            DateFormat('yMd').format(DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavButton(Icons.arrow_back_ios, () {
          setState(() {
            if (selectedView == "Daily") {
              referenceDate = referenceDate.subtract(const Duration(days: 1));
            } else if (selectedView == "Weekly") {
              referenceDate = referenceDate.subtract(const Duration(days: 7));
            } else {
              referenceDate = referenceDate.subtract(const Duration(days: 30));
            }
          });
          _fetchData();
        }),
        const Gap(20),
        Text(
          dateRange,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Gap(20),
        Opacity(
          opacity: isFuture ? 0.3 : 1.0,
          child: _buildNavButton(Icons.arrow_forward_ios, () {
            if (isFuture) return;
            setState(() {
              if (selectedView == "Daily") {
                referenceDate = referenceDate.add(const Duration(days: 1));
              } else if (selectedView == "Weekly") {
                referenceDate = referenceDate.add(const Duration(days: 7));
              } else {
                referenceDate = referenceDate.add(const Duration(days: 30));
              }
              // Don't go beyond today
              if (referenceDate.isAfter(DateTime.now())) {
                referenceDate = DateTime.now();
              }
            });
            _fetchData();
          }),
        ),
      ],
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MyAppColors.transparentGray,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: MyAppColors.third),
      ),
    );
  }

  Widget _buildSummaryCard(ActivityHistoryModel data) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MyAppColors.cardsBackground,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CircularProgressIndicator(
                    value: 0.7, // Demo value
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      MyAppColors.third,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    value: 0.4, // Demo value
                    strokeWidth: 12,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      MyAppColors.second,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.summary.calories.toStringAsFixed(0),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      "Calories",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(15),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildSummaryLine(
                  "Steps",
                  data.summary.steps.toString(),
                  Icons.directions_run,
                  Colors.redAccent,
                ),
                const Gap(10),
                _buildSummaryLine(
                  "Calories",
                  data.summary.calories.toStringAsFixed(0),
                  Icons.local_fire_department,
                  MyAppColors.third,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryLine(
    String title,
    String val,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const Gap(8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Text(
                val,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ActivityHistoryModel data) {
    return Row(
      children: [
        Expanded(
          child: _buildStatsTile(
            "Heart Pts",
            data.summary.heartPts.toStringAsFixed(2),
            Icons.favorite,
            Colors.yellow.shade700,
          ),
        ),
        const Gap(15),
        Expanded(
          child: _buildStatsTile(
            "Workout Time",
            "${(data.summary.workoutTimeMs / (1000 * 60)).toStringAsFixed(0)}/30 Min",
            Icons.access_time,
            Colors.green.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsTile(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyAppColors.cardsBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const Gap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              Text(
                val,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({
    required String title,
    required String averageValue,
    required String unit,
    required List<ChartPoint> points,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  "Average daily: $averageValue $unit",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
        const Gap(15),
        Container(
          height: 180,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: MyAppColors.cardsBackground,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Builder(
            builder: (context) {
              double maxVal =
                  points.isEmpty
                      ? 10
                      : points
                          .map((e) => e.value)
                          .reduce((a, b) => a > b ? a : b);
              if (maxVal < 10) maxVal = 10;
              maxVal *= 1.2; // Add some padding on top

              return BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxVal,
                  barTouchData: const BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 || index >= points.length)
                            return const SizedBox();

                          String label = points[index].label;
                          if (selectedView == "Daily") {
                            if (index % 4 != 0) return const SizedBox();
                            return Text(
                              label,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            );
                          } else if (selectedView == "Weekly") {
                            try {
                              DateTime d = DateTime.parse(label);
                              return Text(
                                DateFormat("E").format(d),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            } catch (e) {
                              return Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            }
                          } else {
                            if (index % 5 != 0) return const SizedBox();
                            try {
                              DateTime d = DateTime.parse(label);
                              return Text(
                                "${d.month}/${d.day}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            } catch (e) {
                              return Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              );
                            }
                          }
                        },
                        reservedSize: 22,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % (maxVal / 5).ceil() != 0 &&
                              value != maxVal)
                            return const SizedBox();
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                            ),
                          );
                        },
                        reservedSize: 25,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups:
                      points.asMap().entries.map((entry) {
                        int index = entry.key;
                        double value = entry.value.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY:
                                  value == 0
                                      ? 0.5
                                      : value, // Small visible bar for 0
                              color: color,
                              width:
                                  selectedView == "Daily"
                                      ? 6
                                      : (selectedView == "Weekly" ? 12 : 8),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
