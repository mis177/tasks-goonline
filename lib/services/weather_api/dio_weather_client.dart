import 'package:dio/dio.dart';
import 'package:notes_goonline/models/weather_model.dart';

class DioWeatherClient {
  final Dio _dio = Dio();
  final _baseUrl = "http://api.weatherapi.com/v1";

  static final DioWeatherClient _instance = DioWeatherClient._internal();
  DioWeatherClient._internal();
  factory DioWeatherClient() => _instance;

  Future<Weather?> getWeather(
      {required String key, required String location}) async {
    Weather? weather;
    try {
      Response weatherData =
          await _dio.get('$_baseUrl/current.json?key=$key&q=$location');

      weather = Weather.fromJson(weatherData.data);
    } on DioException {
      throw DioException;
    }
    return weather;
  }
}
