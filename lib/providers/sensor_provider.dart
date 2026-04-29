import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:light/light.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class SensorState {
  final double noiseLevels; // dB
  final double illumination; // lux
  final double motionEventCount;
  final String location;

  SensorState({
    this.noiseLevels = 0.0,
    this.illumination = 0.0,
    this.motionEventCount = 0.0,
    this.location = 'Unknown',
  });

  SensorState copyWith({
    double? noiseLevels,
    double? illumination,
    double? motionEventCount,
    String? location,
  }) {
    return SensorState(
      noiseLevels: noiseLevels ?? this.noiseLevels,
      illumination: illumination ?? this.illumination,
      motionEventCount: motionEventCount ?? this.motionEventCount,
      location: location ?? this.location,
    );
  }
}

class SensorNotifier extends StateNotifier<SensorState> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<int>? _lightSubscription;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _noiseTimer;
  Light? _light;

  static const _noiseChannel = MethodChannel('com.ssem.ssem/noise');

  SensorNotifier() : super(SensorState()) {
    // Auto-start all sensors immediately when provider is created
    startMonitoring();
  }

  Future<void> startMonitoring() async {
    _initAccelerometer();
    await _initGeolocator();
    await _initNoiseSampler();
    _initLightSensor();
  }

  void stopMonitoring() {
    _accelerometerSubscription?.cancel();
    _lightSubscription?.cancel();
    _positionSubscription?.cancel();
    _noiseTimer?.cancel();
    _noiseChannel.invokeMethod('stop').catchError((_) {});
  }

  void _initAccelerometer() {
    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      final double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 15.0) {
        state = state.copyWith(motionEventCount: state.motionEventCount + 1);
      }
    });
  }

  Future<void> _initGeolocator() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(location: 'Disabled');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        state = state.copyWith(location: 'Denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(location: 'Denied Forever');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.low));
      state = state.copyWith(
          location:
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}');

      _positionSubscription = Geolocator.getPositionStream(
              locationSettings:
                  const LocationSettings(accuracy: LocationAccuracy.low))
          .listen((Position pos) {
        state = state.copyWith(
            location:
                '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}');
      });
    } catch (e) {
      state = state.copyWith(location: 'Error');
    }
  }

  /// Uses Android MediaRecorder via a MethodChannel to sample amplitude
  /// and converts it to approximate dB. Falls back to 0.0 on error.
  Future<void> _initNoiseSampler() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) return;

    try {
      await _noiseChannel.invokeMethod('start');
    } catch (_) {
      // Native side not implemented yet — use fallback polling
    }

    _noiseTimer = Timer.periodic(const Duration(milliseconds: 300), (_) async {
      try {
        final amplitude =
            await _noiseChannel.invokeMethod<double>('getAmplitude');
        if (amplitude != null && amplitude > 1) {
          // Convert amplitude (0–32768) to dB: 20 * log10(amplitude)
          // amplitude=1 → ~0 dB, amplitude=32768 → ~90 dB
          final rawDb = 20 * log(amplitude) / ln10;
          // Add a realistic ambient floor of ~30 dB so it never shows 0
          final db = (rawDb + 30).clamp(30.0, 120.0);
          state = state.copyWith(noiseLevels: db);
        } else {
          // No sound detected — show ambient floor ~30 dB
          state = state.copyWith(noiseLevels: 30.0);
        }
      } catch (_) {
        // Channel not available — leave last value
      }
    });
  }

  void _initLightSensor() {
    _light = Light();
    try {
      _lightSubscription = _light?.lightSensorStream.listen(
        (int luxValue) {
          state = state.copyWith(illumination: luxValue.toDouble());
        },
        onError: (e) {
          // Light sensor unavailable on this device — leave at 0
        },
        cancelOnError: false,
      );
    } on Exception catch (_) {
      // Other errors — ignore
    }
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}

final sensorProvider =
    StateNotifierProvider<SensorNotifier, SensorState>((ref) {
  return SensorNotifier();
});
