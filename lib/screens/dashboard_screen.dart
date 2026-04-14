import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/constants/colors.dart';
import '../providers/environment_provider.dart';
import '../providers/sensor_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envState = ref.watch(environmentProvider);
    final sensors = ref.watch(sensorProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEE, d MMM yyyy').format(DateTime.now()),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: SSEMColors.textMain.withValues(alpha: 0.6),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hi, Aja! 👋',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                    child: const Icon(Icons.notifications_none, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Environment Score
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
                            color: SSEMColors.primaryGreen,
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
                                    color: SSEMColors.primaryGreen,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ENVIRONMENT SCORE',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            letterSpacing: 2.8,
                            fontWeight: FontWeight.w600,
                            color: SSEMColors.textMain.withValues(alpha: 0.4),
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Study Metrics label
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

              // Metrics grid
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
                    value: '${sensors.motionEventCount.toInt()} pts',
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
            ],
          ),
        ),
      ),
    );
  }
}

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
