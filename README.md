# X-Obese Fitness App

X-Obese is a comprehensive fitness application built with Flutter, designed to help users track their health journey through step counting, workout monitoring, and community events.

---

## 📖 Documentation Links

For a deeper dive into the project, please refer to the following guides:

- [**Architecture Guide**](ARCHITECTURE.md) - Details on state management, background services, and project structure.
- [**API Integration Guide**](API_GUIDE.md) - Information on backend communication, authentication, and JWT handling.

---

## 🚀 Key Features

- **Activity Tracking:** Running, Walking, and Cycling with GPS and Step integration.
- **Background Persistence:** Foreground services allow tracking to continue when the app is minimized.
- **Health Sync:** Integration with Apple Health and Google Health Connect.
- **Community:** Marathon programs (Virtual and On-Site) and health blogs.
- **Workout Planning:** Customizable workout plans and history tracking.

## 🛠 Tech Stack

- **Framework:** Flutter
- **State Management:** Bloc (Auth) & GetX (Features)
- **Navigation:** GoRouter
- **Persistence:** Hive & SharedPreferences
- **Networking:** Dio
- **Tracking:** flutter_foreground_task, geolocator, pedometer

## ⚙️ Getting Started

### Prerequisites

- Flutter SDK (v3.8.0 or higher recommended)
- Android Studio / Xcode for mobile development
- A physical device is recommended for testing GPS and Pedometer features.

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Generate Serializers (if needed):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Run the app:**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```text
lib/
├── src/
│   ├── apis/               # API clients and interceptors
│   ├── core/               # Routing, Health, Location services
│   ├── data/               # Local persistence (Hive/SharedPrefs)
│   ├── screens/            # UI Features (Auth, Home, Activity, etc.)
│   ├── theme/              # Styles and Colors
│   └── widgets/            # Reusable UI components
├── app.dart                # Main App Widget
└── main.dart               # Entry Point
```

## 🤝 Contribution and Handoff

This project was developed by the primary developer who has now resigned. The documentation provided in the `ARCHITECTURE.md` and `API_GUIDE.md` files is intended to facilitate a smooth transition for the next developer.
