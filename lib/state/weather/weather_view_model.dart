import 'package:comfort_zone/data/models/forecast_model.dart';
import 'package:comfort_zone/data/models/weather_model.dart';
import 'package:comfort_zone/domain/usecases/get_forecast_weather.dart';
import 'package:comfort_zone/domain/usecases/get_today_weather.dart';
import 'package:flutter/material.dart';

class WeatherViewModel extends ChangeNotifier {
  final GetTodayWeather getTodayWeather;
  final GetWeekForecast getWeekForecast;

  WeatherViewModel({
    required this.getTodayWeather,
    required this.getWeekForecast,
  });

  CurrentWeather? _weatherInfo;
  List<Forecast>? _forecast;
  bool _isLoading = false;
  String? _error;

  CurrentWeather? get weatherInfo => _weatherInfo;
  List<Forecast>? get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather(String city, int days, String lang) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weatherInfo = await getTodayWeather(city, days, lang);
      _forecast = await getWeekForecast(city, days, lang);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

/*

Future<void> Getdata() async {
      final apiClient = ApiClient();
      final weatherRepository = WeatherRepository(apiClient: apiClient);
      final getTodayWeather = GetTodayWeather(weatherRepository: weatherRepository);
      final getWeekForecast = GetWeekForecast(weatherRepository: weatherRepository);
      final weatherViewModel = WeatherViewModel(
        getTodayWeather: getTodayWeather,
        getWeekForecast: getWeekForecast,
      );
      
      // город можно так писать: "Minsk", но лучше "Minsk,by"
      // 14 - кол-во дней для прогноза
      // "en" - язык, может быть ru, ua, и наподобии
      await weatherViewModel.fetchWeather("Minsk", 14, "en"); 
      if (weatherViewModel.weatherInfo != null && weatherViewModel.forecast != null) {
        // Данные успешно получены
        // Вся инфа о погоде на сегодня в weatherViewModel.weatherInfo
        // Прогноз погоды в weatherViewModel.forecast

        // airQuality нужно проверять на null, api дает только на 4 дня инфу
        // sunrise, sunset, moonrise, moonset тоже нужно проверять на null, т.к. moonset вообще может не быть 🤔
      }
  }

  */
  