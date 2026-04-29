import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'heart_rate_provider.dart';
import 'profile_provider.dart';
import 'sensor_provider.dart';

class EnvironmentState {
  final double score;        // 0-100 composite environment score
  final String status;       // Great / Good / Fair / Poor
  final double matchPercent; // how close current conditions are to user's ideal

  const EnvironmentState({
    this.score = 0.0,
    this.status = 'Poor',
    this.matchPercent = 0.0,
  });
}

class EnvironmentNotifier extends StateNotifier<EnvironmentState> {
  EnvironmentNotifier(this.ref) : super(const EnvironmentState()) {
    _listenToAll();
    _recalculate();
  }

  final Ref ref;

  void _listenToAll() {
    // Recalculate whenever any input changes
    ref.listen(sensorProvider, (_, __) => _recalculate());
    ref.listen(profileProvider, (_, __) => _recalculate());
    ref.listen(heartRateProvider, (_, __) => _recalculate());
  }

  void _recalculate() {
    _calculateScore(
      ref.read(sensorProvider),
      ref.read(profileProvider),
      ref.read(heartRateProvider),
    );
  }

  void _calculateScore(
    SensorState sensors,
    EnvironmentProfile profile,
    HeartRateState heartRate,
  ) {
    // ── Noise ──────────────────────────────────────────────────────────────
    // Full score when noise equals the user's ideal; lose 1 pt per dB of
    // deviation (up to 60 dB swing = 0).
    final noiseDiff = (sensors.noiseLevels - profile.idealNoiseDb).abs();
    final noiseScore = (100.0 - noiseDiff.clamp(0, 100)).toDouble();

    // ── Light ──────────────────────────────────────────────────────────────
    // Full score at ideal lux; deduct 1 pt per 10 lux deviation (max 100 pt).
    final lightDiff =
        (sensors.illumination - profile.idealLightLux).abs() / 10.0;
    final lightScore = (100.0 - lightDiff.clamp(0, 100)).toDouble();

    // ── Motion ─────────────────────────────────────────────────────────────
    // Each distraction event beyond the user's accepted maximum costs 5 pts.
    final excessMotion =
        (sensors.motionEventCount - profile.maxMotionEvents).clamp(0, 20);
    final motionPenalty = (excessMotion * 5).toDouble();

    // ── Heart rate ─────────────────────────────────────────────────────────
    // Deviation from the user's ideal resting-focus BPM costs up to 30 pts.
    double heartPenalty = 0.0;
    if (heartRate.bpm > 0) {
      final hrDiff = (heartRate.bpm - profile.idealHeartRate).abs();
      heartPenalty = (hrDiff * 1.5).clamp(0, 30);
    }

    // ── Composite score ────────────────────────────────────────────────────
    final rawScore =
        ((noiseScore + lightScore) / 2.0 - motionPenalty - heartPenalty)
            .clamp(0.0, 100.0);

    // ── Match % ────────────────────────────────────────────────────────────
    // "How close is this environment to your ideal?" — weighted average of
    // the two continuous signals (noise + light); motion & HR are penalties.
    final matchPercent =
        ((noiseScore + lightScore) / 2.0 - motionPenalty / 2.0 - heartPenalty / 2.0)
            .clamp(0.0, 100.0);

    String status = 'Great';
    if (rawScore < 40) {
      status = 'Poor';
    } else if (rawScore < 60) {
      status = 'Fair';
    } else if (rawScore < 85) {
      status = 'Good';
    }

    state = EnvironmentState(
      score: rawScore,
      status: status,
      matchPercent: matchPercent,
    );
  }
}

final environmentProvider =
    StateNotifierProvider<EnvironmentNotifier, EnvironmentState>((ref) {
  return EnvironmentNotifier(ref);
});
