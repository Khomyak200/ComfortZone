import 'package:comfort_zone/data/models/air_model.dart';

class CurrentWeather {
  final DateTime lastUpdated;
  final double tempC;
  final double tempF;
  final bool isDay;
  final String conditionText;
  final String conditionIcon;
  final int conditionCode;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double pressureMb;
  final double pressureIn;
  final double precipMm;
  final double precipIn;
  final int humidity;
  final int cloud;
  final double feelsLikeC;
  final double feelsLikeF;
  final double windchillC;
  final double windchillF;
  final double heatindexC;
  final double heatindexF;
  final double dewpointC;
  final double dewpointF;
  final double visKm;
  final double visMiles;
  final double uv;
  final double gustMph;
  final double gustKph;
  final AirQuality? airQuality;

  CurrentWeather({
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.conditionText,
    required this.conditionIcon,
    required this.conditionCode,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.pressureMb,
    required this.pressureIn,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.cloud,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.windchillC,
    required this.windchillF,
    required this.heatindexC,
    required this.heatindexF,
    required this.dewpointC,
    required this.dewpointF,
    required this.visKm,
    required this.visMiles,
    required this.uv,
    required this.gustMph,
    required this.gustKph,
    required this.airQuality,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      lastUpdated: DateTime.parse(json['current']['last_updated']),
      tempC: (json['current']['temp_c'] as num).toDouble(),
      tempF: (json['current']['temp_f'] as num).toDouble(),
      isDay: json['current']['is_day'] == 1,
      conditionText: json['current']['condition']['text'] as String,
      conditionIcon: json['current']['condition']['icon'] as String,
      conditionCode: (json['current']['condition']['code'] as num).toInt(),
      windMph: (json['current']['wind_mph'] as num).toDouble(),
      windKph: (json['current']['wind_kph'] as num).toDouble(),
      windDegree: (json['current']['wind_degree'] as num).toInt(),
      windDir: json['current']['wind_dir'] as String,
      pressureMb: (json['current']['pressure_mb'] as num).toDouble(),
      pressureIn: (json['current']['pressure_in'] as num).toDouble(),
      precipMm: (json['current']['precip_mm'] as num).toDouble(),
      precipIn: (json['current']['precip_in'] as num).toDouble(),
      humidity: (json['current']['humidity'] as num).toInt(),
      cloud: (json['current']['cloud'] as num).toInt(),
      feelsLikeC: (json['current']['feelslike_c'] as num).toDouble(),
      feelsLikeF: (json['current']['feelslike_f'] as num).toDouble(),
      windchillC: (json['current']['windchill_c'] as num).toDouble(),
      windchillF: (json['current']['windchill_f'] as num).toDouble(),
      heatindexC: (json['current']['heatindex_c'] as num).toDouble(),
      heatindexF: (json['current']['heatindex_f'] as num).toDouble(),
      dewpointC: (json['current']['dewpoint_c'] as num).toDouble(),
      dewpointF: (json['current']['dewpoint_f'] as num).toDouble(),
      visKm: (json['current']['vis_km'] as num).toDouble(),
      visMiles: (json['current']['vis_miles'] as num).toDouble(),
      uv: (json['current']['uv'] as num).toDouble(),
      gustMph: (json['current']['gust_mph'] as num).toDouble(),
      gustKph: (json['current']['gust_kph'] as num).toDouble(),
      airQuality: AirQuality.fromJson(json['current']['air_quality']),
    );
  }
}