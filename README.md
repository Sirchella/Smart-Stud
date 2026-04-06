# SSEM — Smart Study Environment Monitor

> *"You can't improve what you don't measure."*

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Architecture-MVVM%20%2B%20Riverpod-7B9E4A?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Database-Hive-E8834A?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-9B8EC4?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge" />
</p>

---

## What is SSEM?

SSEM is a cross-platform mobile application built in **Flutter and Dart** that helps university students study more effectively by monitoring the physical quality of their study environment in real time. Most students have no way of knowing whether where they are sitting is actually a good place to study. SSEM answers that question continuously and passively, without interrupting their work.

The app reads from four built-in phone sensors — the **microphone**, the **light sensor**, the **accelerometer**, and the **GPS** — and combines the readings into a single live **Environment Score** between 0 and 100. A high score means the conditions are good. A low score means something is working against concentration, and the student should make a change.

Students can start and track study sessions, review weekly performance charts, and export their data as a PDF report, CSV spreadsheet, or JSON file.

---

## Screenshots

> *(Add your screenshots here once the app is built.)*

| Splash | Dashboard | Session | Reports | Settings |
|--------|-----------|---------|---------|----------|
| splash.png | dashboard.png | session.png | reports.png | settings.png |

---

## Core Features

- **Live environment score** — a single 0–100 number updated every 500ms combining all four sensor readings
- **Noise monitoring** — ambient sound level in decibels via the device microphone using the `noise_meter` package
- **Light monitoring** — illumination in lux via the built-in light sensor using `sensors_plus`
- **Distraction detection** — excessive phone movement counted as distraction events via the accelerometer
- **GPS session tagging** — each session is tagged with a reverse-geocoded location name via `geolocator` + `geocoding`
- **Session management** — start, pause, resume, and end study sessions with a full lifecycle state machine
- **Background recording** — a foreground service keeps the session running when the screen is off
- **Weekly and daily reports** — horizontal pill bar charts showing study session history
- **Contextual suggestions** — tips based on current sensor readings shown in the Reports screen
- **Multi-format export** — export session data as PDF, CSV, or JSON and share via the system share sheet
- **PIN lock + biometric security** — protect personal study data with encrypted PIN or fingerprint via `local_auth`
- **Persistent settings** — customisable thresholds, daily goals, and preferences stored in `SharedPreferences`

---

## Environment Score Algorithm

The environment score is a pure Dart function in `lib/services/score_calculator.dart`, calculated from four weighted components:

| Component | Weight | Logic |
|-----------|--------|-------|
| Noise | 40% | 100 pts if avg noise < 40 dB. Linear scale to 0 at 70 dB. Zero above 70 dB. |
| Light | 30% | 100 pts if avg lux is 300–600. Linear scale from 0 below 100 lux and above 1000 lux. |
| Motion | 20% | 100 pts with zero distraction events. Each event subtracts 10 pts. Minimum 0. |
| Duration | 10% | 100 pts for sessions ≥ 25 minutes. Linear scale from 0 for sessions under 5 minutes. |

---

## Design System

SSEM uses a warm, organic design language inspired by health and wellness app aesthetics. The interface is **beautiful but never distracting** — it sits quietly while the student works.

| Token | Hex | Flutter Color | Usage |
|-------|-----|---------------|-------|
| Background | `#F5F0E8` | `Color(0xFFF5F0E8)` | Scaffold background on all screens |
| Surface card | `#EDE6D8` | `Color(0xFFEDE6D8)` | Light card containers |
| Dark card | `#2D1A0E` | `Color(0xFF2D1A0E)` | Score card, timer card, security |
| Shell/divider | `#E8DFD0` | `Color(0xFFE8DFD0)` | Borders, phone shell, dividers |
| Primary green | `#7B9E4A` | `Color(0xFF7B9E4A)` | Active states, CTA buttons, score arc |
| Green chip bg | `#E8F3D8` | `Color(0xFFE8F3D8)` | Noise sensor chip background |
| Orange | `#E8834A` | `Color(0xFFE8834A)` | Light sensor, secondary accent |
| Orange chip bg | `#FDE8D8` | `Color(0xFFFDE8D8)` | Light sensor chip background |
| Purple | `#9B8EC4` | `Color(0xFF9B8EC4)` | Motion sensor, break indicators |
| Purple chip bg | `#EBE6F5` | `Color(0xFFEBE6F5)` | Motion sensor chip background |
| Muted text | `#8A7A68` | `Color(0xFF8A7A68)` | Labels, subtitles, metadata |
| Card border | `#D4C9B5` | `Color(0xFFD4C9B5)` | Card borders, row dividers |

**Fonts:**
- **DM Serif Display** — score numbers, screen titles, large stats (`GoogleFonts.dmSerifDisplay()`)
- **Sora** — all other text, weights 300–700 (`GoogleFonts.sora()`)

---

## Tech Stack

