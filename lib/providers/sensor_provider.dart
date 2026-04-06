import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorState {
  final double noiseLevels; // dB
  final double illumination; // lux
  final double motionEventCount;
  final String location; // GPS mock

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
  Timer? _timer;
  final _random = Random();
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  SensorNotifier() : super(SensorState());

  void startMonitoring() {
    // 500ms sampling rate as per spec
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _updateSensors();
    });

    // Use accelerometerEventStream() — replaces the deprecated accelerometerEvents
    _accelerometerSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      final double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (acceleration > 15.0) {
        state = state.copyWith(motionEventCount: state.motionEventCount + 1);
      }
    });
  }

  void stopMonitoring() {
    _timer?.cancel();
    _accelerometerSubscription?.cancel();
  }

  void _updateSensors() {
    final double newNoise = 30.0 + _random.nextDouble() * 40.0; // 30–70 dB
    final double newLux = 200.0 + _random.nextDouble() * 600.0; // 200–800 lux

    state = state.copyWith(
      noiseLevels: newNoise,
      illumination: newLux,
      location: 'Library Main Hall',
    );
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
