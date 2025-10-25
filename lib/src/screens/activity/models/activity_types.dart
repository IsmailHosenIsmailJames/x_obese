enum ActivityType {
  walking,
  running,
  cycling;

  @override
  String toString() {
    switch (this) {
      case ActivityType.walking:
        return "walking";
      case ActivityType.running:
        return "running";
      case ActivityType.cycling:
        return "cycling";
    }
  }
}
