import 'package:comfort_zone/core/app_constants.dart';

import '../api_client.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherRepository {
  final ApiClient apiClient;

  WeatherRepository({required this.apiClient});

  Future<CurrentWeather> getCurrentWeather(String city, int days, String lang) async {
    final data = await apiClient.get(Constants.currentPath, city, days, lang);
    return CurrentWeather.fromJson(data);
  }

  Future<List<Forecast>> getForecastForWeek(String city, int days, String lang) async {
    final data = await apiClient.get(Constants.forecastPath, city, days, lang);
    final List<dynamic> list = data['forecast']['forecastday'];
    return list.map((json) => Forecast.fromJson(json)).toList();
  }
}