import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The user's definition of their ideal study environment.
/// All scoring is relative to these values.
class EnvironmentProfile {
  final String name;
  final double idealNoiseDb;    // dB  – silence/library level ≈ 30–45
  final double idealLightLux;   // lux – desk lamp ≈ 300–600
  final int maxMotionEvents;    // how many distractions are "acceptable"
  final double idealHeartRate;  // BPM – relaxed focus ≈ 60–80

  const EnvironmentProfile({
    this.name = 'My Study Space',
    this.idealNoiseDb = 40.0,
    this.idealLightLux = 400.0,
    this.maxMotionEvents = 3,
    this.idealHeartRate = 70.0,
  });

  EnvironmentProfile copyWith({
    String? name,
    double? idealNoiseDb,
    double? idealLightLux,
    int? maxMotionEvents,
    double? idealHeartRate,
  }) =>
      EnvironmentProfile(
        name: name ?? this.name,
        idealNoiseDb: idealNoiseDb ?? this.idealNoiseDb,
        idealLightLux: idealLightLux ?? this.idealLightLux,
        maxMotionEvents: maxMotionEvents ?? this.maxMotionEvents,
        idealHeartRate: idealHeartRate ?? this.idealHeartRate,
      );
}

class ProfileNotifier extends StateNotifier<EnvironmentProfile> {
  ProfileNotifier() : super(const EnvironmentProfile()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = EnvironmentProfile(
      name: prefs.getString('profile_name') ?? 'My Study Space',
      idealNoiseDb: prefs.getDouble('ideal_noise') ?? 40.0,
      idealLightLux: prefs.getDouble('ideal_light') ?? 400.0,
      maxMotionEvents: prefs.getInt('max_motion') ?? 3,
      idealHeartRate: prefs.getDouble('ideal_hr') ?? 70.0,
    );
  }

  Future<void> save(EnvironmentProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', profile.name);
    await prefs.setDouble('ideal_noise', profile.idealNoiseDb);
    await prefs.setDouble('ideal_light', profile.idealLightLux);
    await prefs.setInt('max_motion', profile.maxMotionEvents);
    await prefs.setDouble('ideal_hr', profile.idealHeartRate);
    state = profile;
  }

  /// Snapshot the current sensor readings and save them as the user's ideal.
  Future<void> captureCurrentAsIdeal({
    required double currentNoise,
    required double currentLight,
    required int currentMotion,
    required double currentHeartRate,
    String? name,
  }) async {
    await save(state.copyWith(
      name: name ?? state.name,
      idealNoiseDb: currentNoise.clamp(20.0, 100.0),
      idealLightLux: currentLight.clamp(0.0, 1000.0),
      maxMotionEvents: currentMotion.clamp(0, 20),
      idealHeartRate:
          currentHeartRate > 0 ? currentHeartRate : state.idealHeartRate,
    ));
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, EnvironmentProfile>((ref) {
  return ProfileNotifier();
});
