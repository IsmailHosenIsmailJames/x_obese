import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateDistance(List<LatLng> latLngList) {
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

double calculateDistanceWithSmoothCarve(List<LatLng> latLngList) {
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
