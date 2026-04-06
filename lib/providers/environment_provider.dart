import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sensor_provider.dart';

class EnvironmentState {
  final double score; // 0-100
  final String status; // Great, Good, Fair, Poor

  EnvironmentState({
    this.score = 0.0,
    this.status = 'Great',
  });
}

class EnvironmentNotifier extends StateNotifier<EnvironmentState> {
  EnvironmentNotifier(this.ref) : super(EnvironmentState()) {
    _listenToSensors();
  }

  final Ref ref;

  void _listenToSensors() {
    ref.listen(sensorProvider, (previous, next) {
      _calculateScore(next);
    });
  }

  void _calculateScore(SensorState sensors) {
    // Scoring formula
    // Noise  : ideal < 45 dB  – deduct 1 pt per dB above threshold
    // Light  : ideal 300-500 lux
    // Motion : ideal 0 events – deduct 5 pts per distraction event

    final double noiseScore =
        100 - (sensors.noiseLevels - 40).clamp(0, 100);
    final double lightScore =
        100 - (sensors.illumination - 400).abs().clamp(0, 50).toDouble();
    final double motionPenalty =
        (sensors.motionEventCount * 5).clamp(0, 100);

    final double totalScore =
        ((noiseScore + lightScore) / 2 - motionPenalty).clamp(0, 100);

    String status = 'Great';
    if (totalScore < 40) {
      status = 'Poor';
    } else if (totalScore < 60) {
      status = 'Fair';
    } else if (totalScore < 85) {
      status = 'Good';
    }

    state = EnvironmentState(score: totalScore, status: status);
  }
}

final environmentProvider =
    StateNotifierProvider<EnvironmentNotifier, EnvironmentState>((ref) {
  return EnvironmentNotifier(ref);
});
