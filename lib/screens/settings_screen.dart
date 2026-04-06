import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preferences & security',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: SSEMColors.textMain.withValues(alpha: 0.5),
                    ),
              ),
              const SizedBox(height: 48),

              // Sensor Thresholds
              const _SectionHeader(title: 'SENSOR THRESHOLDS'),
              const SizedBox(height: 8),
              _SettingsItem(
                  title: 'Noise limit',
                  value: '45 dB',
                  icon: Icons.graphic_eq,
                  onTap: () {}),
              _SettingsItem(
                  title: 'Light target',
                  value: '500 lux',
                  icon: Icons.wb_sunny_outlined,
                  onTap: () {}),

              const SizedBox(height: 32),

              // Preferences
              const _SectionHeader(title: 'PREFERENCES'),
              const SizedBox(height: 8),
              _SettingsItem(
                  title: 'Dark mode',
                  value: 'System',
                  icon: Icons.dark_mode_outlined,
                  onTap: () {}),
              _SettingsItem(
                  title: 'Notifications',
                  value: 'Enabled',
                  icon: Icons.notifications_none,
                  onTap: () {}),

              const SizedBox(height: 32),

              // Security
              const _SectionHeader(title: 'SECURITY'),
              const SizedBox(height: 8),
              _SettingsItem(
                  title: 'Data privacy',
                  value: 'Private',
                  icon: Icons.lock_outline,
                  onTap: () {}),
              _SettingsItem(
                  title: 'Export history',
                  value: 'Auto-sync',
                  icon: Icons.history,
                  onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            letterSpacing: 2.8,
            fontWeight: FontWeight.w700,
            color: SSEMColors.textMain.withValues(alpha: 0.4),
          ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: SSEMColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: SSEMColors.primaryGreen, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
                color: SSEMColors.textMain.withValues(alpha: 0.5),
                fontSize: 12),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right,
              color: SSEMColors.textMain.withValues(alpha: 0.2), size: 16),
        ],
      ),
    );
  }
}
