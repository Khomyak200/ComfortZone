class Tide {
  final DateTime time;
  final String heightMt;
  final String type;

  Tide({
    required this.time,
    required this.heightMt,
    required this.type
  });

  factory Tide.fromJson(Map<String, dynamic> json) {
    return Tide(
      time: DateTime.parse(json['tide_time']),
      heightMt: json['tide_height_mt'] as String,
      type: json['tide_type'] as String
    );
  }
}