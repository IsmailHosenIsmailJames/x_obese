// import 'dart:math'; // For calculations like pow

// // --- Enums ---

// enum PlanType { gainMuscle, keepFit, loseWeight }

// enum Gender { male, female }

// // Describes the user's general daily activity level *before* starting the plan
// enum ActivityLevel {
//   sedentary, // Little or no exercise
//   lightlyActive, // Light exercise/sports 1-3 days/week
//   moderatelyActive, // Moderate exercise/sports 3-5 days/week
//   veryActive, // Hard exercise/sports 6-7 days a week
//   extraActive, // Very hard exercise/sports & physical job
// }

// enum WorkoutType {
//   cardio,
//   strength,
//   rest,
//   activeRecovery, // e.g., light walk, stretching
// }

// // --- Input Class ---

// class WorkoutPlanInput {
//   final DateTime birthDate;
//   final double weightKg;
//   final double heightMeter; // Changed name for clarity
//   final Gender gender;
//   final ActivityLevel currentActivityLevel;
//   final PlanType planType;
//   final Duration preferredWorkoutDuration; // User's preferred time per session
//   final double? loseWeightTargetKg; // Only relevant for loseWeight planType

//   WorkoutPlanInput({
//     required this.birthDate,
//     required this.weightKg,
//     required this.heightMeter,
//     required this.gender,
//     required this.currentActivityLevel,
//     required this.planType,
//     required this.preferredWorkoutDuration,
//     this.loseWeightTargetKg,
//   }) {
//     // Basic validation
//     if (planType == PlanType.loseWeight &&
//         (loseWeightTargetKg == null || loseWeightTargetKg! <= 0)) {
//       throw ArgumentError(
//         'loseWeightTargetKg must be provided and positive for loseWeight plan type.',
//       );
//     }
//     if (weightKg <= 0 || heightMeter <= 0) {
//       throw ArgumentError('Weight and Height must be positive.');
//     }
//     if (preferredWorkoutDuration.inMinutes <= 0) {
//       throw ArgumentError('Preferred workout duration must be positive.');
//     }
//   }

//   // --- Calculated Properties within Input ---

//   int get age {
//     final now = DateTime.now();
//     int age = now.year - birthDate.year;
//     if (now.month < birthDate.month ||
//         (now.month == birthDate.month && now.day < birthDate.day)) {
//       age--;
//     }
//     return age;
//   }

//   double get bmi {
//     if (heightMeter <= 0) return 0;
//     return weightKg / pow(heightMeter, 2);
//   }

//   String get bmiCategory {
//     final currentBmi = bmi;
//     if (currentBmi < 18.5) return "Underweight";
//     if (currentBmi < 25) return "Healthy Weight";
//     if (currentBmi < 30) return "Overweight";
//     return "Obese";
//   }

//   // Basal Metabolic Rate (Mifflin-St Jeor Formula)
//   double get bmr {
//     // Formula needs height in cm
//     double heightCm = heightMeter * 100;
//     if (gender == Gender.male) {
//       return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
//     } else {
//       // female
//       return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
//     }
//   }

//   // TDEE Multiplier based on activity level
//   double get _activityFactor {
//     switch (currentActivityLevel) {
//       case ActivityLevel.sedentary:
//         return 1.2;
//       case ActivityLevel.lightlyActive:
//         return 1.375;
//       case ActivityLevel.moderatelyActive:
//         return 1.55;
//       case ActivityLevel.veryActive:
//         return 1.725;
//       case ActivityLevel.extraActive:
//         return 1.9;
//     }
//   }

//   // Total Daily Energy Expenditure
//   double get tdee {
//     return bmr * _activityFactor;
//   }
// }

// // --- Output Class ---

// class GeneratedWorkoutPlan {
//   final int estimatedTotalWeeks;
//   final double targetWeightLossKg; // Echoing the goal
//   final double recommendedWeeklyWeightLossKg;
//   final int weeklyWorkoutFrequency; // Days per week
//   final Duration workoutSessionDuration; // Duration per session
//   final double
//   estimatedCaloriesToBurnPerWorkout; // Approx. target for intensity
//   final double recommendedDailyCalorieDeficit;
//   final double? recommendedTargetDailyCalories; // Optional: TDEE - deficit
//   final List<WorkoutType>
//   weeklyScheduleSuggestion; // Example: [Cardio, Strength, Rest,...]
//   final String bmiClassification; // e.g., "Overweight"
//   final List<String> importantNotes;

