import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:x_obese/src/screens/info_collector/controller/all_info_controller.dart';
import 'package:x_obese/src/theme/colors.dart';
import 'package:x_obese/src/screens/home/model/workout_model.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  final AllInfoController controller = Get.find();
  final RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    isLoading.value = true;
    await controller.fetchMyWorkouts();
    if (mounted) {
      isLoading.value = false;
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
          "Workout History",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.myWorkouts.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: _fetchData,
          color: MyAppColors.third,
          child: ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: controller.myWorkouts.length,
            itemBuilder: (context, index) {
              final workout = controller.myWorkouts[index];
              return _buildWorkoutCard(workout);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: MyAppColors.mutedGray),
          const Gap(20),
          const Text(
            "No workouts recorded yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const Gap(10),
          const Text(
            "Start your first activity to see it here!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutModel workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyAppColors.cardsBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MyAppColors.third.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_run,
                  color: MyAppColors.third,
                  size: 20,
                ),
              ),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Running Session", // Could be dynamic if backend provides type
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "${workout.formattedDate} • ${workout.formattedTime}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                "Calories",
                "${workout.calories.toStringAsFixed(0)} kcal",
                Icons.local_fire_department,
                Colors.orange,
              ),
              _buildStatItem(
                "Distance",
                "${workout.distanceKm.toStringAsFixed(2)} km",
                Icons.location_on,
                Colors.blue,
              ),
              _buildStatItem(
                "Duration",
                "${workout.durationMinutes} min",
                Icons.timer,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const Gap(4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
        ),
      ],
    );
  }
}
