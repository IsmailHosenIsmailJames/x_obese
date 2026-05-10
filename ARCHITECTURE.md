# Project Architecture - X-Obese

This document provides a high-level overview of the technical architecture of the X-Obese fitness application.

## State Management

The project uses a hybrid approach to state management:

1.  **Flutter Bloc:** Primarily used for Authentication (`AuthBloc`). It handles the login/signup flow, OTP verification, and user session state.
    - Location: `lib/src/screens/auth/bloc/`
2.  **GetX:** Used for general app state and specific features like the workout tracker and global data fetching.
    - `AllInfoController`: Manages user profile, blogs, marathon lists, and workout plans.
    - `ActivityController`: Manages the live workout session state.
    - Location: Found within respective feature directories under `controller/`.

## Navigation

**GoRouter** is the primary routing library.
- Configuration: `lib/src/core/router/app_router.dart`
- It handles deep linking (planned/ready) and conditional redirection (e.g., redirecting to login if not authenticated).
- Uses `AppExtraCodec` for passing complex objects in routes.

## Data Persistence

1.  **Hive:** Used for lightweight local NoSQL storage.
    - Stores user profile information, cached blogs, marathon lists, etc.
    - Initialization: `UserDB.init()` in `main.dart`.
2.  **SharedPreferences:** Used for simple key-value pairs.
    - Stores JWT tokens (access and refresh).
    - Stores workout persistence state to allow resumption after app restart.
3.  **Secure Storage:** Mentioned in `pubspec.yaml` but `UserDB` currently uses SharedPreferences for tokens. *Note: Consider migrating sensitive tokens to `flutter_secure_storage` for better security.*

## Background Tracking (Workout)

The application tracks user movement (GPS, Steps, Pedestrian Status) even when the app is in the background or the screen is off.

- **Library:** `flutter_foreground_task`
- **Implementation:** `lib/src/screens/activity/foreground/foreground_exercise_service.dart`
- **Logic:**
    - The background task runs in a separate isolate (`ForegroundExerciseTask`).
    - It listens to `Geolocator`, `Pedometer.stepCountStream`, and `Pedometer.pedestrianStatusStream`.
    - Data is periodically sent back to the main isolate via `FlutterForegroundTask.sendDataToMain`.
    - It calculates distance based on a combination of GPS, Step count, and activity type (walking/running/cycling) to ensure accuracy.

## Health Integration

- **Library:** `health`
- **Implementation:** `lib/src/core/health/`
- **Functions:** Synchronizes data with Apple Health (iOS) and Google Health Connect (Android).
- **Data Types:** Steps, Distance, Exercise Time, and Workouts.

## Directory Structure

- `lib/src/apis/`: API clients and interceptors.
- `lib/src/core/`: Core utilities like routing, health integration, and theme.
- `lib/src/data/`: Global data persistence layer.
- `lib/src/screens/`: Feature-based UI and logic (Blocs/Controllers).
- `lib/src/widgets/`: Reusable UI components.
- `lib/src/theme/`: App styling and constants.
