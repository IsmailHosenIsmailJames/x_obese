import "package:health/health.dart";

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
  HEALTH_CONNECT_STATUS,
  PERMISSIONS_REVOKING,
  PERMISSIONS_REVOKED,
  PERMISSIONS_NOT_REVOKED,
}

/// List of data types available on iOS
const List<HealthDataType> dataTypesIOS = [
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.BASAL_ENERGY_BURNED,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.BODY_MASS_INDEX,
  HealthDataType.BODY_TEMPERATURE,
  HealthDataType.HEART_RATE,
  HealthDataType.HEIGHT,
  HealthDataType.STEPS,
  HealthDataType.WEIGHT,
  HealthDataType.SLEEP_AWAKE,
  HealthDataType.SLEEP_ASLEEP,
  HealthDataType.SLEEP_IN_BED,
  HealthDataType.SLEEP_LIGHT,
  HealthDataType.SLEEP_DEEP,
  HealthDataType.SLEEP_REM,
  HealthDataType.WATER,
  HealthDataType.EXERCISE_TIME,
  HealthDataType.WORKOUT,

  // note that a phone cannot write these ECG-based types - only read them
  // HealthDataType.ELECTROCARDIOGRAM,
  // HealthDataType.HIGH_HEART_RATE_EVENT,
  // HealthDataType.IRREGULAR_HEART_RATE_EVENT,
  // HealthDataType.LOW_HEART_RATE_EVENT,
  // HealthDataType.RESTING_HEART_RATE,
  // HealthDataType.WALKING_HEART_RATE,
  // HealthDataType.ATRIAL_FIBRILLATION_BURDEN,
  HealthDataType.GENDER,
  HealthDataType.BLOOD_TYPE,
  HealthDataType.BIRTH_DATE,
];

/// List of data types available on Android.
///
/// Note that these are only the ones supported on Android's Health Connect API.
/// Android's Health Connect has more types that we support in the [HealthDataType]
/// enumeration.
const List<HealthDataType> dataTypesAndroid = [
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.BASAL_ENERGY_BURNED,
  HealthDataType.BLOOD_OXYGEN,
  HealthDataType.HEIGHT,
  HealthDataType.WEIGHT,
  HealthDataType.HEART_RATE,
  HealthDataType.STEPS,
  HealthDataType.DISTANCE_DELTA,
  HealthDataType.SLEEP_ASLEEP,
  HealthDataType.SLEEP_AWAKE_IN_BED,
  HealthDataType.SLEEP_AWAKE,
  HealthDataType.SLEEP_DEEP,
  HealthDataType.SLEEP_LIGHT,
  HealthDataType.SLEEP_OUT_OF_BED,
  HealthDataType.SLEEP_REM,
  HealthDataType.SLEEP_UNKNOWN,
  HealthDataType.SLEEP_SESSION,
  HealthDataType.WATER,
  HealthDataType.WORKOUT,
  HealthDataType.RESTING_HEART_RATE,
  HealthDataType.TOTAL_CALORIES_BURNED,
];
