class LocationResult {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  LocationResult({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    return LocationResult(
      name: json['name'] as String? ?? 'Unknown',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
