import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/location_model.dart';
import '../services/weather_service.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  List<LocationResult> _searchResults = [];
  bool _isSearching = false;

  // Preset popular locations for quick selection
  final List<LocationResult> _popularLocations = [
    LocationResult(
        name: 'Addis Ababa',
        country: 'Ethiopia',
        latitude: 8.9806,
        longitude: 38.7578),
    LocationResult(
        name: 'Mumbai',
        country: 'India',
        latitude: 19.0760,
        longitude: 72.8777),
    LocationResult(
        name: 'London',
        country: 'United Kingdom',
        latitude: 51.5074,
        longitude: -0.1278),
    LocationResult(
        name: 'Tokyo',
        country: 'Japan',
        latitude: 35.6762,
        longitude: 139.6503),
    LocationResult(
        name: 'New York',
        country: 'United States',
        latitude: 40.7128,
        longitude: -74.0060),
    LocationResult(
        name: 'Paris',
        country: 'France',
        latitude: 48.8566,
        longitude: 2.3522),
    LocationResult(
        name: 'Dubai',
        country: 'United Arab Emirates',
        latitude: 25.2048,
        longitude: 55.2708),
    LocationResult(
        name: 'Sydney',
        country: 'Australia',
        latitude: -33.8688,
        longitude: 151.2093),
  ];

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final results = await _weatherService.searchLocations(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF141724),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Color(0xFF2A2E44), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF373C54),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'Search City & Country',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),

          // Search TextField
          TextField(
            controller: _searchController,
            style: GoogleFonts.inter(color: Colors.white),
            onChanged: _performSearch,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter city name (e.g. London, Tokyo)...',
              hintStyle: GoogleFonts.inter(color: const Color(0xFF8E95A5)),
              prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF8E95A5)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: Colors.white70),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF1F2336),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Quick Popular Cities Section
          if (_searchController.text.isEmpty) ...[
            Text(
              'Popular Cities',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _popularLocations.map((loc) {
                return ActionChip(
                  label: Text('${loc.name}, ${loc.country}'),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color(0xFF22263A),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () {
                    Navigator.pop(context, loc);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Search Results Header
          if (_searchController.text.isNotEmpty)
            Text(
              _isSearching ? 'Searching...' : 'Search Results',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          const SizedBox(height: 8),

          // Search Results List
          Expanded(
            child: _isSearching
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                    ),
                  )
                : _searchResults.isEmpty && _searchController.text.isNotEmpty
                    ? Center(
                        child: Text(
                          'No cities found for "${_searchController.text}"',
                          style: GoogleFonts.inter(color: const Color(0xFF8E95A5)),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final loc = _searchResults[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            leading: const ContainerIcon(),
                            title: Text(
                              loc.name,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              loc.country,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF6B7280),
                              size: 14,
                            ),
                            onTap: () {
                              Navigator.pop(context, loc);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class ContainerIcon extends StatelessWidget {
  const ContainerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF22263A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.location_on_outlined,
        color: Color(0xFF3B82F6),
        size: 18,
      ),
    );
  }
}
