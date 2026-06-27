// ============================================================
// lib/features/auth/presentation/screens/splash_screen.dart
// Cyberpunk animated loading splash screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;

    final user = ref.read(userProvider);
    if (user != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeType = ref.watch(themeProvider);
    final isNeon = themeType == 'violetNeon';

    return Scaffold(
      backgroundColor: isNeon ? const Color(0xFF090514) : AppColors.matteBlack,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppColors.currentViolet.withValues(alpha: 0.15),
              Colors.transparent,
            ],
            radius: 1.2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Animated "OC" Monogram ──────────────────────────────
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.currentViolet.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.accentPurpleGlow,
                    width: 2,
                  ),
                  boxShadow: const [AppGlows.violetGlow],
                ),
                child: Center(
                  child: Text(
                    'OC',
                    style: AppTheme.getHeaderStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.2, 0.2),
                    end: const Offset(1.0, 1.0),
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 500.ms),

              const SizedBox(height: 24),

              // ── Animated "OPEN CAST" Title ──────────────────────────
              Text(
                'OPEN CAST',
                style: AppTheme.getHeaderStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  color: AppColors.softWhite,
                ),
              )
                  .animate()
                  .slideY(
                    begin: 0.3,
                    end: 0,
                    duration: 600.ms,
                    curve: Curves.easeOut,
                  )
                  .fadeIn(duration: 500.ms),

              const SizedBox(height: 8),

              // ── Animated Tagline ────────────────────────────────────
              Text(
                'Stream Without Limits',
                style: AppTheme.getBodyStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.white60,
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 600.ms),

              const SizedBox(height: 64),

              // Simple loading bar
              SizedBox(
                width: 120,
                height: 2,
                child: LinearProgressIndicator(
                  color: AppColors.accentPurpleGlow,
                  backgroundColor: AppColors.border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
