import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/constants/colors.dart';
import '../providers/environment_provider.dart';
import '../providers/heart_rate_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/sensor_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envState = ref.watch(environmentProvider);
    final sensors = ref.watch(sensorProvider);
    final heartRate = ref.watch(heartRateProvider);
    final profile = ref.watch(profileProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEE, d MMM yyyy').format(DateTime.now()),
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: SSEMColors.textMain
                                      .withValues(alpha: 0.6),
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hi, Aja! 👋',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: SSEMColors.surfaceCard,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: SSEMColors.border.withValues(alpha: 0.1)),
                    ),
                    child:
                        const Icon(Icons.notifications_none, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ── Environment Score ring ───────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: envState.score / 100,
                            strokeWidth: 12,
                            backgroundColor: SSEMColors.surfaceCard,
                            color: _scoreColor(envState.score),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${envState.score.toInt()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    fontSize: 60,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0,
                                  ),
                            ),
                            Text(
                              envState.status.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.w600,
                                    color: _scoreColor(envState.score),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ENVIRONMENT SCORE',
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                letterSpacing: 2.8,
                                fontWeight: FontWeight.w600,
                                color:
                                    SSEMColors.textMain.withValues(alpha: 0.4),
                              ),
                    ),
                    const SizedBox(height: 10),

                    // ── Profile match badge ──────────────────────────────
                    _ProfileMatchBadge(
                      matchPercent: envState.matchPercent,
                      profileName: profile.name,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ── Study Metrics ────────────────────────────────────────────
              Text(
                'STUDY METRICS',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      letterSpacing: 2.8,
                      fontWeight: FontWeight.w600,
                      color: SSEMColors.textMain,
                    ),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: [
                  _MetricCard(
                    title: 'NOISE',
                    value: '${sensors.noiseLevels.toInt()} dB',
                    icon: Icons.graphic_eq,
                    color: SSEMColors.primaryGreen,
                  ),
                  _MetricCard(
                    title: 'LIGHT',
                    value: '${sensors.illumination.toInt()} lux',
                    icon: Icons.wb_sunny_outlined,
                    color: SSEMColors.secondaryOrange,
                  ),
                  _MetricCard(
                    title: 'MOTION',
                    value: '${sensors.motionEventCount.toInt()} events',
                    icon: Icons.vibration,
                    color: SSEMColors.accentPurple,
                  ),
                  _MetricCard(
                    title: 'LOCATION',
                    value: sensors.location,
                    icon: Icons.location_on_outlined,
                    color: SSEMColors.primaryGreen,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ── Vitals ───────────────────────────────────────────────────
              Text(
                'VITALS',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      letterSpacing: 2.8,
                      fontWeight: FontWeight.w600,
                      color: SSEMColors.textMain,
                    ),
              ),
              const SizedBox(height: 16),
              _HeartRateCard(heartRate: heartRate),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Color _scoreColor(double score) {
    if (score >= 85) return SSEMColors.primaryGreen;
    if (score >= 60) return SSEMColors.primaryGreen.withValues(alpha: 0.75);
    if (score >= 40) return SSEMColors.secondaryOrange;
    return Colors.redAccent;
  }
}

// ── Profile match badge ────────────────────────────────────────────────────

class _ProfileMatchBadge extends StatelessWidget {
  final double matchPercent;
  final String profileName;

  const _ProfileMatchBadge({
    required this.matchPercent,
    required this.profileName,
  });

  @override
  Widget build(BuildContext context) {
    final pct = matchPercent.toInt();
    final Color color;
    if (pct >= 80) {
      color = SSEMColors.primaryGreen;
    } else if (pct >= 55) {
      color = SSEMColors.secondaryOrange;
    } else {
      color = Colors.redAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.tune, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            '$pct% match · $profileName',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Heart rate card ────────────────────────────────────────────────────────

class _HeartRateCard extends ConsumerWidget {
  final HeartRateState heartRate;

  const _HeartRateCard({required this.heartRate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color accentColor = _bpmColor(heartRate.bpm);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SSEMColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SSEMColors.border.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // BPM display
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.favorite, color: accentColor, size: 28),
          ),
          const SizedBox(width: 16),

          // Status + BPM text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heartRate.bpm > 0
                      ? '${heartRate.bpm} BPM'
                      : '-- BPM',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  heartRate.status,
                  style: TextStyle(
                    fontSize: 11,
                    color: SSEMColors.textMain.withValues(alpha: 0.55),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Measure / Stop button
          GestureDetector(
            onTap: () {
              if (heartRate.isMeasuring) {
                ref.read(heartRateProvider.notifier).stopMeasuring();
              } else {
                ref.read(heartRateProvider.notifier).startMeasuring();
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: heartRate.isMeasuring
                    ? Colors.redAccent.withValues(alpha: 0.12)
                    : SSEMColors.primaryGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: heartRate.isMeasuring
                      ? Colors.redAccent.withValues(alpha: 0.4)
                      : SSEMColors.primaryGreen.withValues(alpha: 0.4),
                ),
              ),
              child: Text(
                heartRate.isMeasuring ? 'STOP' : 'MEASURE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: heartRate.isMeasuring
                      ? Colors.redAccent
                      : SSEMColors.primaryGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _bpmColor(int bpm) {
    if (bpm == 0) return SSEMColors.textMain.withValues(alpha: 0.4);
    if (bpm < 60 || bpm > 100) return SSEMColors.secondaryOrange;
    return Colors.redAccent;
  }
}

// ── Metric card ────────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SSEMColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SSEMColors.border.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                width: 4,
                height: 4,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
