import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// PPG (photoplethysmography) heart rate via the back camera + torch.
///
/// How it works:
///   1. User places a finger over the back camera lens.
///   2. The torch illuminates the fingertip.
///   3. Blood volume changes with each heartbeat alter how much red light
///      is transmitted through the tissue — this changes the average
///      luminance of every frame.
///   4. We track the mean Y-plane value (luminance) per frame, detect
///      the repeating peaks, and convert peak intervals to BPM.
class HeartRateState {
  final int bpm;          // 0 = no reading yet
  final bool isMeasuring;
  final String status;    // human-readable hint shown in the UI

  const HeartRateState({
    this.bpm = 0,
    this.isMeasuring = false,
    this.status = 'Tap MEASURE to check heart rate',
  });

  HeartRateState copyWith({int? bpm, bool? isMeasuring, String? status}) =>
      HeartRateState(
        bpm: bpm ?? this.bpm,
        isMeasuring: isMeasuring ?? this.isMeasuring,
        status: status ?? this.status,
      );
}

class HeartRateNotifier extends StateNotifier<HeartRateState> {
  CameraController? _controller;
  final List<double> _samples = [];        // raw luminance samples
  final List<int> _bpmReadings = [];       // rolling BPM estimates
  DateTime? _lastPeakTime;
  double _movingAvg = 0;
  Timer? _autoStopTimer;

  static const _measureDuration = Duration(seconds: 20);
  static const _windowSize = 90;           // ~3 s at 30 fps
  static const _minIntervalMs = 300;       // upper bound ~200 BPM
  static const _maxIntervalMs = 1500;      // lower bound  ~40 BPM

  HeartRateNotifier() : super(const HeartRateState());

  /// Request camera permission then start PPG measurement.
  Future<void> startMeasuring() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      state = const HeartRateState(
        isMeasuring: false,
        status: 'Camera permission denied',
      );
      return;
    }

    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
    } catch (_) {
      state = const HeartRateState(
        isMeasuring: false,
        status: 'Camera unavailable',
      );
      return;
    }

    final back = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      back,
      ResolutionPreset.low,   // small frames for fast processing
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await _controller!.initialize();
      await _controller!.setFlashMode(FlashMode.torch); // illuminate fingertip
    } catch (e) {
      state = HeartRateState(
        isMeasuring: false,
        status: 'Camera error: $e',
      );
      _dispose();
      return;
    }

    _samples.clear();
    _bpmReadings.clear();
    _lastPeakTime = null;
    _movingAvg = 0;

    state = const HeartRateState(
      isMeasuring: true,
      status: 'Cover the camera with your fingertip…',
    );

    await _controller!.startImageStream(_onFrame);

    // Auto-stop after _measureDuration
    _autoStopTimer = Timer(_measureDuration, _finalize);
  }

  void _onFrame(CameraImage image) {
    // Y-plane (luminance) is planes[0] in YUV420
    final bytes = image.planes[0].bytes;
    double sum = 0;
    for (final b in bytes) {
      sum += b;
    }
    final avg = sum / bytes.length;
    _samples.add(avg);

    // Update moving average (exponential smoothing)
    _movingAvg = _movingAvg == 0 ? avg : _movingAvg * 0.9 + avg * 0.1;

    if (_samples.length < 10) {
      // Not enough data yet
      return;
    }

    // --- Simple peak detection ---
    // A peak: current sample crosses above the moving average from below,
    //         and the crossing gap is large enough to be a real pulse.
    final n = _samples.length;
    final prev = _samples[n - 2];
    final curr = _samples[n - 1];
    final threshold = _movingAvg + (_movingAvg * 0.005); // 0.5 % above avg

    if (prev < threshold && curr >= threshold) {
      final now = DateTime.now();
      if (_lastPeakTime != null) {
        final intervalMs = now.difference(_lastPeakTime!).inMilliseconds;
        if (intervalMs >= _minIntervalMs && intervalMs <= _maxIntervalMs) {
          final instantBpm = (60000 / intervalMs).round();
          _bpmReadings.add(instantBpm);
          if (_bpmReadings.length > 6) _bpmReadings.removeAt(0);

          // Median of recent readings for stability
          final sorted = List<int>.from(_bpmReadings)..sort();
          final medianBpm = sorted[sorted.length ~/ 2];

          final remaining =
              _measureDuration.inSeconds - (_samples.length ~/ 30);
          state = HeartRateState(
            isMeasuring: true,
            bpm: medianBpm,
            status:
                'Measuring… $medianBpm BPM  (${remaining > 0 ? remaining : 0}s left)',
          );
        }
      }
      _lastPeakTime = now;
    }

    // Keep window bounded to save memory
    if (_samples.length > _windowSize * 2) {
      _samples.removeRange(0, _windowSize);
    }
  }

  void _finalize() {
    final finalBpm = state.bpm;
    stopMeasuring();
    if (finalBpm > 0) {
      state = HeartRateState(
        isMeasuring: false,
        bpm: finalBpm,
        status: 'Last reading: $finalBpm BPM — tap to re-measure',
      );
    } else {
      state = const HeartRateState(
        isMeasuring: false,
        status: 'No reading — keep finger still & re-measure',
      );
    }
  }

  void stopMeasuring() {
    _autoStopTimer?.cancel();
    _autoStopTimer = null;
    _dispose();
    if (state.isMeasuring) {
      state = state.copyWith(isMeasuring: false);
    }
  }

  void _dispose() {
    try {
      _controller?.stopImageStream();
    } catch (_) {}
    try {
      _controller?.setFlashMode(FlashMode.off);
    } catch (_) {}
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    stopMeasuring();
    super.dispose();
  }
}

final heartRateProvider =
    StateNotifierProvider<HeartRateNotifier, HeartRateState>((ref) {
  return HeartRateNotifier();
});
