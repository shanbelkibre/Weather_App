import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/weather_model.dart';
import '../utils/weather_utils.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<HourlyForecast> hourlyList;

  const HourlyForecastWidget({
    super.key,
    required this.hourlyList,
  });

  @override
  Widget build(BuildContext context) {
    // Show next 6-8 hourly forecasts
    final displayItems = hourlyList.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Hourly Forecast',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Horizontal List of Hourly Cards
        SizedBox(
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: displayItems.length,
            itemBuilder: (context, index) {
              final forecast = displayItems[index];
              final isFirst = index == 0;

              // Format time label (e.g. "Now" for 1st item, "5pm" for subsequent)
              String timeStr;
              if (isFirst) {
                timeStr = 'Now';
              } else {
                timeStr = DateFormat('ha')
                    .format(forecast.time)
                    .toLowerCase(); // "5pm", "6pm"
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  width: 82,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isFirst
                        ? const Color(0xFF222638)
                        : const Color(0xFF191B28),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isFirst
                          ? const Color(0xFF333852)
                          : const Color(0xFF24273A),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Mini weather icon representation
                      _buildMiniWeatherIcon(forecast.weatherCode),

                      // Time label
                      Text(
                        timeStr,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight:
                              isFirst ? FontWeight.w600 : FontWeight.w400,
                          color: isFirst
                              ? Colors.white
                              : const Color(0xFFD1D5DB),
                        ),
                      ),

                      // Temperature display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${forecast.temperature.round()}',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '°',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMiniWeatherIcon(int code) {
    // Custom mini weather graphic or icon
    return Stack(
      alignment: Alignment.center,
      children: [
        // Subtle orange sun glow
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFF9800).withValues(alpha: 0.8),
          ),
        ),
        Icon(
          WeatherUtils.getWeatherIconData(code),
          color: Colors.white,
          size: 26,
        ),
      ],
    );
  }
}
