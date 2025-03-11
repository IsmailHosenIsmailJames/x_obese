import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:o_xbese/src/theme/colors.dart';
import 'package:o_xbese/src/widgets/back_button.dart';

class CreateWorkoutPlanPage2 extends StatefulWidget {
  final PageController pageController;
  const CreateWorkoutPlanPage2({super.key, required this.pageController});

  @override
  State<CreateWorkoutPlanPage2> createState() => _CreateWorkoutPlanPage2State();
}

class _CreateWorkoutPlanPage2State extends State<CreateWorkoutPlanPage2> {
  int workoutDuration = 40;
  List<String> selectedWeekDays = [];
  List<String> weekDays = ['Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'];
  bool workoutDayReminder = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  getBackbutton(context, () {
                    widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }),
                  const Gap(55),
                  const Text(
                    'Workout Goal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Gap(22),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(10),

                      const Text(
                        'Daily Duration',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(16),
                      const Gap(5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('$workoutDuration Min'),
                      ),
                      const Gap(10),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: MyAppColors.third.withValues(
                            alpha: 0.7,
                          ),
                          padding: EdgeInsets.zero,
                          inactiveTrackColor: MyAppColors.transparentGray,
                          thumbColor: MyAppColors.third,
                          trackHeight: 12,
                        ),
                        child: Slider(
                          value: workoutDuration.toDouble(),
                          onChanged: (value) {
                            setState(() {
                              workoutDuration = value.toInt();
                            });
                          },
                          min: 0,
                          max: 90,
                          divisions: 90,
                        ),
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          Text(
                            '0 Min',
                            style: TextStyle(color: MyAppColors.mutedGray),
                          ),
                          const Spacer(),
                          Text(
                            '90 Min',
                            style: TextStyle(color: MyAppColors.mutedGray),
                          ),
                        ],
                      ),
                      const Gap(33),
                      const Text(
                        'Day For workout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<Widget>.generate(weekDays.length, (
                          index,
                        ) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedWeekDays.contains(
                                  weekDays[index],
                                )) {
                                  selectedWeekDays.remove(weekDays[index]);
                                } else {
                                  selectedWeekDays.add(weekDays[index]);
                                }
                              });
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  selectedWeekDays.contains(weekDays[index])
                                      ? MyAppColors.third
                                      : MyAppColors.transparentGray,
                              child: Text(
                                weekDays[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      selectedWeekDays.contains(weekDays[index])
                                          ? MyAppColors.primary
                                          : MyAppColors.mutedGray,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const Gap(33),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Workout Day Reminder',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Switch(
                            value: workoutDayReminder,
                            onChanged: (value) {
                              setState(() {
                                workoutDayReminder = !workoutDayReminder;
                              });
                            },
                            activeTrackColor: MyAppColors.third,
                            inactiveTrackColor: MyAppColors.transparentGray,
                          ),
                        ],
                      ),
                      const Gap(33),
                      Row(
                        children: [
                          const Text(
                            'Reminder',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '6.00 Am',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: MyAppColors.mutedGray,
                            ),
                          ),
                          const Gap(10),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: MyAppColors.mutedGray,
                            size: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text('Generate Plan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
