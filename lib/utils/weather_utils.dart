import 'package:flutter/material.dart';

class TempTheme {
  final List<Color> backgroundGradient;
  final List<Color> glowColors;
  final Color accentColor;
  final String label;

  const TempTheme({
    required this.backgroundGradient,
    required this.glowColors,
    required this.accentColor,
    required this.label,
  });
}

class WeatherUtils {
  /// Returns a dynamic theme based on temperature
  static TempTheme getTemperatureTheme(double temp) {
    if (temp < 15.0) {
      // Cold / Chilly Theme (Cool Ice Cyan / Navy)
      return TempTheme(
        backgroundGradient: const [
          Color(0xFF081220),
          Color(0xFF0E1C30),
          Color(0xFF14253F),
        ],
        glowColors: [
          const Color(0xFF00E5FF).withValues(alpha: 0.35),
          const Color(0xFF0288D1).withValues(alpha: 0.20),
          Colors.transparent,
        ],
        accentColor: const Color(0xFF00E5FF),
        label: 'Cool',
      );
    } else if (temp <= 25.0) {
      // Mild / Moderate Theme (Classic Amber Glow)
      return TempTheme(
        backgroundGradient: const [
          Color(0xFF0B0C11),
          Color(0xFF141622),
          Color(0xFF1A1C29),
        ],
        glowColors: [
          const Color(0xFFE67E22).withValues(alpha: 0.32),
          const Color(0xFFD35400).withValues(alpha: 0.18),
          Colors.transparent,
        ],
        accentColor: const Color(0xFFE67E22),
        label: 'Mild',
      );
    } else {
      // Hot / Warm Theme (Fiery Sunset Orange & Crimson)
      return TempTheme(
        backgroundGradient: const [
          Color(0xFF160A14),
          Color(0xFF24101F),
          Color(0xFF2C1322),
        ],
        glowColors: [
          const Color(0xFFFF5252).withValues(alpha: 0.38),
          const Color(0xFFFF7043).withValues(alpha: 0.22),
          Colors.transparent,
        ],
        accentColor: const Color(0xFFFF5722),
        label: 'Warm',
      );
    }
  }

  /// Converts Open-Meteo WMO weather code into human readable short description
  static String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Clear sky';
      case 1:
        return 'Mainly clear';
      case 2:
        return 'Partly cloudy';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Light Drizzle';
      case 56:
      case 57:
        return 'Freezing Drizzle';
      case 61:
        return 'Slight Rain';
      case 63:
        return 'Moderate Rain';
      case 65:
        return 'Heavy Rain';
      case 66:
      case 67:
        return 'Freezing Rain';
      case 71:
      case 73:
      case 75:
      case 77:
        return 'Snowfall';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 85:
      case 86:
        return 'Snow Showers';
      case 95:
      case 96:
      case 99:
        return 'Thunderstorm';
      default:
        return 'Rainy';
    }
  }

  /// Converts Open-Meteo WMO weather code into condition sentence for UI
  static String getWeatherSentence(int code) {
    switch (code) {
      case 0:
        return 'Expect clear skies today.';
      case 1:
      case 2:
        return 'Expect mild clouds today.';
      case 3:
        return 'Overcast conditions expected.';
      case 45:
      case 48:
        return 'Expect fog and reduced visibility.';
      case 51:
      case 53:
      case 55:
        return 'Expect light drizzle throughout the day.';
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return 'Expect high rain today.';
      case 71:
      case 73:
      case 75:
      case 85:
      case 86:
        return 'Expect snow showers today.';
      case 95:
      case 96:
      case 99:
        return 'Thunderstorm warning today.';
      default:
        return 'Expect rain today.';
    }
  }

  /// Returns Flutter IconData corresponding to WMO code
  static IconData getWeatherIconData(int code) {
    switch (code) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
      case 2:
        return Icons.wb_cloudy_rounded;
      case 3:
        return Icons.cloud_rounded;
      case 45:
      case 48:
        return Icons.blur_on_rounded;
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return Icons.grain_rounded;
      case 71:
      case 73:
      case 75:
        return Icons.ac_unit_rounded;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_rounded;
      default:
        return Icons.grain_rounded;
    }
  }
}
