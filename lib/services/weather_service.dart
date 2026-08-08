import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  /// Fetches weather data for a specific latitude and longitude
  Future<WeatherModel> fetchWeatherData({
    double latitude = 8.9806,
    double longitude = 38.7578,
  }) async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,wind_direction_10m&hourly=temperature_2m,weather_code';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load weather data (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Network error while fetching weather data: $e');
    }
  }

  /// Searches for city/country locations using Open-Meteo Geocoding API
  Future<List<LocationResult>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    final url =
        'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(query)}&count=10&language=en&format=json';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('results') && data['results'] != null) {
          final List results = data['results'];
          return results.map((item) => LocationResult.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
