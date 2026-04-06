import 'package:flutter/material.dart';

class SSEMColors {
  // SSEM Wellness Palette
  static const Color scaffoldBackground = Color(0xFFF5F0E8);
  static const Color surfaceCard = Color(0xFFEDE6D8);
  static const Color darkBackground = Color(0xFF2D1A0E);
  static const Color textMain = Color(0xFF2D1A0E);
  static const Color border = Color(0xFF2D1A0E);
  static const Color divider = Color(0xFF2D1A0E);

  // Accents
  static const Color primaryGreen = Color(0xFF7B9E4A);
  static const Color secondaryOrange = Color(0xFFE8834A);
  static const Color accentPurple = Color(0xFF9B8EC4);

  // Chip backgrounds
  static const Color chipGreen = Color(0xFF7B9E4A);
  static const Color chipOrange = Color(0xFFE8834A);
  static const Color chipPurple = Color(0xFF9B8EC4);

  // Opacity versions – use withValues to avoid precision loss
  static Color glassBackground =
      const Color(0xFFF5F0E8).withValues(alpha: 0.4);
}
