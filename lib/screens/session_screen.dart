import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/colors.dart';
import '../providers/session_provider.dart';
import '../providers/sensor_provider.dart';
import '../widgets/glass_card.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _recordingController;
  late Animation<double> _recordingAnimation;

  @override
  void initState() {
    super.initState();
    _recordingController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _recordingAnimation =
        Tween<double>(begin: 0.1, end: 1.0).animate(_recordingController);
  }

  @override
  void dispose() {
    _recordingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(sessionProvider);
    final sensors = ref.watch(sensorProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active session',
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                  ),
                  if (sessionState.isActive)
                    Row(
                      children: [
                        FadeTransition(
                          opacity: _recordingAnimation,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: SSEMColors.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recording',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: SSEMColors.primaryGreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                ],
              ),

              const Expanded(child: SizedBox()),

              // Alerts Card (Glassmorphic)
              Center(
                child: GlassCard(
                  borderRadius: 24,
                  blur: 30,
                  color: SSEMColors.secondaryOrange.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: SSEMColors.secondaryOrange, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        'ALERTS',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  letterSpacing: 2.8,
                                  fontWeight: FontWeight.w700,
                                  color: SSEMColors.secondaryOrange,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${sessionState.alertCount}x',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const Expanded(child: SizedBox()),

              // Session stats
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StatItem(
                      label: 'DURATION',
                      value: _formatDuration(sessionState.duration)),
                  const SizedBox(width: 48),
                  _StatItem(
                      label: 'NOISE',
                      value: '${sensors.noiseLevels.toInt()} dB'),
                ],
              ),

              const SizedBox(height: 48),

              // Controls
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          ref.read(sessionProvider.notifier).stopSession(),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 20),
                        side: const BorderSide(
                            color: SSEMColors.secondaryOrange),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('End',
                          style: TextStyle(
                              color: SSEMColors.secondaryOrange,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (sessionState.isActive) {
                          ref
                              .read(sessionProvider.notifier)
                              .stopSession();
                        } else {
                          ref
                              .read(sessionProvider.notifier)
                              .startSession();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SSEMColors.primaryGreen,
                        padding:
                            const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        sessionState.isActive ? 'Pause' : 'Start',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
                color: SSEMColors.textMain.withValues(alpha: 0.5),
              ),
        ),
      ],
    );
  }
}
