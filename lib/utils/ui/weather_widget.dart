import 'package:flutter/material.dart';
import 'package:notes_goonline/models/weather_model.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key, required this.weather});
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    // Ensure the URL is properly formatted
    String iconPath = weather.conditionIconPath.replaceFirst('//', 'http://');

    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding around the widget
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use Image.network with error handling and fixed size
              SizedBox(
                width: 50,
                height: 50,
                child: Image.network(
                  iconPath,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 50);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${weather.temperature}°C',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            weather.condition,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            weather.city,
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(
            weather.country,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
