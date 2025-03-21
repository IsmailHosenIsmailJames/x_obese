import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationUtils {
  /// Calculates the distance covered by a list of LatLng points, applying
  /// a simple moving average filter and distance thresholding for noise reduction.
  ///
  /// [latLngList]: The list of LatLng points.
  /// [windowSize]: The size of the moving average window (number of points).
  ///   Larger values provide more smoothing but introduce more lag.
  /// [maxDistanceThreshold]: The maximum distance (in meters) allowed between
  ///   consecutive points.  Points exceeding this distance are considered noise
  ///   and are discarded.
  /// [maxTimeThreshold]: The minimum time different (in seconds) allowed between
  ///   consecutive points. Points those time diff is less this distance are considered noise
  ///   and are discarded.
  ///   Returns the total distance covered in meters.
  static double calculateDistanceCovered(
    List<LatLng> latLngList,
    int windowSize,
    double maxDistanceThreshold,
    double maxTimeThreshold, {
    List<DateTime>? timeList, // Optional list of timestamps
  }) {
    if (latLngList.length < 2) {
      return 0.0; // Not enough points to calculate distance.
    }

    // 1. Apply Distance/Time Thresholding
    List<LatLng> filteredPoints = [];
    List<DateTime> filteredTime = [];

    filteredPoints.add(latLngList[0]);
    if (timeList != null && timeList.isNotEmpty) {
      filteredTime.add(timeList[0]);
    }

    for (int i = 1; i < latLngList.length; i++) {
      double distance = Geolocator.distanceBetween(
        filteredPoints.last.latitude,
        filteredPoints.last.longitude,
        latLngList[i].latitude,
        latLngList[i].longitude,
      );

      // Check time threshold
      bool timeCheckPass = true;
      if (timeList != null && timeList.length == latLngList.length) {
        Duration timeDiff = timeList[i].difference(filteredTime.last);
        if (timeDiff.inMilliseconds < maxTimeThreshold * 1000) {
          timeCheckPass = false;
        }
      }

      if (distance <= maxDistanceThreshold && timeCheckPass) {
        filteredPoints.add(latLngList[i]);
        if (timeList != null && timeList.isNotEmpty) {
          filteredTime.add(timeList[i]);
        }
      } else {
        print('Discarded point $i due to distance $distance or time');
      }
    }

    // 2. Apply Simple Moving Average (SMA)
    List<LatLng> smoothedPoints = _applySMA(filteredPoints, windowSize);

    // 3. Calculate Total Distance
    double totalDistance = 0.0;
    for (int i = 1; i < smoothedPoints.length; i++) {
      totalDistance += Geolocator.distanceBetween(
        smoothedPoints[i - 1].latitude,
        smoothedPoints[i - 1].longitude,
        smoothedPoints[i].latitude,
        smoothedPoints[i].longitude,
      );
    }

    return totalDistance;
  }

  /// Applies a Simple Moving Average (SMA) filter to a list of LatLng points.
  static List<LatLng> _applySMA(List<LatLng> points, int windowSize) {
    if (points.length < windowSize) {
      return points; // Not enough points to apply the filter.
    }

    List<LatLng> smoothedPoints = [];
    for (int i = 0; i < points.length - windowSize + 1; i++) {
      double sumLat = 0.0;
      double sumLng = 0.0;
      for (int j = 0; j < windowSize; j++) {
        sumLat += points[i + j].latitude;
        sumLng += points[i + j].longitude;
      }
      smoothedPoints.add(LatLng(sumLat / windowSize, sumLng / windowSize));
    }
    return smoothedPoints;
  }

  /// Calculates distance without any filtering.  Useful for comparison.
  static double calculateRawDistance(List<LatLng> latLngList) {
    double distance = 0;
    for (int i = 1; i < latLngList.length; i++) {
      distance += Geolocator.distanceBetween(
        latLngList[i - 1].latitude,
        latLngList[i - 1].longitude,
        latLngList[i].latitude,
        latLngList[i].longitude,
      );
    }
    return distance;
  }
}

// Example Usage:
void mainxyz() async {
  // Simulate some noisy GPS data (replace with your actual data)
  List<LatLng> noisyData = [
    LatLng(37.7749, -122.4194), // San Francisco
    LatLng(37.7755, -122.4199), // Slightly noisy
    LatLng(37.7760, -122.4205), // More noise
    LatLng(37.7800, -122.4150), // Outlier (discarded)
    LatLng(37.7768, -122.4210),
    LatLng(37.7775, -122.4218),
    LatLng(37.8775, -122.5218), //big Outlier
    LatLng(37.7782, -122.4225),
    LatLng(37.7789, -122.4232),
    LatLng(37.7795, -122.4239),
  ];

  //Simulate time list
  List<DateTime> timeList = [
    DateTime.now(),
    DateTime.now().add(Duration(seconds: 1)),
    DateTime.now().add(Duration(seconds: 2)),
    DateTime.now().add(Duration(seconds: 3)), //outlier
    DateTime.now().add(Duration(seconds: 5)),
    DateTime.now().add(Duration(seconds: 6)),
    DateTime.now().add(Duration(seconds: 7)), //big Outlier
    DateTime.now().add(Duration(seconds: 9)),
    DateTime.now().add(Duration(seconds: 10)),
    DateTime.now().add(Duration(seconds: 11)),
  ];

  // Calculate distance with filtering
  double filteredDistance = LocationUtils.calculateDistanceCovered(
    noisyData,
    3,
    50,
    1,
    timeList: timeList,
  ); // Window size 3, max distance 50m, min time diff 1s
  print('Filtered Distance: $filteredDistance meters');

  // Calculate raw distance (without filtering)
  double rawDistance = LocationUtils.calculateRawDistance(noisyData);
  print('Raw Distance: $rawDistance meters');

  // You'll see that the filtered distance is likely smaller and more accurate.

  // --- Test with Geolocator ---
  //This part need to test on real device.
  /*
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied, we cannot request permissions.');
    return;
  }
  // Get a stream of positions
  List<LatLng> livePositions = [];
  List<DateTime> liveTime = [];
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 0, // Minimum distance (in meters)
     );
  StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position? position) {
        if (position != null) {
          print(position.latitude == null ? '-' : position.latitude.toString());
          livePositions.add(LatLng(position.latitude, position.longitude));
          liveTime.add(DateTime.now());

          // Calculate and display distances
          double liveFilteredDistance = LocationUtils.calculateDistanceCovered(livePositions, 3, 50, 1, timeList: liveTime);
          double liveRawDistance = LocationUtils.calculateRawDistance(livePositions);

          print('Live Filtered Distance: $liveFilteredDistance meters');
          print('Live Raw Distance: $liveRawDistance meters');
          print('Live position count: ${livePositions.length}');

        }
      });


   await Future.delayed(Duration(seconds: 20));// Run for 20 seconds.
   positionStream.cancel(); // Stop listening.
   */
}
