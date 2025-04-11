import 'package:comfort_zone/data/api_client.dart';
import 'package:comfort_zone/data/repositories/weather_repository.dart';
import 'package:comfort_zone/domain/usecases/get_agro_warning.dart';
import 'package:comfort_zone/domain/usecases/get_forecast_weather.dart';
import 'package:comfort_zone/domain/usecases/get_gidro_warning.dart';
import 'package:comfort_zone/domain/usecases/get_marine.dart';
import 'package:comfort_zone/domain/usecases/get_storm_warning.dart';
import 'package:comfort_zone/domain/usecases/get_today_weather.dart';
import 'package:comfort_zone/state/weather/weather_view_model.dart';
import 'package:flutter/material.dart';
import 'package:comfort_zone/presentation/screens/home_screen.dart';
import 'package:comfort_zone/presentation/screens/profiles_screen.dart';
import 'package:comfort_zone/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';

void main() {
  //Getdata();
  final apiClient = ApiClient();
  final weatherRepository = WeatherRepository(apiClient: apiClient);
  
  final weatherViewModel = WeatherViewModel(
    getTodayWeather: GetTodayWeather(weatherRepository: weatherRepository),
    getWeekForecast: GetWeekForecast(weatherRepository: weatherRepository),
    getGidroWarning: GetGidroWarning(weatherRepository: weatherRepository),
    getAgroWarning: GetAgroWarning(weatherRepository: weatherRepository),
    getStormWarning: GetStormWarning(weatherRepository: weatherRepository),
    getMarine: GetMarine(weatherRepository: weatherRepository),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => weatherViewModel,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final weatherViewModel = Provider.of<WeatherViewModel>(
      context,
      listen: false,
    );
    
    //weatherViewModel.fetchWeather(27.5618, 53.9023, 10, "en");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Погода',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfilesScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}


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
      await weatherViewModel.fetchWeather("Minsk", 10, "en"); 
      if (weatherViewModel.weatherInfo != null && weatherViewModel.forecast != null &&
          weatherViewModel.gidroWarning != null && weatherViewModel.agroWarning != null &&
          weatherViewModel.stormWarning != null && weatherViewModel.marine != null) {
        // Данные успешно получены
        // Вся инфа о погоде на сегодня в weatherViewModel.weatherInfo
        // Прогноз погоды в weatherViewModel.forecast

        // airQuality нужно проверять на null, api дает только на 4 дня инфу
        // sunrise, sunset, moonrise, moonset тоже нужно проверять на null, т.к. moonset вообще может не быть 🤔
        int x = 9;
      }
      int d = 4;
  }