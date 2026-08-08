# Implementation Plan - Modern Dark Weather App UI

We will build a high-fidelity, single-screen Flutter weather app UI strictly matching the user's provided design aesthetic and Open-Meteo API requirements.

## Architecture & Visual Design Overview

### Theme & Palette
- **Background**: Smooth linear dark navy gradient (`#0B0C11` to `#181A25`).
- **Ambient Glow**: Soft amber/orange radial gradient (`#E67E22` at ~35% opacity fading out) placed behind the central weather graphic using `Stack` and `RadialGradient`.
- **Card Styling**: Lighter translucent navy containers (`#1D2030`) with soft rounded corners (`16px - 24px radius`) and subtle borders.
- **Typography**: Clean sans-serif typography via Google Fonts (Inter), using bold main temp digits, crisp white primary text, and light-gray secondary labels (`#9CA3AF`).

### Layout Structure (Top-to-Bottom)
1. **Header Row**: Custom 2-line menu icon (left), bold "Addis Ababa" + light gray "Ethiopia" (center), calendar icon inside a rounded box (right).
2. **Main Weather Display**:
   - Stylized 3D Sun + Rain Cloud weather graphic centered over the warm amber glow.
   - Temperature display ("29°C") with large bold digits and superscript degree symbol (`Text.rich` / `WidgetSpan`).
   - Condition sentence dynamically derived from Open-Meteo `weather_code` (e.g., "Expect high rain today.").
3. **Weather Metrics Row**:
   - 3 evenly spaced stat widgets using `Row` + `Expanded`:
     - Wind Speed (`11 km/h`)
     - Humidity (`84%`)
     - Apparent Temp (`18.8°C`)
4. **Hourly Forecast Section**:
   - Title header with clock icon ("Hourly Forecast").
   - Horizontal `ListView.builder` of forecast cards (Time label, small weather icon, temperature).
5. **Floating Bottom Navigation Bar**:
   - Pill-shaped floating container with rounded corners and dark glassmorphic fill.
   - 4 navigation icons: Home (active highlighted pill/icon), Search, Notifications, Map (inactive gray).

---

## User Review Required

> [!IMPORTANT]
> - The latitude (`8.9806`) and longitude (`38.7578`) for Addis Ababa are hardcoded as specified in the prompt.
> - Data fetching will use `http` package with a simple `StatefulWidget` handling Loading, Error (with retry button), and Success states.

---

## Proposed File Architecture

### [NEW] `pubspec.yaml`
Add dependencies: `http`, `intl`, `google_fonts`.

### [NEW] `lib/models/weather_model.dart`
- `WeatherModel`: Contains `CurrentWeather` and `List<HourlyForecast>`.
- `CurrentWeather`: Parses `temperature_2m`, `relative_humidity_2m`, `apparent_temperature`, `precipitation`, `weather_code`, `wind_speed_10m`.
- `HourlyForecast`: Parses time, temperature, and weather code for individual hours.

### [NEW] `lib/services/weather_service.dart`
- `WeatherService`: Performs HTTP GET request to Open-Meteo API endpoint, checks 200 response status, and returns parsed `WeatherModel`.

### [NEW] `lib/utils/weather_utils.dart`
- Maps WMO numeric `weather_code` (0..99) to human-readable condition text, weather icons, and descriptive summary strings (e.g., "Expect high rain today.").

### [NEW] `lib/screens/home_screen.dart`
- Main screen container wrapped in a dark gradient `Scaffold`.
- `StatefulWidget` managing API fetch lifecycle (`isLoading`, `errorMessage`, `weatherData`).
- Pull-to-refresh / retry support.

### [NEW] `lib/widgets/`
- `header_row.dart`: Hamburger menu icon, location text, calendar button.
- `weather_hero.dart`: Radial glow stack, weather graphic, giant temp display, condition text.
- `stat_row.dart`: Wind, Humidity, and Apparent Temp indicators.
- `hourly_forecast.dart`: Hourly forecast section header and horizontal card list.
- `custom_bottom_nav.dart`: Floating pill bottom navigation bar.
- `weather_icon_graphic.dart`: High-fidelity Flutter custom painted / styled weather graphic (sun + cloud + rain drops).

---

## Verification Plan

### Automated Verification
- Run `flutter pub get` to ensure all packages resolve.
- Run `dart analyze` to ensure strict null-safety and 0 static analysis errors.

### Manual Verification
- Check UI layout fidelity against the user's reference image.
- Test loading and retry state handling.
