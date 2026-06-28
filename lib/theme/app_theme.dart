// ============================================================
// lib/theme/app_theme.dart
// Cyberpunk Design System Theme for OPEN CAST
// ============================================================

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color matteBlack = Color(0xFF080808);       // Luxury Deep Matte Black (scaffold bg)
  static const Color currentViolet = Color(0xFFD4AF37);     // Rich Metallic Gold (brand primary)
  static const Color accentPurpleGlow = Color(0xFFF3E5AB);  // Soft Champagne Gold (glow active highlights)
  static const Color softWhite = Color(0xFFFAFAFA);         // Bright Soft White (clear readable text)
  static const Color cardDark = Color(0xFF141414);          // Frosted Glassy Black Card base
  static const Color surface = Color(0xFF1B1B1B);           // Elevated surface base
  static const Color border = Color(0x44D4AF37);            // Glass Gold Stroke
  
  static const Color liveRed = Color(0xFFFF453A);           // Smooth Live Crimson Red
  static const Color onlineGreen = Color(0xFF30D158);       // Brilliant Active Green
  static const Color warningAmber = Color(0xFFFFD60A);      // Warm Yellow warning
  static const Color infoBlue = Color(0xFF0A84FF);          // Ocean Indigo Info

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [currentViolet, Color(0xFF996515)], // Metallic Gold to Dark Gold
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient liveGradient = LinearGradient(
    colors: [liveRed, Color(0xFFD63B5D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonBorderGradient = LinearGradient(
    colors: [currentViolet, accentPurpleGlow, Color(0xFFC5A059)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppGlows {
  AppGlows._();

  static const BoxShadow violetGlow = BoxShadow(
    color: Color(0x44D4AF37), // Soft gold glow shadow
    blurRadius: 22,
    spreadRadius: 1,
    offset: Offset(0, 0),
  );

  static const BoxShadow redGlow = BoxShadow(
    color: Color(0x33FF453A),
    blurRadius: 20,
    spreadRadius: 1,
    offset: Offset(0, 0),
  );
}

class AppTheme {
  AppTheme._();

  static TextStyle getHeaderStyle({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.bold,
    Color? color = AppColors.currentViolet,
    double? letterSpacing,
  }) {
    return GoogleFonts.rajdhani(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle getH2Style({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.normal,
    Color? color = AppColors.currentViolet,
    double? letterSpacing,
  }) {
    return GoogleFonts.rajdhani(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle getBodyStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
  }) {
    return GoogleFonts.exo2(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Dark Pro Theme Definition (Primary)
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
        displayLarge: getHeaderStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.softWhite),
        titleLarge: getHeaderStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.softWhite),
        bodyLarge: getBodyStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.softWhite),
        bodyMedium: getBodyStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.softWhite),
        labelSmall: getBodyStyle(fontSize: 11, fontWeight: FontWeight.w300, color: AppColors.softWhite),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.currentViolet,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: getHeaderStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  // Bright Theme Definition (Premium Light Theme)
  static ThemeData get bright {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: const Color(0xFFF6F8FA), // Clean, premium off-white background
      colorScheme: const ColorScheme.light(
        primary: AppColors.currentViolet, // gold
        secondary: Color(0xFF1A1D2B), // dark steel
        surface: Colors.white,
        error: AppColors.liveRed,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border, width: 1.2), // Themed outline
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      textTheme: TextTheme(
        displayLarge: getHeaderStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1, color: const Color(0xFF0F172A)),
        titleLarge: getHeaderStyle(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)),
        bodyLarge: getBodyStyle(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF334155)),
        bodyMedium: getBodyStyle(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF475569)),
        labelSmall: getBodyStyle(fontSize: 11, fontWeight: FontWeight.w300, color: const Color(0xFF64748B)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.currentViolet,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: getHeaderStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
