import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherResult {
  final String description;
  final double tempC;

  WeatherResult({required this.description, required this.tempC});
}

class WeatherService {
  static const _apiKey = 'YOUR_OPENWEATHERMAP_API_KEY_HERE';

  Future<WeatherResult> getWeather(double lat, double lon) async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');

    final resp = await http.get(uri);
    if (resp.statusCode != 200) {
      throw Exception('Weather API error: ${resp.statusCode}');
    }
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final desc = (data['weather'] as List).first['description'] as String;
    final temp = (data['main']['temp'] as num).toDouble();
    return WeatherResult(description: desc, tempC: temp);
  }
}
