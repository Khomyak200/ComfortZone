import '../../data/repositories/weather_repository.dart';
import '../../data/models/weather_model.dart';

class GetTodayWeather {
  final WeatherRepository weatherRepository;

  GetTodayWeather({required this.weatherRepository});

  Future<CurrentWeather> call(String city, int days, String lang) async {
    return await weatherRepository.getCurrentWeather(city, days, lang);
  }
}