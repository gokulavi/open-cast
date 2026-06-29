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

        // Live Animations Layer
        if (themeConfig.isDark) // Show heavy neon animations in dark mode for best contrast
          Positioned.fill(
            child: _buildAnimationForTheme(themeConfig.palette),
          ),
          
        if (!themeConfig.isDark) // Show a much lighter version in bright mode
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: _buildAnimationForTheme(themeConfig.palette),
            ),
          ),

        // Content Layer
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _buildAnimationForTheme(ThemePalette palette) {
    return const _GlowingGlitterEffect();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glowing and Glittering Live Effects
// ─────────────────────────────────────────────────────────────────────────────
class _GlowingGlitterEffect extends StatelessWidget {
  const _GlowingGlitterEffect();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final rnd = math.Random(42); // Fixed seed so layout doesn't jump on rebuild
        final width = constraints.maxWidth > 0 ? constraints.maxWidth : 1000.0;
        final height = constraints.maxHeight > 0 ? constraints.maxHeight : 1000.0;

        return Stack(
          children: [
            // 1. Large Glowing Orbs (Breathing)
            ...List.generate(4, (index) {
              return Positioned(
                left: rnd.nextDouble() * width - 150,
                top: rnd.nextDouble() * height - 150,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.currentViolet.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                      stops: const [0.1, 1.0],
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.3, 1.3),
                      duration: Duration(seconds: 4 + index),
                      curve: Curves.easeInOutSine,
                    )
                    .fadeIn(duration: 2.seconds)
                    .move(
                      begin: Offset(rnd.nextDouble() * 50 - 25, rnd.nextDouble() * 50 - 25),
                      end: Offset(rnd.nextDouble() * 50 - 25, rnd.nextDouble() * 50 - 25),
                      duration: Duration(seconds: 5 + index),
                      curve: Curves.easeInOutSine,
                    ),
              );
            }),

            // 2. Glittering Particles
            ...List.generate(30, (index) {
              final size = rnd.nextDouble() * 4 + 2; // 2px to 6px
              return Positioned(
                left: rnd.nextDouble() * width,
                top: rnd.nextDouble() * height,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentPurpleGlow,
                        blurRadius: size * 2,
                        spreadRadius: size / 2,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fadeIn(
                      duration: Duration(milliseconds: 500 + rnd.nextInt(1500)),
                      curve: Curves.easeInOut,
                    )
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.5, 1.5),
                      duration: Duration(milliseconds: 1000 + rnd.nextInt(2000)),
                      curve: Curves.easeInOut,
                    ),
              );
            }),
          ],
        );
      },
    );
  }
}

