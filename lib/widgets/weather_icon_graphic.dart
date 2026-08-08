import 'package:flutter/material.dart';

/// A rich 3D-styled custom weather graphic matching the reference UI
/// (Glowing orange sun behind a smooth 3D cloud with glossy blue rain droplets)
class WeatherIconGraphic extends StatelessWidget {
  final double size;

  const WeatherIconGraphic({
    super.key,
    this.size = 170,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Sun (Golden Orange 3D Sphere placed behind the cloud)
          Positioned(
            top: size * 0.08,
            left: size * 0.24,
            child: Container(
              width: size * 0.48,
              height: size * 0.48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  center: Alignment(-0.3, -0.4),
                  radius: 0.85,
                  colors: [
                    Color(0xFFFFCC80),
                    Color(0xFFFFA726),
                    Color(0xFFFB8C00),
                    Color(0xFFE65100),
                  ],
                  stops: [0.0, 0.4, 0.75, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.5),
                    blurRadius: 25,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),

          // 2. Main 3D Rain Cloud
          Positioned(
            top: size * 0.28,
            left: size * 0.12,
            right: size * 0.12,
            child: Container(
              height: size * 0.42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size * 0.22),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0xFFF0F4F8),
                    Color(0xFFD9E2EC),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: const Color(0xFF0077FF).withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Upper left cloud puff
                  Positioned(
                    top: -size * 0.16,
                    left: size * 0.08,
                    child: Container(
                      width: size * 0.26,
                      height: size * 0.26,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFE8EEF5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Upper right cloud puff
                  Positioned(
                    top: -size * 0.22,
                    right: size * 0.14,
                    child: Container(
                      width: size * 0.32,
                      height: size * 0.32,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFE2E9F0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Three Glossy Blue Raindrops hanging below the cloud
          Positioned(
            bottom: size * 0.08,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRaindrop(size, -0.2),
                SizedBox(width: size * 0.06),
                _buildRaindrop(size, 0.0, isLonger: true),
                SizedBox(width: size * 0.06),
                _buildRaindrop(size, 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRaindrop(double size, double angle, {bool isLonger = false}) {
    final dropHeight = isLonger ? size * 0.22 : size * 0.17;
    final dropWidth = size * 0.07;

    return Transform.rotate(
      angle: 0.25, // Slight tilt matching design
      child: Container(
        width: dropWidth,
        height: dropHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dropWidth / 2),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00B0FF),
              Color(0xFF0091EA),
              Color(0xFF01579B),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00B0FF).withValues(alpha: 0.6),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }
}
