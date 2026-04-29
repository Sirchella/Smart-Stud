# SSEM — Smart Study Environment Monitor

> *"You can't improve what you don't measure."*

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/State-Riverpod-7B9E4A?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-9B8EC4?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge" />
</p>

---

## What is SSEM?

SSEM is a cross-platform mobile application built in **Flutter and Dart** that helps students study more effectively by monitoring the physical quality of their study environment in real time.

The app reads from five sensor inputs — the **microphone**, the **light sensor**, the **accelerometer**, the **GPS**, and the **camera (heart rate)** — and scores them against the user's own definition of their ideal study space.

You define what your perfect environment looks like (noise level, lighting, heart rate, motion tolerance). The app then measures how closely your current conditions match that ideal, and continuously nudges you toward it.

---

## Screenshots

> *(Add your screenshots here once the app is built.)*

| Splash | Dashboard | Session | Reports | Settings |
|--------|-----------|---------|---------|----------|
| splash.png | dashboard.png | session.png | reports.png | settings.png |

---

## Core Features

- **Live environment score** — a 0–100 composite updated in real time, scored against *your* personal ideal
- **Ideal environment profile** — define your perfect study space (noise, light, heart rate, motion limit); the app measures how closely your current conditions match it and shows a % match badge on the dashboard
- **"Capture as ideal" shortcut** — one tap in Settings snapshots your current conditions and saves them as your new ideal
- **Noise monitoring** — ambient sound level in decibels via the device microphone (native Android `MediaRecorder` through a Flutter MethodChannel)
- **Light monitoring** — illumination in lux via the built-in light sensor using the `light` package
- **Heart rate (PPG)** — tap MEASURE on the dashboard, place your fingertip over the back camera lens; the torch illuminates your skin and the app detects blood-volume pulses to calculate BPM
- **Distraction detection** — excessive phone movement counted as distraction events via the accelerometer (`sensors_plus`)
- **GPS session tagging** — each session is tagged with the device's GPS location via `geolocator`
- **Session management** — start, pause, and stop study sessions with a live duration timer and alert counter
- **Session history** — browse past sessions filtered by 1 week, 1 month, or all time
- **Multi-format export** — export session data as PDF or CSV and share via the system share sheet
- **Dark / Light theme** — toggle between themes in Settings

---

## Environment Score Algorithm

All scoring is relative to the **user's own ideal profile** — not fixed defaults.

| Component | How it's scored |
|-----------|----------------|
| Noise | `100 − |currentDB − idealDB|` — full score when you're at your ideal level |
| Light | `100 − (|currentLux − idealLux| / 10)` — full score at your ideal brightness |
| Motion | `−(excessEvents × 5)` penalty — events beyond your tolerance limit |
| Heart rate | `−(|currentBPM − idealBPM| × 1.5)` penalty (max −30 pts) |
| **Total** | `((noise + light) / 2) − motion penalty − HR penalty` |

**Match %** — shown as a badge on the dashboard — answers "how close is this spot to my ideal right now?"

| Score | Status |
|-------|--------|
| 85 – 100 | Great |
| 60 – 84 | Good |
| 40 – 59 | Fair |
| 0 – 39 | Poor |

---

## Design System

SSEM uses a warm, organic design language — calm and focused, never clinical or distracting.

| Token | Hex | Usage |
|-------|-----|-------|
| Background | `#F5F0E8` | Scaffold background |
| Surface card | `#EDE6D8` | Card containers |
| Dark card | `#2D1A0E` | Score card, navigation bar |
| Primary green | `#7B9E4A` | Active states, CTA buttons, score arc |
| Orange | `#E8834A` | Light sensor, secondary accent |
| Purple | `#9B8EC4` | Motion sensor |
| Muted text | `#8A7A68` | Labels, subtitles |

**Font:** IBM Plex Sans via `google_fonts` (Bold, Medium, Regular weights)

---

## Tech Stack

| Layer | Technology | Package |
|-------|-----------|---------|
| Framework | Flutter 3+ | — |
| Language | Dart | — |
| State management | Riverpod 2 | `flutter_riverpod: ^2.4.0` |
| Noise sensor | Native Android MediaRecorder | MethodChannel `com.ssem.ssem/noise` |
| Light sensor | light package | `light: ^5.0.0` |
| Accelerometer | sensors_plus | `sensors_plus: ^4.0.2` |
| GPS | geolocator | `geolocator: ^14.0.2` |
| Heart rate (PPG) | camera | `camera: ^0.11.0` |
| Profile persistence | shared_preferences | `shared_preferences: ^2.2.2` |
| Permissions | permission_handler | `permission_handler: ^12.0.1` |
| PDF export | pdf | `pdf: ^3.10.7` |
| CSV export | csv | `csv: ^6.0.0` |
| File sharing | share_plus | `share_plus: ^7.1.0` |
| Charts | fl_chart | `fl_chart: ^0.63.0` |
| Fonts | Google Fonts | `google_fonts: ^6.1.0` |
| SVG icons | flutter_svg | `flutter_svg: ^2.0.7` |
| Animations | animations | `animations: ^2.0.8` |
| Date formatting | intl | `intl: ^0.18.1` |

