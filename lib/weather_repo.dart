import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app_3/weather_model.dart';

class WeatherRepo {
  Future<WeatherModel> getWeather(String cityName) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=e9dc0594f093b6f68206638556288d1e");

    try {
      final result = await http.get(url);

      if (result.statusCode == 200) {
        return parsedJson(result.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the weather service');
    }
  }

  WeatherModel parsedJson(final response) {
    final jsonDecoded = jsonDecode(response);
    final jsonWeather = jsonDecoded["main"];
    return WeatherModel.fromJson(jsonWeather);
  }
}