//   GeneratedWorkoutPlan({
//     required this.estimatedTotalWeeks,
//     required this.targetWeightLossKg,
//     required this.recommendedWeeklyWeightLossKg,
//     required this.weeklyWorkoutFrequency,
//     required this.workoutSessionDuration,
//     required this.estimatedCaloriesToBurnPerWorkout,
//     required this.recommendedDailyCalorieDeficit,
//     this.recommendedTargetDailyCalories,
//     required this.weeklyScheduleSuggestion,
//     required this.bmiClassification,
//     required this.importantNotes,
//   });

//   @override
//   String toString() {
//     // Basic string representation for easy printing/debugging
//     return '''
// Generated Workout Plan:
// -------------------------
// Goal: Lose ${targetWeightLossKg.toStringAsFixed(1)} kg
// BMI Classification: $bmiClassification
// Estimated Duration: $estimatedTotalWeeks weeks
// Recommended Rate: ${recommendedWeeklyWeightLossKg.toStringAsFixed(1)} kg/week
// Workout Frequency: $weeklyWorkoutFrequency days/week
// Session Duration: ${workoutSessionDuration.inMinutes} minutes
// Est. Calories Burn per Workout: ~${estimatedCaloriesToBurnPerWorkout.round()} kcal
// Recommended Daily Calorie Deficit: ~${recommendedDailyCalorieDeficit.round()} kcal
// Recommended Daily Calories (Optional): ${recommendedTargetDailyCalories?.round() ?? 'N/A'} kcal
// Suggested Weekly Schedule: ${weeklyScheduleSuggestion.map((e) => e.name).join(', ')}

// Important Notes:
// ${importantNotes.map((e) => '- $e').join('\n')}
// ''';
//   }
// }

// // --- Generator Logic ---

// class WorkoutPlanGenerator {
//   // Constants
//   static const double kcalPerKgFat = 7700.0;
//   static const double safeWeeklyLossRateKg = 0.5; // Default safe rate
//   static const double minCaloriesMale = 1500.0;
//   static const double minCaloriesFemale = 1200.0;

//   GeneratedWorkoutPlan generatePlan(WorkoutPlanInput input) {
//     if (input.planType != PlanType.loseWeight) {
//       // For now, we only handle weight loss. You'd add logic for other types here.
//       throw UnimplementedError(
//         'Plan generation for ${input.planType} is not implemented yet.',
//       );
//     }

//     // --- Calculations ---
//     final double targetLossKg = input.loseWeightTargetKg!;
//     final double weeklyDeficitNeeded = safeWeeklyLossRateKg * kcalPerKgFat;
//     final double dailyDeficitNeeded = weeklyDeficitNeeded / 7.0;

//     final int estimatedWeeks = (targetLossKg / safeWeeklyLossRateKg).ceil();

//     // --- Workout Strategy ---
//     // Let's aim for exercise to contribute roughly 40-60% of the deficit.
//     // A moderate starting point is 4 workout days per week.
//     final int workoutDaysPerWeek = 4;

//     // Estimate calories to be burned *additionally* through planned workouts per week
//     // Let's target ~50% of the deficit from exercise as a start point
//     final double targetWeeklyExerciseBurn = weeklyDeficitNeeded * 0.5;
//     final double estimatedBurnPerSession =
//         targetWeeklyExerciseBurn / workoutDaysPerWeek;

//     // Check if the calorie burn per session is realistic for the duration
//     // Very rough estimate: moderate intensity burns 5-10 kcal/minute.
//     final double estimatedMinBurn =
//         input.preferredWorkoutDuration.inMinutes * 5.0;
//     final double estimatedMaxBurn =
//         input.preferredWorkoutDuration.inMinutes * 10.0;

//     // Adjust if the calculated burn seems too high or low for the duration
//     // (This is a simplification - real burn depends heavily on intensity & type)
//     final double realisticBurnPerSession = estimatedBurnPerSession.clamp(
//       estimatedMinBurn * 0.8,
//       estimatedMaxBurn * 1.2,
//     ); // Allow some flexibility

//     // Define a sample weekly schedule (can be made more dynamic)
//     final List<WorkoutType> weeklySchedule = [
//       WorkoutType.cardio,
//       WorkoutType.strength,
//       WorkoutType.rest,
//       WorkoutType.cardio,
//       WorkoutType.strength,
//       WorkoutType.activeRecovery,
//       WorkoutType.rest,
//     ];
//     // Adjust schedule if workoutDaysPerWeek was different (e.g. more rest days)

