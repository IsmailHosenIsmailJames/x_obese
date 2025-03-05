import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  static Future<bool> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    return true;
  }

  static Future<Position?> getUserLocation() async {
    if (await checkAndRequestPermission()) {
      return await Geolocator.getCurrentPosition();
    } else {
      return null;
    }
  }

  static Future<List<Placemark>> getAddressPlacemark(LatLng position) async {
    return await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
  }

  static String getAddressString(List<Placemark> placemarkList) {
    if (placemarkList.isEmpty) {
      return "Unknown Location";
    }

    Placemark placemark = placemarkList.first;
    String address = "";

    if (placemark.street != null && placemark.street!.isNotEmpty) {
      address += placemark.street!;
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      if (address.isNotEmpty) {
        address += ", ";
      }
      address += placemark.subLocality!;
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      if (address.isNotEmpty) {
        address += ", ";
      }
      address += placemark.locality!;
    }
    if (placemark.subAdministrativeArea != null &&
        placemark.subAdministrativeArea!.isNotEmpty) {
      if (address.isNotEmpty) {
        address += ", ";
      }
      address += placemark.subAdministrativeArea!;
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      if (address.isNotEmpty) {
        address += ", ";
      }
      address += placemark.administrativeArea!;
    }
    if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
      if (address.isNotEmpty) {
        address += ", ";
      }
      address += placemark.postalCode!;
    }
    if (placemark.country != null && placemark.country!.isNotEmpty) {
      if (address.isNotEmpty) {
        address += ", ";
      }
      address += placemark.country!;
    }

    return address;
  }
}
