import 'package:equatable/equatable.dart';
import 'package:notes_goonline/models/weather_model.dart';

sealed class WeatherState extends Equatable {
  final Exception? exception;
  const WeatherState({this.exception});
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  final Weather? weather;

  const WeatherLoaded({required this.weather, required super.exception});

  @override
  List<Object?> get props => [weather];
}
