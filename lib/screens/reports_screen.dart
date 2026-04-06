import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/colors.dart';
import '../providers/service_providers.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Study Summary',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '5 sessions this week',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: SSEMColors.textMain.withValues(alpha: 0.5),
                    ),
              ),
              const SizedBox(height: 32),

              // Duration Filters
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: '1 Week', isSelected: true),
                    SizedBox(width: 8),
                    _FilterChip(label: '1 Month', isSelected: false),
                    SizedBox(width: 8),
                    _FilterChip(label: 'All Time', isSelected: false),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Suggestions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SUGGESTIONS',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          letterSpacing: 2.8,
                          fontWeight: FontWeight.w700,
                          color: SSEMColors.textMain.withValues(alpha: 0.4),
                        ),
                  ),
                  Text(
                    'See All',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: SSEMColors.primaryGreen,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Sessions list (mock data)
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _SessionListItem(
                      date: 'Mar ${18 - index}, 2026',
                      duration: '${2 + index}h 15m',
                      score: 85 - (index * 5),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Export Actions
              Row(
                children: [
                  // PDF Export
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(pdfServiceProvider).generateSessionReport({
                          'date': 'Mar 18, 2026',
                          'duration': '2h 15m',
                          'score': 85,
                          'alerts': 2,
                          'noise': 42.5,
                          'noise_score': 90.0,
                          'light': 450.0,
                          'light_score': 95.0,
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SSEMColors.darkBackground,
                        padding:
                            const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Export',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14)),
                          Text('PDF',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // CSV Export
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(exportServiceProvider).exportCSV([
                          {
                            'date': 'Mar 18, 2026',
                            'duration': '2h 15m',
                            'score': 85.0,
                            'alerts': 2,
                            'noise': 42.5,
                            'light': 450.0,
                          },
                          {
                            'date': 'Mar 17, 2026',
                            'duration': '3h 10m',
                            'score': 78.0,
                            'alerts': 5,
                            'noise': 45.0,
                            'light': 500.0,
                          },
                        ]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SSEMColors.surfaceCard,
                        padding:
                            const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        side: const BorderSide(
                            color: SSEMColors.border, width: 0.5),
                        elevation: 0,
                      ),
                      child: const Text(
                        'CSV',
                        style: TextStyle(
                            color: SSEMColors.textMain,
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
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? SSEMColors.darkBackground : SSEMColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: SSEMColors.border, width: isSelected ? 0 : 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : SSEMColors.textMain,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SessionListItem extends StatelessWidget {
  final String date;
  final String duration;
  final int score;

  const _SessionListItem(
      {required this.date,
      required this.duration,
      required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SSEMColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: SSEMColors.border.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
              ),
              Text(
                duration,
                style: TextStyle(
                    color: SSEMColors.textMain.withValues(alpha: 0.5),
                    fontSize: 12),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: SSEMColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$score',
              style: const TextStyle(
                  color: SSEMColors.primaryGreen,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
