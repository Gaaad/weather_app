import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/weather_model.dart';

class WeatherService {
  Future<WeatherData> fetchWeatherData(String city, int index) async {
    const apiKey = 'abbb52ef005a4c6cb9b131232232903';
    final url =
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&aqi=no&alerts=no';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherData.fromJson(jsonDecode(response.body), index);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
