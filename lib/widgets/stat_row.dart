import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatRow extends StatelessWidget {
  final double windSpeed;
  final int humidity;
  final double apparentTemp;

  const StatRow({
    super.key,
    required this.windSpeed,
    required this.humidity,
    required this.apparentTemp,
  });

  @override
  Widget build(BuildContext context) {
    final formattedHumidity = humidity < 10 ? '0$humidity%' : '$humidity%';
    final formattedWind = '${windSpeed.round()}km/hr';
    final formattedApparent = '${apparentTemp.round()}°C';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Icons.air_rounded,
              label: formattedWind,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.water_drop_outlined,
              label: formattedHumidity,
            ),
          ),
          Expanded(
            child: _buildStatItem(
              icon: Icons.wb_sunny_outlined,
              label: formattedApparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.9),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
