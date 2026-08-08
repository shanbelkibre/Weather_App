class CurrentWeather {
  final double temperature;
  final int humidity;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final int windDirection;
  final DateTime time;

  CurrentWeather({
    required this.temperature,
    required this.humidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.windDirection,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      windDirection: (json['wind_direction_10m'] as num).toInt(),
      time: DateTime.parse(json['time'] as String),
    );
  }
}

class HourlyForecast {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature'] as num).toDouble(),
      weatherCode: (json['weatherCode'] as num).toInt(),
    );
  }
}

class WeatherModel {
  final double latitude;
  final double longitude;
  final CurrentWeather current;
  final List<HourlyForecast> hourly;

  WeatherModel({
    required this.latitude,
    required this.longitude,
    required this.current,
    required this.hourly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>;
    final hourlyJson = json['hourly'] as Map<String, dynamic>;

    final times = (hourlyJson['time'] as List).cast<String>();
    final temps = (hourlyJson['temperature_2m'] as List).cast<num>();
    final codes = (hourlyJson['weather_code'] as List).cast<num>();

    final List<HourlyForecast> hourlyList = [];

    // Filter hourly forecast starting from current hour or immediate next hours
    final now = DateTime.now();
    for (int i = 0; i < times.length; i++) {
      final itemTime = DateTime.parse(times[i]);
      // Keep relevant hours (same day from current hour or future)
      if (itemTime.isAfter(now.subtract(const Duration(hours: 1)))) {
        hourlyList.add(
          HourlyForecast(
            time: itemTime,
            temperature: temps[i].toDouble(),
            weatherCode: codes[i].toInt(),
          ),
        );
      }
    }

    return WeatherModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      current: CurrentWeather.fromJson(currentJson),
      hourly: hourlyList.isEmpty
          ? List.generate(
              times.length < 24 ? times.length : 24,
              (i) => HourlyForecast(
                time: DateTime.parse(times[i]),
                temperature: temps[i].toDouble(),
                weatherCode: codes[i].toInt(),
              ),
            )
          : hourlyList,
    );
  }
}
