import 'package:geolocator/geolocator.dart';
import 'package:notes_goonline/services/weather_api/weather_exceptions.dart';

Future<Position> getPosition() async {
  bool isServiceEnabled;
  LocationPermission permission;

  isServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isServiceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw WeatherPermissionDenied();
      // return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw WeatherPermissionDenied();
    //return Future.error(WeatherPermissionDenied);
  }

  return await Geolocator.getCurrentPosition();
}
