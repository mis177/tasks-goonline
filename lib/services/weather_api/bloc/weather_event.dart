import 'package:equatable/equatable.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object?> get props => [];
}

class WeatherRequested extends WeatherEvent {
  const WeatherRequested();
}
