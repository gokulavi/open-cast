// ============================================================
// lib/theme/app_theme.dart
// Cyberpunk Design System Theme for OPEN CAST
// ============================================================

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../shared/models/app_models.dart';

class AppColors {
  AppColors._();

  static const Color matteBlack = Color(0xFF080808);       // Luxury Deep Matte Black (scaffold bg)
  
  // Mutable theme colors
  static Color currentViolet = const Color(0xFFD4AF37);     
  static Color accentPurpleGlow = const Color(0xFFF3E5AB);  
  static Color border = const Color(0x44D4AF37);            
  
  static const Color softWhite = Color(0xFFFAFAFA);         // Bright Soft White (clear readable text)
  static const Color cardDark = Color(0xFF141414);          // Frosted Glassy Black Card base
  static const Color surface = Color(0xFF1B1B1B);           // Elevated surface base

  // Mutable text colors for bright/dark mode support
  static Color textPrimary = softWhite;
  static Color textMuted = Colors.white70;
  static Color textFaded = Colors.white30;
  
  static const Color liveRed = Color(0xFFFF453A);           // Smooth Live Crimson Red
  static const Color onlineGreen = Color(0xFF30D158);       // Brilliant Active Green
  static const Color warningAmber = Color(0xFFFFD60A);      // Warm Yellow warning
  static const Color infoBlue = Color(0xFF0A84FF);          // Ocean Indigo Info

  // Mutable Gradients
  static LinearGradient brandGradient = LinearGradient(
    colors: [currentViolet, const Color(0xFF996515)], 
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient liveGradient = LinearGradient(
    colors: [liveRed, Color(0xFFD63B5D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient neonBorderGradient = LinearGradient(
    colors: [currentViolet, accentPurpleGlow, const Color(0xFFC5A059)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppGlows {
  AppGlows._();

  static BoxShadow violetGlow = BoxShadow(
    color: AppColors.currentViolet.withValues(alpha: 0.25), 
    blurRadius: 22,
    spreadRadius: 1,
    offset: const Offset(0, 0),
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
    Color? color,
    double? letterSpacing,
  }) {
    color ??= AppColors.currentViolet;
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
    Color? color,
    double? letterSpacing,
  }) {
    color ??= AppColors.currentViolet;
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
    color ??= AppColors.textPrimary;
    return GoogleFonts.exo2(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static void updateColors(ThemeConfig config) {
    switch (config.palette) {
      case ThemePalette.seaGreen:
        AppColors.currentViolet = const Color(0xFF2E8A56);
        AppColors.accentPurpleGlow = const Color(0xFF4ADE80);
        break;
      case ThemePalette.violet:
        AppColors.currentViolet = const Color(0xFF9343A3);
        AppColors.accentPurpleGlow = const Color(0xFFD8B4E2);
        break;
      case ThemePalette.gold:
      default:
        AppColors.currentViolet = const Color(0xFFD4AF37);
        AppColors.accentPurpleGlow = const Color(0xFFF3E5AB);
        break;
    }
    
    AppColors.border = AppColors.currentViolet.withValues(alpha: 0.25);
    AppColors.textPrimary = config.isDark ? AppColors.softWhite : Colors.black87;
    AppColors.textMuted = config.isDark ? Colors.white70 : Colors.black54;
    AppColors.textFaded = config.isDark ? Colors.white30 : Colors.black38;
    
    AppColors.brandGradient = LinearGradient(
      colors: [AppColors.currentViolet, AppColors.currentViolet.withValues(alpha: 0.6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    AppColors.neonBorderGradient = LinearGradient(
      colors: [AppColors.currentViolet, AppColors.accentPurpleGlow, AppColors.currentViolet.withValues(alpha: 0.8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    AppGlows.violetGlow = BoxShadow(
      color: AppColors.currentViolet.withValues(alpha: 0.25),
      blurRadius: 22,
      spreadRadius: 1,
      offset: const Offset(0, 0),
    );
  }

  static ThemeData getThemeData(ThemeConfig config) {
    if (config.isDark) {
      return ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.matteBlack,
        colorScheme: ColorScheme.dark(
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
            side: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        dividerTheme: DividerThemeData(
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
    } else {
      return ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.light(
          primary: AppColors.currentViolet, 
          secondary: const Color(0xFF1A1D2B), 
          surface: Colors.white,
          error: AppColors.liveRed,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: AppColors.border, width: 1.2), 
          ),
        ),
        dividerTheme: DividerThemeData(
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
}
