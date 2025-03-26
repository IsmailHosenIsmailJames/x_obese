import 'package:geolocator/geolocator.dart';

double calculateDistance(List<Position> latLngList) {
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
