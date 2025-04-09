import 'package:comfort_zone/data/models/marine_hour_model.dart';
import 'package:comfort_zone/data/models/tide_model.dart';

class Marine {
  final DateTime date;
  final List<Tide> tides;
  final List<MarineHourInfo> hour;

  Marine({
    required this.date,
    required this.tides,
    required this.hour
  });

  factory Marine.fromJson(Map<String, dynamic> json) {
    return Marine(
      date: DateTime.parse(json['date']),
      tides: (json['day']['tides'][0]['tide'] as List)
          .map((json) => Tide.fromJson(json))
          .toList(),
      hour: (json['hour'] as List)
          .map((json) => MarineHourInfo.fromJson(json))
          .toList(),
    );
  }
}