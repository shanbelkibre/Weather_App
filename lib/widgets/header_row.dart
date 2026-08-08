import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderRow extends StatelessWidget {
  final String cityName;
  final String countryName;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onCalendarPressed;

  const HeaderRow({
    super.key,
    this.cityName = 'Addis Ababa',
    this.countryName = 'Ethiopia',
    this.onMenuPressed,
    this.onCalendarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Hamburger menu button (2 horizontal bars)
          InkWell(
            onTap: onMenuPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 14,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // City & Country Title
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cityName,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                ', $countryName',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),

          // Calendar Icon in rounded card
          InkWell(
            onTap: onCalendarPressed,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1D2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF2E3247),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
