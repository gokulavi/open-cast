// ============================================================
// lib/theme/app_theme.dart
// Cyberpunk Design System Theme for OPEN CAST
// ============================================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color matteBlack = Color(0xFF0D0D0D);
  static const Color currentViolet = Color(0xFF7F3DFF);
  static const Color accentPurpleGlow = Color(0xFFA970FF);
  static const Color softWhite = Color(0xFFF5F5F5);
  static const Color cardDark = Color(0xFF1A1A2E);
  static const Color surface = Color(0xFF161616);
  static const Color border = Color(0xFF2A2A4A);
  
  static const Color liveRed = Color(0xFFFF3B5C);
  static const Color onlineGreen = Color(0xFF00E676);
  static const Color warningAmber = Color(0xFFFFB300);
  static const Color infoBlue = Color(0xFF00B4FF);

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [currentViolet, Color(0xFF531CB3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient liveGradient = LinearGradient(
    colors: [liveRed, Color(0xFFC2185B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonBorderGradient = LinearGradient(
    colors: [currentViolet, accentPurpleGlow, infoBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppGlows {
  AppGlows._();

  static const BoxShadow violetGlow = BoxShadow(
    color: Color(0x667F3DFF), // 0.4 opacity
    blurRadius: 20,
    spreadRadius: 2,
    offset: Offset(0, 0),
  );

  static const BoxShadow redGlow = BoxShadow(
    color: Color(0x66FF3B5C),
    blurRadius: 20,
    spreadRadius: 2,
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
      scaffoldBackgroundColor: const Color(0xFF090514),
      cardTheme: CardThemeData(
        color: const Color(0xFF140A26),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.accentPurpleGlow, width: 1.5),
        ),
      ),
    );
  }
}
