import 'package:flutter/material.dart';
import 'package:notes_goonline/models/weather_model.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key, required this.weather});
  final Weather weather;
  @override
  Widget build(BuildContext context) {
    String iconPath = (weather.conditionIconPath.replaceFirst('//', 'http://'));
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(iconPath),
            const SizedBox(width: 12),
            Text(
              '${weather.temperature}°C',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        Text(
          weather.condition,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          weather.city,
          style: const TextStyle(fontSize: 20),
        ),
        Text(weather.country),
      ],
    );
  }
}