//     // Calculate Recommended Daily Calorie Intake
//     double targetDailyCalories = input.tdee - dailyDeficitNeeded;

//     // Ensure target calories are not dangerously low
//     final double minSafeCalories =
//         (input.gender == Gender.male) ? minCaloriesMale : minCaloriesFemale;
//     if (targetDailyCalories < minSafeCalories) {
//       // If the calculated deficit pushes intake too low, we MUST warn the user
//       // and potentially adjust the plan (e.g., slower weight loss rate).
//       // For now, we'll just set it to the minimum safe level and add a strong warning.
//       targetDailyCalories = minSafeCalories;
//       // Recalculate the achievable deficit based on this minimum intake
//       final adjustedDailyDeficit = input.tdee - targetDailyCalories;
//       // Note: This might mean the 0.5kg/week target isn't fully met just by diet/exercise
//       // and the duration might need adjustment, or the user needs medical advice.
//       // This complexity highlights the need for careful handling or professional consultation.
//     }

//     // --- Compile Notes ---
//     final List<String> notes = [
//       "This plan focuses on exercise. Achieving a ~${dailyDeficitNeeded.round()} kcal daily deficit is crucial for the ${safeWeeklyLossRateKg}kg/week goal. This requires managing your diet.",
//       "Consider tracking your food intake to ensure you meet your calorie goals.",
//       "Focus on whole foods, protein, fiber, and reduce sugary drinks/processed snacks.",
//       "Always warm-up for 5-10 minutes before each workout and cool-down/stretch afterwards.",
//       "Stay hydrated by drinking plenty of water throughout the day.",
//       "Listen to your body. Take extra rest days if needed and don't push through sharp pain.",
//       "Consistency is key! Stick to the schedule as best as you can.",
//       "Consider consulting a doctor or certified trainer before starting or modifying this program, especially if you have health conditions.",
//     ];
//     if (targetDailyCalories == minSafeCalories &&
//         dailyDeficitNeeded > (input.tdee - targetDailyCalories)) {
//       notes.add(
//         "WARNING: Your calculated target calorie intake is near the minimum recommended level (${minSafeCalories.round()} kcal). Weight loss may be slower than projected. Consult a healthcare professional for personalized advice.",
//       );
//     }

//     // --- Create Output Object ---
//     return GeneratedWorkoutPlan(
//       estimatedTotalWeeks: estimatedWeeks,
//       targetWeightLossKg: targetLossKg,
//       recommendedWeeklyWeightLossKg:
//           safeWeeklyLossRateKg, // The rate used for calculation
//       weeklyWorkoutFrequency: workoutDaysPerWeek,
//       workoutSessionDuration:
//           input.preferredWorkoutDuration, // Use user's preference
//       estimatedCaloriesToBurnPerWorkout: realisticBurnPerSession,
//       recommendedDailyCalorieDeficit:
//           dailyDeficitNeeded, // The ideal deficit for the rate
//       recommendedTargetDailyCalories: targetDailyCalories,
//       weeklyScheduleSuggestion: weeklySchedule,
//       bmiClassification: input.bmiCategory,
//       importantNotes: notes,
//     );
//   }
// }

// // --- Example Usage ---

// void main() {
//   // Example User Data
//   final userInput = WorkoutPlanInput(
//     birthDate: DateTime(1990, 5, 15),
//     weightKg: 85.0,
//     heightMeter: 1.75,
//     gender: Gender.male,
//     currentActivityLevel:
//         ActivityLevel.lightlyActive, // User works office job, walks sometimes
//     planType: PlanType.loseWeight,
//     preferredWorkoutDuration: Duration(
//       minutes: 45,
//     ), // User wants 45 min workouts
//     loseWeightTargetKg: 5.0,
//   );

//   print("--- User Input ---");
//   print("Age: ${userInput.age}");
//   print("BMI: ${userInput.bmi.toStringAsFixed(1)} (${userInput.bmiCategory})");
//   print("BMR: ${userInput.bmr.round()} kcal");
//   print(
//     "TDEE: ${userInput.tdee.round()} kcal (Based on ${userInput.currentActivityLevel.name})",
//   );
//   print("------------------");

//   final generator = WorkoutPlanGenerator();

//   try {
//     final generatedPlan = generator.generatePlan(userInput);
//     print(generatedPlan); // Uses the toString() method in GeneratedWorkoutPlan
//   } catch (e) {
//     print("Error generating plan: $e");
//   }
// }
