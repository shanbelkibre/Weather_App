import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/weather_utils.dart';
import 'weather_icon_graphic.dart';

class WeatherHero extends StatelessWidget {
  final double temperature;
  final int weatherCode;
  final String? customConditionText;
  final List<Color>? glowColors;

  const WeatherHero({
    super.key,
    required this.temperature,
    required this.weatherCode,
    this.customConditionText,
    this.glowColors,
  });

  @override
  Widget build(BuildContext context) {
    final conditionSentence =
        customConditionText ?? WeatherUtils.getWeatherSentence(weatherCode);
    final tempVal = temperature.round();

    final defaultGlow = [
      const Color(0xFFE67E22).withValues(alpha: 0.32),
      const Color(0xFFD35400).withValues(alpha: 0.18),
      Colors.transparent,
    ];

    return Column(
      children: [
        const SizedBox(height: 10),
        // Stack for Radial Glow + Weather Icon Graphic
        Stack(
          alignment: Alignment.center,
          children: [
            // Dynamic Radial Temperature Glow
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              width: 280,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.65,
                  colors: glowColors ?? defaultGlow,
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
            // 3D Weather Icon Graphic
            const WeatherIconGraphic(size: 185),
          ],
        ),
        const SizedBox(height: 12),

        // Giant Temperature Text ("29° C")
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$tempVal',
              style: GoogleFonts.inter(
                fontSize: 54,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.0,
              ),
            ),
            const SizedBox(width: 2),
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '°',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                'C',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Condition Sentence
        Text(
          conditionSentence,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: const Color(0xFFD1D5DB),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
