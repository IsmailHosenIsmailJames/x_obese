# Developer Handoff: Maintenance & Roadmap

This document outlines known issues, maintenance tasks, and suggested future improvements for the X-Obese project.

## ⚠️ Known Points of Interest

### 1. Token Storage Security
Currently, JWT tokens are stored in `SharedPreferences`. For production-grade security, it is highly recommended to migrate these to `flutter_secure_storage`. The dependency is already in `pubspec.yaml`.

### 2. Isolate Communication in Tracking
The `ForegroundExerciseTask` runs in its own isolate. Ensure that any data needed by this task is passed through the `WorkoutRepository` (which uses SharedPreferences for cross-isolate communication) or through the `sendDataToMain` / `sendDataToTask` methods.

### 3. API Consistency
The backend is currently accessed via a hardcoded IP. It is recommended to move this to an environment variable (`--dart-define`) or a config file for different environments (Dev/Staging/Prod).

## 🛠 Maintenance Tasks

- **Dependency Updates:** Regularly run `flutter pub outdated` to check for major updates, especially for `health` and `geolocator` which frequently have breaking changes in OS updates.
- **Build Runner:** When adding new models with `json_annotation`, remember to run:
  `dart run build_runner build --delete-conflicting-outputs`

## 🚀 Future Roadmap

1.  **Refactor State Management:** Consider unifying the state management to either purely Bloc or purely GetX/Provider to reduce cognitive load for new developers.
2.  **Unit & Integration Tests:** The project currently lacks comprehensive tests. Adding tests for the `ActivityController` and the `DioClient` interceptors should be a priority.
3.  **Enhanced Offline Mode:** While some data is cached in Hive, the app heavily relies on a live connection. Improving offline support for logging workouts and syncing later would be a great feature.
4.  **UI/UX Improvements:** Enhance the marathon leaderboard with real-time updates using WebSockets if supported by the backend.

## 📞 Support and Contact

As the departing developer, I have made every effort to ensure the code is clean and documented. Please refer to the `ARCHITECTURE.md` and `API_GUIDE.md` for technical specifics.
