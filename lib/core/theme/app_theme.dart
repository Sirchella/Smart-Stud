import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class SSEMTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: SSEMColors.scaffoldBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: SSEMColors.primaryGreen,
        onPrimary: Colors.white,
        secondary: SSEMColors.secondaryOrange,
        onSecondary: Colors.white,
        tertiary: SSEMColors.accentPurple,
        onTertiary: Colors.white,
        error: Color(0xFFB00020),
        onError: Colors.white,
        surface: SSEMColors.surfaceCard,
        onSurface: SSEMColors.textMain,
        surfaceContainerHighest: SSEMColors.scaffoldBackground,
        onSurfaceVariant: SSEMColors.textMain,
        outline: SSEMColors.border,
        outlineVariant: SSEMColors.border,
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: SSEMColors.darkBackground,
        onInverseSurface: SSEMColors.scaffoldBackground,
        inversePrimary: SSEMColors.primaryGreen,
        surfaceTint: SSEMColors.primaryGreen,
      ),
      textTheme: GoogleFonts.ibmPlexSansTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.ibmPlexSans(
          fontSize: 60,
          fontWeight: FontWeight.w700,
          color: SSEMColors.textMain,
        ),
        headlineMedium: GoogleFonts.ibmPlexSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: SSEMColors.textMain,
        ),
        bodyLarge: GoogleFonts.ibmPlexSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: SSEMColors.textMain,
        ),
        bodyMedium: GoogleFonts.ibmPlexSans(
          fontSize: 12,
          color: SSEMColors.textMain,
        ),
        bodySmall: GoogleFonts.ibmPlexSans(
          fontSize: 11,
          color: SSEMColors.textMain,
        ),
      ),
      // CardThemeData (not CardTheme) is the correct parameter type for ThemeData
      cardTheme: CardThemeData(
        color: SSEMColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: SSEMColors.border.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: SSEMColors.primaryGreen,
        size: 24,
      ),
      dividerTheme: DividerThemeData(
        color: SSEMColors.divider.withValues(alpha: 0.1),
        thickness: 1,
      ),
    );
  }
}
