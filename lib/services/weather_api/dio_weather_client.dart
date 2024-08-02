import 'package:dio/dio.dart';
import 'package:notes_goonline/models/weather_model.dart';

class DioWeatherClient {
  final Dio _dio;
  final _baseUrl = "http://api.weatherapi.com/v1";

  static final DioWeatherClient _instance = DioWeatherClient._internal();
  DioWeatherClient._internal() : _dio = Dio() {
    _configureDio();
  }

  factory DioWeatherClient() => _instance;

  void _configureDio() {
    _dio.options
      ..baseUrl = _baseUrl
      ..connectTimeout = const Duration(milliseconds: 5000) // 5 seconds
      ..receiveTimeout = const Duration(milliseconds: 3000); // 3 seconds
  }

  Future<Weather?> getWeather({required String key, required String location}) async {
    try {
      final Response response = await _dio.get(
        '/current.json',
        queryParameters: {
          'key': key,
          'q': location,
        },
      );

      if (response.statusCode == 200) {
        return Weather.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } on DioException catch (e) {
      // Handle specific DioException cases if needed
      throw Exception('DioException: ${e.message}');
    } catch (e) {
      // Handle general exceptions
      throw Exception('Unexpected error: $e');
    }
  }
}
