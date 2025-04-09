class WarningItem {
  final String title;
  final String pubDate;
  final String? level; // только для шторомовых предупреждений
  final String description;

  WarningItem({
    required this.title,
    required this.pubDate,
    required this.level,
    required this.description
  });

  factory WarningItem.fromJson(Map<String, dynamic> json) {
    return WarningItem(
      title: json['title'] as String,
      pubDate: json['pubDate'] as String,
      level: json['level'] as String?,
      description: json['description'] as String
    );
  }
}