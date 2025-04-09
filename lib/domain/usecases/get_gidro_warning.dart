import 'package:comfort_zone/core/app_constants.dart';
import 'package:comfort_zone/data/models/warnings_model.dart';
import '../../data/repositories/weather_repository.dart';

class GetGidroWarning {
  final WeatherRepository weatherRepository;

  GetGidroWarning({required this.weatherRepository});

  Future<WarningsModel> call() async {
    return await weatherRepository.getWarning(Constants.belgidrometNews, Constants.belgidrometGidro);
  }
}