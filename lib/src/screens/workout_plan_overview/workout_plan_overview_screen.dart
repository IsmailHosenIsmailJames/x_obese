import "package:flutter/material.dart";
import "package:gap/gap.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:table_calendar/table_calendar.dart";
import "package:x_obese/src/screens/controller/info_collector/controller/all_info_controller.dart";
import "package:x_obese/src/screens/create_workout_plan/create_workout_plan.dart";
import "package:x_obese/src/screens/create_workout_plan/model/create_workout_plan_model.dart";
import "package:x_obese/src/screens/create_workout_plan/model/get_workout_plans.dart";
import "package:x_obese/src/screens/create_workout_plan/pages/page_3.dart";
import "package:x_obese/src/theme/colors.dart";
import "package:x_obese/src/widgets/back_button.dart";

class WorkoutPlanOverviewScreen extends StatefulWidget {
  final List<GetWorkoutPlans> getWorkoutPlansList;
  const WorkoutPlanOverviewScreen({
    super.key,
    required this.getWorkoutPlansList,
  });

  @override
  State<WorkoutPlanOverviewScreen> createState() =>
      _WorkoutPlanOverviewScreenState();
}

class _WorkoutPlanOverviewScreenState extends State<WorkoutPlanOverviewScreen> {
  AllInfoController allInfoController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
              child: Row(
                children: [
                  getBackButton(context, () => Navigator.pop(context)),
                  const Spacer(flex: 4),
                  const Text(
                    "Plan Overview",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(flex: 6),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 50,
                  left: 15,
                  right: 15,
                ),
                children: [
                  workoutPlanOverview(
                    context: context,
                    allInfoUser: allInfoController.allInfo.value,
                    userBMI: widget.getWorkoutPlansList.first.bmi ?? "",
                    startDate:
                        widget.getWorkoutPlansList.first.startDate ??
                        DateTime.now(),
                    endDate:
                        widget.getWorkoutPlansList.first.endDate ??
                        DateTime.now(),
                    goalType:
                        (widget.getWorkoutPlansList.first.goalType ?? "None")
                            .replaceAll("_", " ")
                            .capitalizeFirst,
                    weightGoal:
                        widget.getWorkoutPlansList.first.weightGoal
                            ?.toString() ??
                        "0",
                    workoutDays:
                        widget.getWorkoutPlansList.first.workoutDays ?? "",
                    workoutTimeMs:
                        widget.getWorkoutPlansList.first.workoutTimeMs ?? "0",

                    daysTotal:
                        (widget.getWorkoutPlansList.first.totalDays ?? "")
                            .toString(),
                    calorieBairn:
                        widget.getWorkoutPlansList.first.caloriesGoal ?? 0,
                  ),
                  const Gap(20),
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("Calendar", style: TextStyle(fontSize: 16)),
                  ),
                  const Gap(10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MyAppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: TableCalendar(
                      calendarBuilders: CalendarBuilders(
                        selectedBuilder: (context, day, focusedDay) {
                          return Stack(
                            children: [
                              Center(
                                child: Text(
                                  day.day.toString(),
                                  style: TextStyle(
                                    color:
                                        day.month != focusedDay.month
                                            ? const Color(0xffD9D9D9)
                                            : MyAppColors.third,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(
                                  height: 6,
                                  width: 6,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        isSameDate(day, DateTime.now()) == false
                                            ? MyAppColors.second
                                            : MyAppColors.third,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      selectedDayPredicate: (day) {
                        final first = widget.getWorkoutPlansList.first;
                        List<String> weekdays =
                            first.workoutDays?.split(",") ?? [];
                        if (!(first.startDate != null &&
                                first.endDate != null &&
                                day.isAfter(first.startDate!) &&
                                day.isBefore(first.endDate!)) &&
                            !(isSameDate(first.endDate, day) ||
                                isSameDate(first.startDate, day))) {
                          return false;
                        }
                        return weekdays.contains(
                          DateFormat(DateFormat.WEEKDAY).format(day),
                        );
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: MyAppColors.third,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: MyAppColors.third,
                          shape: BoxShape.circle,
                        ),
                        defaultTextStyle: TextStyle(color: MyAppColors.third),
                        weekendTextStyle: TextStyle(color: MyAppColors.third),
                        outsideTextStyle: const TextStyle(
                          color: Color(0xffD9D9D9),
                        ),
                      ),

                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
                      headerVisible: false,
                      daysOfWeekHeight: 30,
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: Color(0xffD9D9D9)),
                        weekendStyle: TextStyle(color: Color(0xffD9D9D9)),
                      ),
                      weekendDays: [DateTime.friday, DateTime.saturday],
                    ),
                  ),
                  const Gap(30),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyAppColors.transparentGray,
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const CreateWorkoutPlan(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Create Plan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: MyAppColors.third,
                              ),
                            ),
                          ),
                        ),
                        const Gap(25),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              GetWorkoutPlans getWorkoutPlans =
                                  widget.getWorkoutPlansList.first;
                              CreateWorkoutPlanModel createWorkoutPlanModel =
                                  CreateWorkoutPlanModel(
                                    weightGoal:
                                        getWorkoutPlans.weightGoal.toString(),
                                    goalType: getWorkoutPlans.goalType!
                                        .replaceAll("_", " "),
                                    endDate: getWorkoutPlans.endDate,
                                    startDate: getWorkoutPlans.startDate,
                                    activateReminder:
                                        getWorkoutPlans.activateReminder,
                                    reminderTime:
                                        getWorkoutPlans.reminderTime != null
                                            ? TimeOfDay.fromDateTime(
                                              getWorkoutPlans.reminderTime!,
                                            ).format(context)
                                            : null,
                                    workoutDays: getWorkoutPlans.workoutDays,
                                    workoutTimeMs:
                                        ((int.parse(
                                                  getWorkoutPlans
                                                          .workoutTimeMs ??
                                                      "0",
                                                ) /
                                                60000))
                                            .toInt()
                                            .toString(),
                                  );

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CreateWorkoutPlan(
                                        createWorkoutPlanModel:
                                            createWorkoutPlanModel,
                                        id: getWorkoutPlans.id,
                                      ),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              "Adjust Plan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool isSameDate(DateTime? date1, DateTime? date2) {
  if (date1 == null || date2 == null) return false;
  if (date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day) {
    return true;
  } else {
    return false;
  }
}
