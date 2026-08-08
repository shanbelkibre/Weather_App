import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemTapped;

  const CustomBottomNav({
    super.key,
    this.selectedIndex = 0,
    this.onItemTapped,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _handleTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (widget.onItemTapped != null) {
      widget.onItemTapped!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1E2E),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFF2B2F45),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded),
          _buildNavItem(1, Icons.search_rounded),
          _buildNavItem(2, Icons.notifications_none_rounded),
          _buildNavItem(3, Icons.map_outlined),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => _handleTap(index),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF2A2E44),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0077FF).withValues(alpha: 0.15),
                    blurRadius: 8,
                  ),
                ],
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF8E95A5),
          size: 24,
        ),
      ),
    );
  }
}
