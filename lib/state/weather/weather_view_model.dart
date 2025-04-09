import 'package:comfort_zone/data/models/forecast_model.dart';
import 'package:comfort_zone/data/models/marine_model.dart';
import 'package:comfort_zone/data/models/warnings_model.dart';
import 'package:comfort_zone/data/models/weather_model.dart';
import 'package:comfort_zone/domain/usecases/get_agro_warning.dart';
import 'package:comfort_zone/domain/usecases/get_forecast_weather.dart';
import 'package:comfort_zone/domain/usecases/get_gidro_warning.dart';
import 'package:comfort_zone/domain/usecases/get_marine.dart';
import 'package:comfort_zone/domain/usecases/get_storm_warning.dart';
import 'package:comfort_zone/domain/usecases/get_today_weather.dart';
import 'package:flutter/material.dart';

class WeatherViewModel extends ChangeNotifier {
  final GetTodayWeather getTodayWeather;
  final GetWeekForecast getWeekForecast;
  final GetGidroWarning getGidroWarning;
  final GetAgroWarning getAgroWarning;
  final GetStormWarning getStormWarning;
  final GetMarine getMarine;

  WeatherViewModel({
    required this.getTodayWeather,
    required this.getWeekForecast, 
    required this.getGidroWarning,
    required this.getAgroWarning,
    required this.getStormWarning,
    required this.getMarine,
  });

  CurrentWeather? _weatherInfo;
  List<Forecast>? _forecast;
  WarningsModel? _gidroWarning;
  WarningsModel? _agroWarning;
  WarningsModel? _stormWarning;
  List<Marine>? _marine;
  bool _isLoading = false;
  String? _error;

  CurrentWeather? get weatherInfo => _weatherInfo;
  List<Forecast>? get forecast => _forecast;
  WarningsModel? get gidroWarning => _gidroWarning;
  WarningsModel? get agroWarning => _agroWarning;
  WarningsModel? get stormWarning => _stormWarning;
  List<Marine>? get marine => _marine;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchWeather(String city, int days, String lang) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weatherInfo = await getTodayWeather(city, days, lang);
      _forecast = await getWeekForecast(city, days, lang);
      _gidroWarning = await getGidroWarning();
      _agroWarning = await getAgroWarning();
      _stormWarning = await getStormWarning();
      _marine = await getMarine(city, days, lang);
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
      final getGidroWarning = GetGidroWarning(weatherRepository: weatherRepository);
      final getAgroWarning = GetAgroWarning(weatherRepository: weatherRepository);
      final getStormWarning = GetStormWarning(weatherRepository: weatherRepository);
      final getMarine = GetMarine(weatherRepository: weatherRepository);
      final weatherViewModel = WeatherViewModel(
        getTodayWeather: getTodayWeather,
        getWeekForecast: getWeekForecast,
        getGidroWarning: getGidroWarning,
        getAgroWarning: getAgroWarning,
        getStormWarning: getStormWarning,
        getMarine: getMarine,
      );
      
      // город можно так писать: "Minsk", но лучше "Minsk,by"
      // 14 - кол-во дней для прогноза
      // "en" - язык, может быть ru, ua, и наподобии
      await weatherViewModel.fetchWeather("Minsk", 14, "en"); 
      if (weatherViewModel.weatherInfo != null && weatherViewModel.forecast != null &&
          weatherViewModel.gidroWarning != null && weatherViewModel.agroWarning != null &&
          weatherViewModel.stormWarning != null && weatherViewModel.marine != null) {
        // Данные успешно получены
        // Вся инфа о погоде на сегодня в weatherViewModel.weatherInfo
        // Прогноз погоды в weatherViewModel.forecast

        // airQuality нужно проверять на null, api дает только на 4 дня инфу
        // sunrise, sunset, moonrise, moonset тоже нужно проверять на null, т.к. moonset вообще может не быть 🤔
      }
  }

  */
  