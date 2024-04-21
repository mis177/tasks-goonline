class Weather {
  final String city;
  final String country;
  final double temperature;
  final String condition;
  final String conditionIconPath;

  Weather(
      {required this.city,
      required this.country,
      required this.temperature,
      required this.condition,
      required this.conditionIconPath});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        city: json["location"]["name"] as String,
        country: json["location"]["country"] as String,
        temperature: json["current"]["temp_c"] as double,
        condition: json["current"]["condition"]["text"] as String,
        conditionIconPath: json["current"]["condition"]["icon"] as String);
  }
}
