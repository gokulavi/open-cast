import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../models/app_models.dart';

class LiveThemeBackground extends StatelessWidget {
  final Widget child;
  final ThemeConfig themeConfig;

  const LiveThemeBackground({
    super.key,
    required this.child,
    required this.themeConfig,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base static background
        Container(
          decoration: BoxDecoration(
            color: themeConfig.isDark ? AppColors.matteBlack : Colors.white,
            gradient: !themeConfig.isDark
                ? LinearGradient(
                    colors: [
                      AppColors.currentViolet.withValues(alpha: 0.15),
                      Colors.white,
                      AppColors.currentViolet.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
        ),


        // Content Layer
        Positioned.fill(child: child),
      ],
    );
  }
}