| Layer | Technology | Package |
|-------|-----------|---------|
| Framework | Flutter | — |
| Language | Dart | — |
| State management | Riverpod | `flutter_riverpod: ^2.4.9` |
| Navigation | go_router | `go_router: ^13.0.0` |
| Fonts | Google Fonts | `google_fonts: ^6.1.0` |
| Animations | Flutter built-in + animations pkg | `animations: ^2.0.11` |
| Database | Hive | `hive: ^2.2.3` + `hive_flutter: ^1.1.0` |
| Noise sensor | noise_meter | `noise_meter: ^6.0.1` |
| Light + Accel | sensors_plus | `sensors_plus: ^4.0.2` |
| GPS | geolocator | `geolocator: ^11.0.0` |
| Reverse geocode | geocoding | `geocoding: ^3.0.0` |
| Permissions | permission_handler | `permission_handler: ^11.3.0` |
| PDF export | pdf | `pdf: ^3.10.7` |
| CSV export | csv | `csv: ^6.0.0` |
| File sharing | share_plus | `share_plus: ^7.2.2` |
| Open files | open_file | `open_file: ^3.3.2` |
| PIN storage | flutter_secure_storage | `flutter_secure_storage: ^9.0.0` |
| Biometric | local_auth | `local_auth: ^2.1.8` |
| PIN hashing | crypto | `crypto: ^3.0.3` |
| Notifications | flutter_local_notifications | `flutter_local_notifications: ^17.0.0` |
| Background service | flutter_background_service | `flutter_background_service: ^5.0.5` |
| Date formatting | intl | `intl: ^0.19.0` |
| SVG icons | flutter_svg | `flutter_svg: ^2.0.9` |

---

## Project Structure

```
ssem/
├── lib/
│   ├── main.dart                        App entry point, MaterialApp, theme, routes
│   ├── theme/
│   │   ├── app_colors.dart              All Color constants (Flutter 0xFF format)
│   │   └── app_text_styles.dart         All TextStyle presets using GoogleFonts
│   ├── screens/
│   │   ├── splash_screen.dart           Animated splash with score ring + progress bar
│   │   ├── dashboard_screen.dart        Home screen with live sensor display
│   │   ├── session_screen.dart          Active session timer + chart + controls
│   │   ├── reports_screen.dart          Study summary, bar chart, suggestions, export
│   │   └── settings_screen.dart         Thresholds, preferences, security
│   ├── widgets/
│   │   ├── score_ring.dart              ScoreRingPainter CustomPainter
│   │   ├── metric_row.dart              Single sensor metric row with sparkline
│   │   ├── mini_sparkline.dart          40x20 mini line chart CustomPainter
│   │   ├── noise_chart.dart             Full session noise line chart
│   │   ├── session_bar_chart.dart       Horizontal pill bar chart for reports
│   │   ├── pulsing_dot.dart             Animated recording indicator
│   │   ├── main_nav_bar.dart            Bottom navigation bar with active dot
│   │   ├── pill_button.dart             Reusable pill button (dark / green / end)
│   │   ├── filter_pills.dart            Report period filter row
│   │   ├── suggestion_row.dart          AI suggestion list item with chevron
│   │   ├── toggle_row.dart              Settings toggle row
│   │   └── threshold_row.dart           Settings slider row with progress bar
│   ├── providers/
│   │   ├── sensor_provider.dart         Aggregates all 4 live sensor streams
│   │   ├── session_provider.dart        Session lifecycle state machine
│   │   ├── reports_provider.dart        Analytics state and export state
│   │   └── settings_provider.dart       All user preference state
│   ├── services/
│   │   ├── noise_monitor.dart           Microphone sampling via noise_meter
│   │   ├── light_monitor.dart           Light sensor via sensors_plus
│   │   ├── motion_monitor.dart          Accelerometer distraction counter
│   │   ├── location_service.dart        GPS fix + reverse geocoding
│   │   ├── score_calculator.dart        Pure Dart score algorithm (no Flutter deps)
│   │   ├── session_recording_service.dart  Background foreground service
│   │   ├── pdf_exporter.dart            PDF report generation
│   │   ├── csv_exporter.dart            CSV file generation
│   │   └── security_service.dart        PIN hashing + biometric auth
│   ├── models/
│   │   └── session.dart                 Session HiveObject data class
│   └── db/
│       └── hive_service.dart            Hive box setup + query methods
├── test/
│   ├── score_calculator_test.dart       Unit tests for score algorithm
│   ├── session_state_test.dart          Unit tests for session lifecycle
│   └── hive_service_test.dart           Unit tests for database queries
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.19.0 or newer
- Dart SDK 3.3.0 or newer
- Android Studio or VS Code with Flutter extension
- A **physical device** is strongly recommended — emulators do not have a real microphone or light sensor

Check your Flutter setup:

```bash
flutter doctor
```

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Sirchella/SSEM.git
cd SSEM
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Generate Hive adapters**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**4. Run on a connected device**

```bash
flutter run
```

**5. Build a release APK**

```bash
flutter build apk --release
```

The APK is output to `build/app/outputs/flutter-apk/app-release.apk`.

**6. Install via ADB**

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Run all tests

```bash
flutter test
```

A test summary is printed to the terminal on completion.

---

## Required Permissions

| Permission | Platform | Reason |
|------------|----------|--------|
| `RECORD_AUDIO` | Android | Microphone access for noise level sampling (runtime) |
| `ACCESS_FINE_LOCATION` | Android | GPS tagging of session location (runtime) |
| `ACCESS_COARSE_LOCATION` | Android | Fallback if fine location is denied |
| `NSMicrophoneUsageDescription` | iOS | Required in Info.plist for microphone |
| `NSLocationWhenInUseUsageDescription` | iOS | Required in Info.plist for GPS |
| `USE_BIOMETRIC` | Android | Fingerprint / face unlock |
| `FOREGROUND_SERVICE` | Android | Background session recording |
| `FOREGROUND_SERVICE_MICROPHONE` | Android | Required on API 34+ for mic in foreground service |

All runtime permissions are requested before the first session starts using `permission_handler`. If a permission is denied, the affected feature is gracefully disabled.

---

## Architecture

SSEM follows **MVVM** with Riverpod for state management and a clear service layer separating the UI from sensor logic and data persistence.

```
UI Layer (Screens + Widgets)
        ↕  ref.watch() / ref.read()
