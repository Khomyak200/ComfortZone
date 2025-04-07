import '../../data/repositories/weather_repository.dart';
import '../../data/models/forecast_model.dart';

class GetWeekForecast {
  final WeatherRepository weatherRepository;

  GetWeekForecast({required this.weatherRepository});

  Future<List<Forecast>> call(String city, int days, String lang) async {
    return await weatherRepository.getForecastForWeek(city, days, lang);
  }
}