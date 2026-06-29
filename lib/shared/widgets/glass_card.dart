// ============================================================
// lib/shared/widgets/glass_card.dart
// Frosted glass card UI widget for cyberpunk panels
// ============================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final double borderOpacity;
  final double bgOpacity;
  final BoxBorder? customBorder;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final List<BoxShadow>? glowShadows;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 18.0,
    this.blur = 15.0,
    this.borderOpacity = 0.15,
    this.bgOpacity = 0.55, // Frosted black glass default opacity
    this.customBorder,
    this.padding = const EdgeInsets.all(16.0),
    this.width,
    this.height,
    this.glowShadows,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: glowShadows ?? (isDark ? [AppGlows.violetGlow] : []),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.black.withValues(alpha: bgOpacity)
                  : Colors.white.withValues(alpha: 0.8), // Highly readable white glass in light mode
              borderRadius: BorderRadius.circular(borderRadius),
              border: customBorder ??
                  Border.all(
                    color: AppColors.currentViolet.withValues(alpha: isDark ? 0.7 : 0.4),
                    width: 1.5,
                  ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
