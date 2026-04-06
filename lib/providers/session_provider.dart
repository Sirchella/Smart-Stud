import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sensor_provider.dart';

class SessionState {
  final bool isActive;
  final DateTime startTime;
  final Duration duration;
  final int alertCount;

  SessionState({
    this.isActive = false,
    required this.startTime,
    this.duration = Duration.zero,
    this.alertCount = 0,
  });

  SessionState copyWith({
    bool? isActive,
    DateTime? startTime,
    Duration? duration,
    int? alertCount,
  }) {
    return SessionState(
      isActive: isActive ?? this.isActive,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      alertCount: alertCount ?? this.alertCount,
    );
  }
}

class SessionNotifier extends StateNotifier<SessionState> {
  Timer? _timer;

  SessionNotifier(this.ref) : super(SessionState(startTime: DateTime.now())) {
    // Listen to motion for alerts centrally in constructor
    ref.listen(sensorProvider, (previous, next) {
      // Only process when session is active
      if (state.isActive) {
        if (next.motionEventCount > (previous?.motionEventCount ?? 0)) {
          state = state.copyWith(alertCount: state.alertCount + 1);
        }
      }
    });
  }

  final Ref ref;

  void startSession() {
    state = state.copyWith(
      isActive: true,
      startTime: DateTime.now(),
      duration: Duration.zero,
      alertCount: 0,
    );
    ref.read(sensorProvider.notifier).startMonitoring();

    _timer?.cancel(); // Safety
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
          duration: state.duration + const Duration(seconds: 1));
    });
  }

  void stopSession() {
    _timer?.cancel();
    state = state.copyWith(isActive: false);
    ref.read(sensorProvider.notifier).stopMonitoring();
  }

  void resetSession() {
    state = SessionState(startTime: DateTime.now());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(ref);
});
