import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/colors.dart';
import '../providers/heart_rate_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/sensor_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final profile = ref.watch(profileProvider);
    final sensors = ref.watch(sensorProvider);
    final heartRate = ref.watch(heartRateProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title ────────────────────────────────────────────────────
              Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Preferences & ideal environment',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: SSEMColors.textMain.withValues(alpha: 0.5),
                    ),
              ),
              const SizedBox(height: 40),

              // ── My Ideal Environment ─────────────────────────────────────
              const _SectionHeader(title: 'MY IDEAL ENVIRONMENT'),
              const SizedBox(height: 4),
              Text(
                'The app scores your current space against these targets.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: SSEMColors.textMain.withValues(alpha: 0.45),
                      fontSize: 11,
                    ),
              ),
              const SizedBox(height: 16),

              // Profile name
              _ProfileNameField(profile: profile, ref: ref),
              const SizedBox(height: 20),

              // Noise slider
              _SliderRow(
                icon: Icons.graphic_eq,
                iconColor: SSEMColors.primaryGreen,
                label: 'Ideal noise',
                unit: 'dB',
                value: profile.idealNoiseDb,
                min: 20,
                max: 80,
                onChanged: (v) => ref
                    .read(profileProvider.notifier)
                    .save(profile.copyWith(idealNoiseDb: v)),
              ),
              const SizedBox(height: 16),

              // Light slider
              _SliderRow(
                icon: Icons.wb_sunny_outlined,
                iconColor: SSEMColors.secondaryOrange,
                label: 'Ideal light',
                unit: 'lux',
                value: profile.idealLightLux,
                min: 0,
                max: 800,
                onChanged: (v) => ref
                    .read(profileProvider.notifier)
                    .save(profile.copyWith(idealLightLux: v)),
              ),
              const SizedBox(height: 16),

              // Heart rate slider
              _SliderRow(
                icon: Icons.favorite,
                iconColor: Colors.redAccent,
                label: 'Ideal heart rate',
                unit: 'BPM',
                value: profile.idealHeartRate,
                min: 50,
                max: 100,
                onChanged: (v) => ref
                    .read(profileProvider.notifier)
                    .save(profile.copyWith(idealHeartRate: v)),
              ),
              const SizedBox(height: 24),

              // Capture current as ideal
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.my_location, size: 16),
                  label: const Text('Capture current conditions as ideal'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SSEMColors.primaryGreen,
                    side:
                        BorderSide(color: SSEMColors.primaryGreen.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await ref.read(profileProvider.notifier).captureCurrentAsIdeal(
                          currentNoise: sensors.noiseLevels,
                          currentLight: sensors.illumination,
                          currentMotion: sensors.motionEventCount.toInt(),
                          currentHeartRate: heartRate.bpm.toDouble(),
                        );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Current conditions saved as your ideal environment ✓',
                          ),
                          backgroundColor: SSEMColors.primaryGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 36),

              // ── Preferences ──────────────────────────────────────────────
              const _SectionHeader(title: 'PREFERENCES'),
              const SizedBox(height: 8),
              _ThemeToggleItem(
                isDark: isDark,
                onToggle: () => ref.read(themeProvider.notifier).toggle(),
              ),
              _SettingsItem(
                title: 'Notifications',
                value: 'Enabled',
                icon: Icons.notifications_none,
                onTap: () {},
              ),

              const SizedBox(height: 32),

              // ── Security ─────────────────────────────────────────────────
              const _SectionHeader(title: 'SECURITY'),
              const SizedBox(height: 8),
              _SettingsItem(
                title: 'Data privacy',
                value: 'Private',
                icon: Icons.lock_outline,
                onTap: () {},
              ),
              _SettingsItem(
                title: 'Export history',
                value: 'Auto-sync',
                icon: Icons.history,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Profile name field ─────────────────────────────────────────────────────

class _ProfileNameField extends StatefulWidget {
  final EnvironmentProfile profile;
  final WidgetRef ref;

  const _ProfileNameField({required this.profile, required this.ref});

  @override
  State<_ProfileNameField> createState() => _ProfileNameFieldState();
}

class _ProfileNameFieldState extends State<_ProfileNameField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.profile.name);
  }

  @override
  void didUpdateWidget(_ProfileNameField old) {
    super.didUpdateWidget(old);
    if (old.profile.name != widget.profile.name &&
        _ctrl.text != widget.profile.name) {
      _ctrl.text = widget.profile.name;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Profile name',
        labelStyle: TextStyle(
            color: SSEMColors.textMain.withValues(alpha: 0.5), fontSize: 12),
        prefixIcon:
            Icon(Icons.bookmark_border, color: SSEMColors.primaryGreen, size: 20),
        filled: true,
        fillColor: SSEMColors.surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SSEMColors.border.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SSEMColors.border.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SSEMColors.primaryGreen.withValues(alpha: 0.6)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onSubmitted: (v) {
        final trimmed = v.trim();
        if (trimmed.isNotEmpty) {
          widget.ref
              .read(profileProvider.notifier)
              .save(widget.profile.copyWith(name: trimmed));
        }
      },
    );
  }
}

// ── Slider row ────────────────────────────────────────────────────────────

class _SliderRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String unit;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.unit,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SSEMColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: SSEMColors.border.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const Spacer(),
              Text(
                '${value.toInt()} $unit',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: iconColor,
                ),
              ),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: iconColor,
            inactiveColor: iconColor.withValues(alpha: 0.15),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ── Theme toggle ──────────────────────────────────────────────────────────

class _ThemeToggleItem extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _ThemeToggleItem({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: SSEMColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode_outlined,
          color: SSEMColors.primaryGreen,
          size: 20,
        ),
      ),
      title: const Text('Dark mode',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      trailing: Switch.adaptive(
        value: isDark,
        onChanged: (_) => onToggle(),
        activeThumbColor: SSEMColors.primaryGreen,
        activeTrackColor: SSEMColors.primaryGreen.withValues(alpha: 0.5),
      ),
    );
  }
}

// ── Generic settings item ─────────────────────────────────────────────────

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
      title: Text(title,
          style:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: TextStyle(
                  color: SSEMColors.textMain.withValues(alpha: 0.5),
                  fontSize: 12)),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right,
              color: SSEMColors.textMain.withValues(alpha: 0.2), size: 16),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────

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
