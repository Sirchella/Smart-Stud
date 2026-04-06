import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/colors.dart';
import '../screens/dashboard_screen.dart';
import '../screens/session_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/settings_screen.dart';

final navigationProvider = StateProvider<int>((ref) => 0);

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    const List<Widget> screens = [
      DashboardScreen(),
      SessionScreen(),
      ReportsScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: SSEMColors.darkBackground,
          border: Border(
            top: BorderSide(
              color: SSEMColors.border.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(ref, 0, Icons.insert_chart_outlined, 'Home'),
            _buildNavItem(ref, 1, Icons.access_time, 'Session'),
            _buildNavItem(ref, 2, Icons.description_outlined, 'Reports'),
            _buildNavItem(ref, 3, Icons.person_outline, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      WidgetRef ref, int index, IconData icon, String label) {
    final isSelected = ref.watch(navigationProvider) == index;

    return GestureDetector(
      onTap: () => ref.read(navigationProvider.notifier).state = index,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? SSEMColors.primaryGreen
                : Colors.white.withValues(alpha: 0.4),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? SSEMColors.primaryGreen
                  : Colors.white.withValues(alpha: 0.4),
              fontSize: 10,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: isSelected
                  ? SSEMColors.primaryGreen
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
