import 'dart:convert';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
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
    //final data = getAccountsData(Constants.belgidrometPath, Constants.belgidrometGidro);
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getWarning(String endpoint, String category) async {
    final uri = Uri.https(
      Constants.belgidrometApiUrl, endpoint,
      {
        'category': category
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final document = XmlDocument.parse(decodedBody);
      final channel = document.getElement('rss')?.getElement('channel');
      if (channel != null) {
        final title = channel.getElement('title')?.text;
        final description = channel.getElement('description')?.text;
        
        final warnings = channel.findAllElements('item').map((item) {
          return {
            'title': item.getElement('title')?.text,
            'link': item.getElement('link')?.text,
            'description': item.getElement('description')?.text,
            'pubDate': item.getElement('pubDate')?.text,
            'level': item.getElement('level')?.text,
          };
        }).toList();
        
        return {
          'title': title,
          'description': description,
          'warnings': warnings,
        };
      } else {
        throw Exception('Invalid RSS format');
      }
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