---

## Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/colors.dart       # SSEM color palette
│   └── theme/app_theme.dart        # Light & dark themes
├── screens/
│   ├── splash_screen.dart          # Animated splash with logo fade-in
│   ├── dashboard_screen.dart       # Home — live score + 4-metric grid
│   ├── session_screen.dart         # Active session timer + alerts
│   ├── reports_screen.dart         # History, filters, PDF/CSV export
│   └── settings_screen.dart        # Thresholds, theme toggle, privacy
├── providers/
│   ├── environment_provider.dart   # Score calc — reads profile + sensors + HR
│   ├── sensor_provider.dart        # All four environmental sensor streams
│   ├── heart_rate_provider.dart    # Camera PPG heart rate measurement
│   ├── profile_provider.dart       # User's ideal environment (SharedPreferences)
│   ├── session_provider.dart       # Active session state machine
│   ├── theme_provider.dart         # Dark/light toggle
│   └── export_service_provider.dart
├── services/
│   ├── pdf_service.dart            # PDF report generation
│   └── export_service.dart         # CSV data export
└── widgets/
    ├── glass_card.dart             # Glassmorphism card (backdrop blur)
    └── bottom_navbar.dart          # Custom bottom navigation bar
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Android Studio or VS Code with the Flutter extension
- A **physical Android device** is strongly recommended — emulators do not have a real microphone or light sensor

Check your Flutter setup:

```bash
flutter doctor
```

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Sirchella/Smart-Stud.git
cd Smart-Stud
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Run on a connected device**

```bash
flutter run
```

### Android USB Debugging

1. Enable **Developer Options** on your Android device
2. Turn on **USB Debugging**
3. Connect via USB and accept the **"Allow USB debugging?"** prompt on the phone
4. Run `flutter devices` to confirm your device is listed
5. Run `flutter run -d <device-id>`

### Build APK

```bash
# Debug
flutter build apk --debug

# Release
flutter build apk --release

# Install via ADB
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## Required Permissions

| Permission | Platform | Reason |
|------------|----------|--------|
| `RECORD_AUDIO` | Android | Microphone access for noise level sampling |
| `ACCESS_FINE_LOCATION` | Android | GPS tagging for each session |
| `ACCESS_COARSE_LOCATION` | Android | Fallback network-based location |
| `HIGH_SAMPLING_RATE_SENSORS` | Android | Accelerometer + light sensor access |
| `WRITE_EXTERNAL_STORAGE` | Android ≤ 9 | PDF / CSV file export |
| `CAMERA` | Android | Heart rate measurement via camera PPG |
| `VIBRATE` | Android | Haptic feedback on distraction alerts |

All runtime permissions are requested before the first session starts. If a permission is denied the affected sensor is gracefully disabled.

---

## Architecture

SSEM follows an **MVVM** pattern with Riverpod for reactive state management and a service layer separating UI from sensor logic.

```
UI Layer (Screens + Widgets)
        ↕  ref.watch() / ref.read()
Provider Layer (Riverpod StateNotifiers)
        ↕  calls service methods
Service Layer (Sensors · Score · Export)
        ↕  native platform channels / packages
Hardware (Microphone · Light · Accelerometer · GPS)
```

---

## Known Issues

- **Google Fonts offline** — IBM Plex Sans fails to load when the device has no internet connection. The app falls back to a system font. Fix: bundle fonts locally as assets in `pubspec.yaml`.
- **iOS noise monitoring** — The native `MediaRecorder` MethodChannel (`com.ssem.ssem/noise`) is Android-only. iOS noise support is not yet implemented.

---

## Team

| Name | Role |
|------|------|
| **AJA CHELLA ASAMBA JR** | UI / Screens / Design |
| **NJINDA BRIAN JR** | Sensors / State / Export / Testing |

**Institution:** ICT University of Cameroon  
**Course:** Android Application Development  
**Year:** 2026

---

## License

Submitted as coursework for the Android Application Development course at ICT University of Cameroon. All rights reserved.

---

<p align="center">
  Built with Flutter &nbsp;·&nbsp; ICT University of Cameroon &nbsp;·&nbsp; 2026<br>
  <strong>AJA CHELLA ASAMBA JR</strong> &nbsp;·&nbsp; <strong>NJINDA BRIAN JR</strong>
</p>
