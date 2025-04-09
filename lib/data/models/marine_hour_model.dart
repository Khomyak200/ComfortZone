class MarineHourInfo {
  final DateTime time;
  final double sigHtMt;
  final double swellHtMt;
  final double swellHtFt;
  final double swellDir;
  final String swellDir16Point;
  final double swellPeriodSecs;
  final double waterTempC;
  final double waterTempF;

  MarineHourInfo({
    required this.time,
    required this.sigHtMt,
    required this.swellHtMt,
    required this.swellHtFt,
    required this.swellDir, 
    required this.swellDir16Point,
    required this.swellPeriodSecs,
    required this.waterTempC,
    required this.waterTempF
  });

  factory MarineHourInfo.fromJson(Map<String, dynamic> json) {
    return MarineHourInfo(
      time: DateTime.parse(json['time']),
      sigHtMt: (json['sig_ht_mt'] as num).toDouble(),
      swellHtMt: (json['swell_ht_mt'] as num).toDouble(),
      swellHtFt: (json['swell_ht_ft'] as num).toDouble(),
      swellDir: (json['swell_dir'] as num).toDouble(),
      swellDir16Point: json['swell_dir_16_point'] as String,
      swellPeriodSecs: (json['swell_period_secs'] as num).toDouble(),
      waterTempC: (json['temp_c'] as num).toDouble(),
      waterTempF: (json['temp_f'] as num).toDouble()
    );
  }
}