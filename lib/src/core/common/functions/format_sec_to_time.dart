String formatSeconds(int seconds) {
  Duration duration = Duration(seconds: seconds);

  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int remainingSeconds = duration.inSeconds.remainder(60);

  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = remainingSeconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}
