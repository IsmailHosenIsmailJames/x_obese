import "package:health/health.dart";

/// Data types available on iOS via Apple Health.
const List<HealthDataType> dataTypesIOS = [
  HealthDataType.STEPS,
  HealthDataType.DISTANCE_WALKING_RUNNING,
  HealthDataType.EXERCISE_TIME,
  HealthDataType.WORKOUT,
];

/// Data types available on Android via the Google Health Connect API.
const List<HealthDataType> dataTypesAndroid = [
  HealthDataType.STEPS,
  HealthDataType.DISTANCE_DELTA,
  HealthDataType.WORKOUT,
];

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
