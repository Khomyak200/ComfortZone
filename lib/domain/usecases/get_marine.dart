import 'package:comfort_zone/data/models/marine_model.dart';

import '../../data/repositories/weather_repository.dart';

class GetMarine {
  final WeatherRepository weatherRepository;

  GetMarine({required this.weatherRepository});

  Future<List<Marine>> call(String city, int days, String lang) async {
    return await weatherRepository.getMarine(city, days, lang);
  }
}