Provider Layer (Riverpod StateNotifiers)
        ↕  calls service methods
Service Layer (Sensors + Score + Export + Security)
        ↕  reads / writes
Data Layer (Hive DB + SharedPreferences + SecureStorage)
```

---

## UML — Key Classes

```
main.dart
└── MaterialApp (go_router)
    ├── SplashScreen ──────────────────────────────────────────
    ├── DashboardScreen ──→ ref.watch(sensorProvider)
    │                       sensorProvider ──→ SensorRepository
    │                                         ├── NoiseMonitor
    │                                         ├── LightMonitor
    │                                         ├── MotionMonitor
    │                                         └── LocationService
    ├── SessionScreen ────→ ref.watch(sessionProvider)
    │                       sessionProvider ──→ SessionRecordingService
    │                                          └── HiveService → Session
    ├── ReportsScreen ────→ ref.watch(reportsProvider)
    │                       reportsProvider ──→ HiveService
    │                                          ├── PdfExporter
    │                                          └── CsvExporter
    └── SettingsScreen ───→ ref.watch(settingsProvider)
                            settingsProvider ──→ SharedPreferences
                                               └── SecurityService

Session (HiveObject)
├── id: int
├── startTimeMs: int
├── endTimeMs: int
├── durationMs: int
├── avgNoiseDb: double
├── peakNoiseDb: double
├── avgLightLux: double
├── motionEventCount: int
├── envScore: int
├── locationTag: String
├── latitudeDeg: double
├── longitudeDeg: double
├── exportedPdf: bool
└── exportedCsv: bool
```

---

## Design Plan

**Visual concept:** Warm cream and chocolate brown — calm, focused, organic. Never clinical or cold. The interface sits quietly while the student works.

**Reference designs borrowed from:**
- Subash Chandra Smart Home App UI — dark card system with coloured sensor chip icons, metric rows with mini sparklines, suggestion rows with chevrons
- George Railean Satellite Network Intelligence UI — scanning arc animation around the score ring, pulsing recording indicator, live data stream density
- Georg Finnbogason Particles exploration — animated floating particle field on the splash screen

**Colour system:** 12 colour tokens across cream, brown, green, orange, and purple families — all defined in `lib/theme/app_colors.dart`

**Typography:** DM Serif Display (display, scores, titles) + Sora 300–700 (all other text) — both via `google_fonts`

**Screen flow:** Splash → Dashboard ↔ Session ↔ Reports ↔ Settings

**Navigation:** go_router with shell route. Session screen hides bottom nav while active.

---

## Deployment Plan

### Development

```bash
# Get dependencies and generate Hive adapters
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Run on connected device (debug mode)
flutter run

# Run all tests
flutter test
```

### Production

```bash
# Build release APK (Android)
flutter build apk --release

# Build release App Bundle (Google Play)
flutter build appbundle --release

# Install APK directly via ADB
adb install build/app/outputs/flutter-apk/app-release.apk
```

### One-line full build and test

```bash
flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs && flutter test && flutter build apk --release
```

---

## Team

| Name | Role | Responsibilities |
|------|------|-----------------|
| **AJA CHELLA ASAMBA JR** | Main Developer | All screens and widgets, design system, animations, custom painters, navigation, provider observation layer |
| **NJINDA BRIAN JR** | QA / Test Developer | Sensor services, Hive database, session lifecycle, score algorithm, export engines, security, unit tests |

**Institution:** ICT University of Cameroon
**Registration numbers:** ICTU20233787 · ICTU20234467
**Course:** Android Application Development
**Year:** 2026

---

## License

This project is submitted as coursework for the Android Application Development course at ICT University of Cameroon. All rights reserved.

---

<p align="center">
  Built with Flutter &nbsp;·&nbsp; ICT University of Cameroon &nbsp;·&nbsp; 2026<br>
  <strong>AJA CHELLA ASAMBA JR</strong> &nbsp;·&nbsp; <strong>NJINDA BRIAN JR</strong>
</p>
