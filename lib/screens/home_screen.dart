import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../utils/weather_utils.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/header_row.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/search_dialog.dart';
import '../widgets/stat_row.dart';
import '../widgets/weather_hero.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();

  LocationResult _selectedLocation = LocationResult(
    name: 'Addis Ababa',
    country: 'Ethiopia',
    latitude: 8.9806,
    longitude: 38.7578,
  );

  WeatherModel? _weatherData;
  bool _isLoading = true;
  String? _errorMessage;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.fetchWeatherData(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
      );
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _openSearchModal() async {
    final LocationResult? chosenLocation = await showModalBottomSheet<LocationResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SearchDialog(),
    );

    if (chosenLocation != null) {
      setState(() {
        _selectedLocation = chosenLocation;
      });
      _loadWeatherData();
    }
  }

  void _onNavTapped(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    if (index == 1) {
      // Index 1 is Search
      _openSearchModal();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get dynamic background gradient & theme colors based on temperature
    final currentTemp = _weatherData?.current.temperature ?? 20.0;
    final tempTheme = WeatherUtils.getTemperatureTheme(currentTemp);

    return Scaffold(
      backgroundColor: tempTheme.backgroundGradient.first,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: tempTheme.backgroundGradient,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 1. Fixed Header Row at Top
              HeaderRow(
                cityName: _selectedLocation.name,
                countryName: _selectedLocation.country,
                onMenuPressed: _openSearchModal,
                onCalendarPressed: _openSearchModal,
              ),

              // 2. Scrollable Body Content
              Expanded(
                child: _buildBodyContent(tempTheme),
              ),

              // 3. Floating Bottom Navigation Bar
              CustomBottomNav(
                selectedIndex: _currentNavIndex,
                onItemTapped: _onNavTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(TempTheme tempTheme) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(tempTheme.accentColor),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Fetching live weather for ${_selectedLocation.name}...',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Color(0xFFEF4444),
                size: 56,
              ),
              const SizedBox(height: 16),
              Text(
                'Unable to fetch weather data',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadWeatherData,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tempTheme.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final weather = _weatherData!;

    return RefreshIndicator(
      onRefresh: _loadWeatherData,
      color: tempTheme.accentColor,
      backgroundColor: const Color(0xFF1F2232),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Main Weather Display with dynamic glow colors
            WeatherHero(
              temperature: weather.current.temperature,
              weatherCode: weather.current.weatherCode,
              glowColors: tempTheme.glowColors,
            ),

            // Stat Row (Wind, Humidity, Apparent Temp)
            StatRow(
              windSpeed: weather.current.windSpeed,
              humidity: weather.current.humidity,
              apparentTemp: weather.current.apparentTemperature,
            ),
            const SizedBox(height: 16),

            // Hourly Forecast Cards List
            HourlyForecastWidget(
              hourlyList: weather.hourly,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
