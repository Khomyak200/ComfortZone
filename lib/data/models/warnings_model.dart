import 'package:comfort_zone/data/models/warning_info_item_model.dart';
class WarningsModel {
  final String title;
  final List<WarningItem> items;

  WarningsModel({
    required this.title,
    required this.items,
  });

  factory WarningsModel.fromJson(Map<String, dynamic> json) {
    return WarningsModel(
      title: json['title'] as String,
      items: (json['warnings'] as List)
          .map((json) => WarningItem.fromJson(json))
          .toList(),
    );
  }
}