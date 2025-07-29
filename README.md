# X-Obese Fitness App

X-Obese is a new fitness application designed to help users on their journey to a healthier lifestyle. This Flutter-based mobile app provides a range of features to track fitness activities, monitor progress, and stay motivated.

## Features

- **User Authentication:** Secure login and registration for a personalized experience.
- **Fitness Tracking:**
    - **Step Counter:** Pedometer functionality to track daily steps.
    - **Workout Tracking:** Log various workout sessions, including running and walking.
    - **GPS Integration:** Google Maps for tracking routes during outdoor activities.
- **Health Data Integration:**
    - **HealthKit & Google Fit:** Syncs with native health platforms to consolidate health data.
- **Personalized Information:**
    - **User Profile:** Collects and stores user data such as age, weight, and height for personalized recommendations.
    - **Onboarding:** An introductory flow for new users to get acquainted with the app.
- **User Interface:**
    - **Customizable Theme:** A clean and modern UI with a custom color scheme and fonts.
    - **Animations & Visualizations:** Engaging animations and charts to visualize progress.
    - **Notifications:** Local notifications to keep users engaged and informed.
- **Technical Features:**
    - **State Management:** Utilizes Flutter Bloc for robust state management.
    - **Local Storage:** Uses Hive and flutter_secure_storage for efficient and secure local data persistence.
    - **API Integration:** Communicates with a backend server for data synchronization.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project Structure

The project is organized into the following main directories:

- `lib/`: The core of the application, containing all the Dart code.
    - `src/`: Source code, divided into:
        - `apis/`: API service integrations.
        - `common_functions/`: Shared utility functions.
        - `core/`: Core functionalities like health integration.
        - `data/`: Data models and local database management.
        - `resources/`: App-wide resources.
        - `screens/`: UI screens for different features.
        - `theme/`: App theme and styling.
        - `widgets/`: Reusable UI components.
    - `app.dart`: The main application widget.
    - `main.dart`: The entry point of the application.
- `assets/`: Static assets like images, fonts, and animations.
- `android/`: Android-specific project files.
- `ios/`: iOS-specific project files.
- `pubspec.yaml`: The project's dependency and configuration file.

## Dependencies

The project uses a variety of Flutter packages, including:

- `flutter_bloc` for state management.
- `get` for navigation and dependency injection.
- `google_maps_flutter` for map integration.
- `health` for HealthKit and Google Fit integration.
- `pedometer` for step counting.
- `hive_flutter` and `flutter_secure_storage` for local data storage.
- And many more for UI, animations, and other functionalities.

## How to Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/x_obese.git
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```