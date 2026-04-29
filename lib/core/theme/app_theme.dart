import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class SSEMTheme {
  // ── LIGHT THEME ──────────────────────────────────────────────────────────────
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
        displayLarge: GoogleFonts.ibmPlexSans(fontSize: 60, fontWeight: FontWeight.w700, color: SSEMColors.textMain),
        headlineMedium: GoogleFonts.ibmPlexSans(fontSize: 24, fontWeight: FontWeight.w700, color: SSEMColors.textMain),
        bodyLarge: GoogleFonts.ibmPlexSans(fontSize: 14, fontWeight: FontWeight.w500, color: SSEMColors.textMain),
        bodyMedium: GoogleFonts.ibmPlexSans(fontSize: 12, color: SSEMColors.textMain),
        bodySmall: GoogleFonts.ibmPlexSans(fontSize: 11, color: SSEMColors.textMain),
      ),
      cardTheme: CardThemeData(
        color: SSEMColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: SSEMColors.border.withValues(alpha: 0.1), width: 1),
        ),
      ),
      iconTheme: const IconThemeData(color: SSEMColors.primaryGreen, size: 24),
      dividerTheme: DividerThemeData(color: SSEMColors.divider.withValues(alpha: 0.1), thickness: 1),
    );
  }

  // ── DARK THEME ───────────────────────────────────────────────────────────────
  static const Color _darkBg       = Color(0xFF121212);
  static const Color _darkSurface  = Color(0xFF1E1E1E);
  static const Color _darkCard     = Color(0xFF252525);
  static const Color _darkText     = Color(0xFFF0EAE0);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _darkBg,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: SSEMColors.primaryGreen,
        onPrimary: Colors.white,
        secondary: SSEMColors.secondaryOrange,
        onSecondary: Colors.white,
        tertiary: SSEMColors.accentPurple,
        onTertiary: Colors.white,
        error: Color(0xFFCF6679),
        onError: Colors.black,
        surface: _darkCard,
        onSurface: _darkText,
        surfaceContainerHighest: _darkSurface,
        onSurfaceVariant: _darkText,
        outline: _darkText,
        outlineVariant: _darkText,
        shadow: Colors.black,
        scrim: Colors.black,
        inverseSurface: SSEMColors.scaffoldBackground,
        onInverseSurface: SSEMColors.textMain,
        inversePrimary: SSEMColors.primaryGreen,
        surfaceTint: SSEMColors.primaryGreen,
      ),
      textTheme: GoogleFonts.ibmPlexSansTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.ibmPlexSans(fontSize: 60, fontWeight: FontWeight.w700, color: _darkText),
        headlineMedium: GoogleFonts.ibmPlexSans(fontSize: 24, fontWeight: FontWeight.w700, color: _darkText),
        bodyLarge: GoogleFonts.ibmPlexSans(fontSize: 14, fontWeight: FontWeight.w500, color: _darkText),
        bodyMedium: GoogleFonts.ibmPlexSans(fontSize: 12, color: _darkText),
        bodySmall: GoogleFonts.ibmPlexSans(fontSize: 11, color: _darkText),
      ),
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _darkText.withValues(alpha: 0.08), width: 1),
        ),
      ),
      iconTheme: const IconThemeData(color: SSEMColors.primaryGreen, size: 24),
      dividerTheme: DividerThemeData(color: _darkText.withValues(alpha: 0.1), thickness: 1),
    );
  }
}
