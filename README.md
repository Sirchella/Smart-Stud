# SSEM — Smart Study Environment Monitor

> *"You can't improve what you don't measure."*

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" />
  <img src="https://img.shields.io/badge/Language-Kotlin-7F52FF?style=for-the-badge&logo=kotlin&logoColor=white" />
  <img src="https://img.shields.io/badge/Architecture-MVVM-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Database-Room-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Min%20SDK-26-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Status-In%20Development-yellow?style=for-the-badge" />
</p>

---

## What is SSEM?

SSEM is a native Android application that helps university students study more effectively by monitoring the physical quality of their study environment in real time. Most students have no way of knowing whether where they are sitting is actually a good place to study. SSEM answers that question continuously and passively, without interrupting their work.

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
- **Noise monitoring** — ambient sound level in decibels via the device microphone using AudioRecord
- **Light monitoring** — illumination in lux via the built-in light sensor
- **Distraction detection** — excessive phone movement counted as distraction events via the accelerometer
- **GPS session tagging** — each session is tagged with a reverse-geocoded location name
- **Session management** — start, pause, resume, and end study sessions with full lifecycle control
- **Background recording** — a foreground service keeps the session running when the screen is off
- **Weekly and daily reports** — horizontal bar charts showing study session history
- **AI-style suggestions** — contextual tips based on your current sensor readings
- **Multi-format export** — export session data as PDF, CSV, or JSON
- **PIN lock + biometric security** — protect personal study data with encrypted PIN or fingerprint
- **Persistent settings** — customisable thresholds, daily goals, and preferences via DataStore

---

## Environment Score Algorithm

The environment score is calculated at the end of each session from four weighted components:

| Component | Weight | Logic |
|-----------|--------|-------|
| Noise | 40% | 100 pts if avg noise < 40 dB. Linear scale to 0 at 70 dB. Zero above 70 dB. |
| Light | 30% | 100 pts if avg lux is 300–600. Linear scale from 0 below 100 lux and above 1000 lux. |
| Motion | 20% | 100 pts with zero distraction events. Each event subtracts 10 pts. Minimum 0. |
| Duration | 10% | 100 pts for sessions ≥ 25 minutes. Linear scale from 0 for sessions under 5 minutes. |

---

## Design

SSEM uses a warm, organic design system. The interface is built to be **beautiful but never distracting** — it sits quietly while you study.

| Token | Value | Usage |
|-------|-------|-------|
| Background | `#F5F0E8` | Screen scaffold background |
| Surface card | `#EDE6D8` | Light card surfaces |
| Dark card | `#2D1A0E` | Score card, timer card, security rows |
| Primary green | `#7B9E4A` | Active states, CTA button, score arc |
| Orange | `#E8834A` | Light sensor, secondary actions |
| Purple | `#9B8EC4` | Motion sensor, break indicators |
| Muted text | `#8A7A68` | Labels, subtitles, metadata |

**Fonts:** DM Serif Display (scores, titles) + Sora (all other text)

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Kotlin |
| UI | Android XML Layouts + ConstraintLayout |
| Design components | Material Design 3 |
| Architecture | MVVM + Hilt 2.50 |
| Navigation | Navigation Component (single Activity) |
| Async | Kotlin Coroutines + Flow |
| Database | Room 2.6 + SQLite |
| Preferences | DataStore Preferences |
| Charts | MPAndroidChart v3.1.0 |
| Animations | ValueAnimator + ObjectAnimator + AnimatedVectorDrawable |
| Particle background | Custom SurfaceView (Canvas + Paint) |
| Noise sensor | AudioRecord API |
| Light + Motion | SensorManager (TYPE_LIGHT + TYPE_ACCELEROMETER) |
| GPS | FusedLocationProviderClient + Geocoder |
| PDF export | iText 7 |
| CSV export | OpenCSV |
| JSON export | Gson |
| Security | Jetpack Security Crypto + BiometricPrompt |
| Background service | Foreground Service + flutter_local_notifications |
| Testing | JUnit 4 + Mockito Kotlin + Coroutines Test |

---

## Project Structure

```
ssem/
├── app/
│   └── src/main/
│       ├── java/com/ssem/app/
│       │   ├── MainActivity.kt
│       │   ├── ui/
│       │   │   ├── splash/          SplashActivity.kt
│       │   │   ├── dashboard/       DashboardFragment.kt + ViewModel
│       │   │   ├── session/         SessionFragment.kt + ViewModel
│       │   │   ├── reports/         ReportsFragment.kt + ViewModel
│       │   │   └── settings/        SettingsFragment.kt + ViewModel
│       │   ├── sensors/
│       │   │   ├── NoiseMonitor.kt
│       │   │   ├── LightMonitor.kt
│       │   │   ├── MotionMonitor.kt
│       │   │   └── LocationMonitor.kt
│       │   ├── data/
│       │   │   ├── db/              AppDatabase.kt + SessionDao.kt
│       │   │   ├── models/          Session.kt
│       │   │   └── repository/      SessionRepository.kt + SensorRepository.kt
│       │   ├── service/
│       │   │   └── SessionRecordingService.kt
│       │   ├── export/
│       │   │   ├── PdfExporter.kt
│       │   │   ├── CsvExporter.kt
│       │   │   └── JsonExporter.kt
│       │   ├── security/
│       │   │   ├── SecurityService.kt
│       │   │   └── BiometricHelper.kt
│       │   ├── score/
│       │   │   └── ScoreCalculator.kt
│       │   ├── views/
│       │   │   ├── ParticleView.kt
│       │   │   ├── EnvironmentScoreView.kt
│       │   │   └── PulseView.kt
│       │   └── di/
│       │       ├── AppModule.kt
│       │       ├── DatabaseModule.kt
│       │       └── SensorModule.kt
│       └── res/
│           ├── layout/              XML layouts for all 5 screens
│           ├── navigation/          nav_main.xml
│           ├── values/              colors.xml, strings.xml, themes.xml
│           ├── font/                dm_serif_display.ttf, sora_*.ttf
│           └── anim/                fade_in.xml, fade_out.xml
├── build.gradle
└── README.md
```

