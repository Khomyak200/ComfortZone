import 'package:comfort_zone/data/models/air_model.dart';
import 'package:comfort_zone/data/models/hour_model.dart';
import 'package:intl/intl.dart';

class Forecast {
  final DateTime date;
  final double maxtempC;
  final double maxtempF;
  final double mintempC;
  final double mintempF;
  final double avgtempC;
  final double avgtempF;
  final double maxwindMph;
  final double maxwindKph;
  final double totalprecipMm;
  final double totalprecipIn;
  final double totalsnowCm;
  final double avgvisKm;
  final double avgvisMiles;
  final double avghumidity;
  final bool dailyWillItRain;
  final bool dailyChanceOfRain;
  final bool dailyWillItSnow;
  final bool dailyChanceOfSnow;
  final String conditionText;
  final String conditionIcon;
  final int code;
  final double uv;
  final AirQuality? airQuality;
  final DateTime? sunrise;
  final DateTime? sunset;
  final DateTime? moonrise;
  final DateTime? moonset;
  final String moonPhase;
  final int moonIllumination;
  final bool isMoonUp;
  final bool isSunUp;
  final List<HourInfo> hour;

  Forecast({
    required this.date,
    required this.maxtempC,
    required this.maxtempF,
    required this.mintempC,
    required this.mintempF,
    required this.avgtempC,
    required this.avgtempF,
    required this.maxwindMph,
    required this.maxwindKph,
    required this.totalprecipMm,
    required this.totalprecipIn,
    required this.totalsnowCm,
    required this.avgvisKm,
    required this.avgvisMiles,
    required this.avghumidity,
    required this.dailyWillItRain,
    required this.dailyChanceOfRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfSnow,
    required this.conditionText,
    required this.conditionIcon,
    required this.code,
    required this.uv,
    required this.airQuality,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.moonIllumination,
    required this.isMoonUp,
    required this.isSunUp,
    required this.hour
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['date']),
      maxtempC: (json['day']['maxtemp_c'] as num).toDouble(),
      maxtempF: (json['day']['maxtemp_f'] as num).toDouble(),
      mintempC: (json['day']['mintemp_c'] as num).toDouble(),
      mintempF: (json['day']['mintemp_f'] as num).toDouble(),
      avgtempC: (json['day']['avgtemp_c'] as num).toDouble(),
      avgtempF: (json['day']['avgtemp_f'] as num).toDouble(),
      maxwindMph: (json['day']['maxwind_mph'] as num).toDouble(),
      maxwindKph: (json['day']['maxwind_kph'] as num).toDouble(),
      totalprecipMm: (json['day']['totalprecip_mm'] as num).toDouble(),
      totalprecipIn: (json['day']['totalprecip_in'] as num).toDouble(),
      totalsnowCm: (json['day']['totalsnow_cm'] as num).toDouble(),
      avgvisKm: (json['day']['avgvis_km'] as num).toDouble(),
      avgvisMiles: (json['day']['avgvis_miles'] as num).toDouble(),
      avghumidity: (json['day']['avghumidity'] as num).toDouble(),
      dailyWillItRain: json['day']['daily_will_it_rain'] == 1,
      dailyChanceOfRain: json['day']['daily_chance_of_rain'] == 1,
      dailyWillItSnow: json['day']['daily_will_it_snow'] == 1,
      dailyChanceOfSnow: json['day']['daily_chance_of_snow'] == 1,
      conditionText: json['day']['condition']['text'] as String,
      conditionIcon: json['day']['condition']['icon'] as String,
      code: json['day']['condition']['code'] as int,
      uv: (json['day']['uv'] as num).toDouble(),
      airQuality: AirQuality.fromJson(json['day']['air_quality']),
      sunrise: parseSunrise(json['astro']['sunrise'] as String),
      sunset: parseSunrise(json['astro']['sunset'] as String),
      moonrise: parseSunrise(json['astro']['moonrise'] as String),
      moonset: parseSunrise(json['astro']['moonset'] as String),
      moonPhase: json['astro']['moon_phase'] as String,
      moonIllumination: int.parse(json['astro']['moon_illumination'].toString()),
      isMoonUp: json['astro']['is_moon_up'] == 1,
      isSunUp: json['astro']['is_sun_up'] == 1,
      hour: (json['hour'] as List)
          .map((json) => HourInfo.fromJson(json))
          .toList(),
    );
  }
}

DateTime? parseSunrise(String? time) {
  if (time == null || time.isEmpty) {
    return null;
  }

  try {
    return DateFormat('hh:mm a').parseStrict(time);
  } on FormatException {
    return null;
  }
}