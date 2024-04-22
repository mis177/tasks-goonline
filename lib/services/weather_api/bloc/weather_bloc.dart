import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:notes_goonline/const/api_key.dart';
import 'package:notes_goonline/models/weather_model.dart';
import 'package:notes_goonline/services/weather_api/bloc/weather_event.dart';
import 'package:notes_goonline/services/weather_api/bloc/weather_state.dart';
import 'package:notes_goonline/services/weather_api/dio_weather_client.dart';
import 'package:notes_goonline/services/weather_api/locator.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(DioWeatherClient weatherDioClient)
      : super(const WeatherInitial()) {
    on<WeatherRequested>((event, emit) async {
      emit(const WeatherLoading());
      Exception? exception;
      Weather? currentWeather;

      try {
        Position position = await getPosition();
        currentWeather = await weatherDioClient.getWeather(
            key: weatherApiKey,
            location: '${position.latitude},${position.longitude}');
      } on Exception catch (e) {
        exception = e;
      }
      emit(WeatherLoaded(weather: currentWeather, exception: exception));
    });
  }
}