---

## Getting Started

### Prerequisites

- Android Studio Hedgehog (2023.1.1) or newer
- JDK 17
- Android SDK 34
- A physical Android device running Android 8.0 (API 26) or higher is strongly recommended for sensor testing. Emulators do not have a real microphone or light sensor.

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Sirchella/SSEM.git
cd SSEM
```

**2. Open in Android Studio**

Open Android Studio → File → Open → select the `SSEM` folder. Wait for Gradle to sync.

**3. Build from the command line**

```bash
./gradlew assembleDebug
```

**4. Install on a connected device**

```bash
adb install app/build/outputs/apk/debug/app-debug.apk
```

**5. Run all unit tests**

```bash
./gradlew test
```

A test report is generated at `app/build/reports/tests/testDebugUnitTest/index.html`.

---

## Required Permissions

| Permission | Reason |
|------------|--------|
| `RECORD_AUDIO` | Microphone access for noise level sampling (runtime) |
| `ACCESS_FINE_LOCATION` | GPS tagging of session start location (runtime) |
| `ACCESS_COARSE_LOCATION` | Fallback location if fine location denied (runtime) |
| `USE_BIOMETRIC` | Fingerprint / face unlock (declared only) |
| `FOREGROUND_SERVICE` | Background session recording |
| `FOREGROUND_SERVICE_MICROPHONE` | Required on API 34+ for mic in foreground service |

All runtime permissions are requested before the first session starts. If a permission is denied, the affected feature is gracefully disabled.

---

## Team

| Name | Role | Responsibilities |
|------|------|-----------------|
| **AJA CHELLA ASAMBA JR** | Main Developer | All UI layouts, custom Views, animations, particle background, design system, navigation, ViewModel layer |
| **NJINDA BRIAN JR** | QA / Test Developer | Sensor monitors, Room database, session lifecycle, score algorithm, export engines, security, unit tests |

**Institution:** ICT University of Cameroon
**Course:** Android Application Development
**Year:** 2026

---

## UML Class Diagram

```
MainActivity
└── NavHostFragment
    ├── DashboardFragment ──→ DashboardViewModel ──→ SensorRepository
    │                                                 ├── NoiseMonitor
    │                                                 ├── LightMonitor
    │                                                 ├── MotionMonitor
    │                                                 └── LocationMonitor
    ├── SessionFragment ───→ SessionViewModel ───→ SessionRepository
    │                                              └── AppDatabase → SessionDao
    ├── ReportsFragment ──→ ReportsViewModel ───→ SessionRepository
    └── SettingsFragment ─→ SettingsViewModel ──→ SettingsRepository
                                                 └── DataStore Preferences

Session (HiveObject / Room Entity)
├── id: Long (PK)
├── startTimeMs: Long
├── endTimeMs: Long
├── durationMs: Long
├── avgNoiseDb: Float
├── peakNoiseDb: Float
├── avgLightLux: Float
├── motionEventCount: Int
├── envScore: Int
├── locationTag: String
├── latitudeDeg: Double
├── longitudeDeg: Double
├── exportedPdf: Boolean
└── exportedCsv: Boolean

Export classes
├── PdfExporter.export(sessions) → File
├── CsvExporter.export(sessions) → File
└── JsonExporter.export(sessions) → File
```

---

## Design Plan

**Visual concept:** Warm cream and chocolate brown — calm, focused, organic. Never clinical or cold.

**Reference designs:**
- Subash Chandra's Smart Home App UI — dark card system, coloured sensor chip icons, metric rows with sparklines, suggestion rows with chevrons
- George Railean's Satellite Network Intelligence UI — scanning arc animation around the score ring, pulsing recording indicator, mission-control data density
- Georg Finnbogason's Particles exploration — animated floating particle field background on every screen

**Colour system:** 12 tokens across cream, brown, green, orange, and purple families — see Design section above

**Typography:** DM Serif Display (display) + Sora (body)

**Screen flow:** Splash → Dashboard ↔ Session ↔ Reports ↔ Settings

**Navigation pattern:** Single Activity with NavHostFragment, bottom navigation bar, Session screen hides nav while active

---

## Deployment Plan

### Debug build (development)

```bash
./gradlew assembleDebug
adb install app/build/outputs/apk/debug/app-debug.apk
```

### Release build (for submission / distribution)

```bash
./gradlew assembleRelease
```

> A keystore file is required for release builds. Generate one via Android Studio → Build → Generate Signed Bundle / APK.

### Command-line full build and test

```bash
./gradlew clean test assembleDebug
```

This command cleans the project, runs all unit tests, and produces a debug APK in a single pass.

---

## License

This project is submitted as coursework for the Android Application Development course at ICT University of Cameroon. All rights reserved.

---

<p align="center">
  Built with intention · ICT University of Cameroon · 2026<br>
  <strong>AJA CHELLA ASAMBA JR</strong> &nbsp;·&nbsp; <strong>NJINDA BRIAN JR</strong>
</p>
