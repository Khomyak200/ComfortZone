import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:comfort_zone/core/app_constants.dart';

class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint, String city, int days, String lang) async {
    final uri = Uri.https(Constants.weatherApiUrl, endpoint, {
      'key': Constants.weatherApiKey,
      'q': city,
      'days': days.toString(),
      'aqi': 'yes',
      'alerts': 'yes',
      'lang': lang
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}



