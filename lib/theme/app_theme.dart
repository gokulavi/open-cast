// ============================================================
// lib/theme/app_theme.dart
// Cyberpunk Design System Theme for OPEN CAST
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color matteBlack = Color(0xFF0C0F17);       // Soft Slate Midnight (calming background)
  static const Color currentViolet = Color(0xFF3F72AF);     // Sophisticated Sapphire Blue (primary brand)
  static const Color accentPurpleGlow = Color(0xFF90B4CE);  // Cool Ice Blue (glow highlights)
  static const Color softWhite = Color(0xFFE2E8F0);         // Calm Off-white (prevents text glare)
  static const Color cardDark = Color(0xFF161B26);          // Soft Charcoal Card fill
  static const Color surface = Color(0xFF111520);           // Deep Surface container
  static const Color border = Color(0xFF242C3F);            // Low-contrast Steel Border
  
  static const Color liveRed = Color(0xFFFF5376);           // Soft Crimson Live Red
  static const Color onlineGreen = Color(0xFF10B981);       // Calming Emerald Green
  static const Color warningAmber = Color(0xFFF59E0B);      // Warm Amber Warning
  static const Color infoBlue = Color(0xFF3B82F6);          // Steel Blue Info

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [currentViolet, Color(0xFF2E517A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient liveGradient = LinearGradient(
    colors: [liveRed, Color(0xFFD63B5D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonBorderGradient = LinearGradient(
    colors: [currentViolet, accentPurpleGlow, Color(0xFF6B99C3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppGlows {
  AppGlows._();

  static const BoxShadow violetGlow = BoxShadow(
    color: Color(0x333F72AF), // Softer, lower opacity sapphire glow
    blurRadius: 20,
    spreadRadius: 1,
    offset: Offset(0, 0),
  );

  static const BoxShadow redGlow = BoxShadow(
    color: Color(0x33FF5376), // Softer crimson glow
    blurRadius: 20,
    spreadRadius: 1,
    offset: Offset(0, 0),
  );
}

class AppTheme {
  AppTheme._();

  static TextStyle getHeaderStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.softWhite,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: 'Rajdhani',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle getBodyStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.softWhite,
  }) {
    return TextStyle(
      fontFamily: 'Exo2',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Dark Pro Theme Definition
  static ThemeData get darkPro {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.matteBlack,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.currentViolet,
        secondary: AppColors.accentPurpleGlow,
        surface: AppColors.surface,
        error: AppColors.liveRed,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      textTheme: TextTheme(
        displayLarge: getHeaderStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
        titleLarge: getHeaderStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: getBodyStyle(fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: getBodyStyle(fontSize: 14, fontWeight: FontWeight.w400),
        labelSmall: getBodyStyle(fontSize: 11, fontWeight: FontWeight.w300),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.currentViolet,
          foregroundColor: AppColors.softWhite,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: getHeaderStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Violet Neon Theme Definition (Cyberpunk style)
  static ThemeData get violetNeon {
    return darkPro.copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A0F1D), // Calm Midnight Blue
      cardTheme: CardThemeData(
        color: const Color(0xFF151C2C), // Navy-Slate card fill
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: AppColors.accentPurpleGlow.withValues(alpha: 0.4), width: 1.2), // Softer ice-blue border
        ),
      ),
    );
  }
}
