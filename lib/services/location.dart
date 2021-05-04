import 'package:geolocator/geolocator.dart';

class Location {
  double mLatitude;
  double mLongitude;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      mLatitude = position.latitude;
      mLongitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }
}
