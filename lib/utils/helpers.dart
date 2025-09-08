import 'package:geolocator/geolocator.dart';

Future<bool> checkGPSstatus() async {
  bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission permission = await Geolocator.checkPermission();
  bool hasLocationPermission =
      permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
  if (!isLocationEnabled || !hasLocationPermission) {
    return false;
  } else {
    return true;
  }
}
