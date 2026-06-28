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

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _startTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(milliseconds: 3500));
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
    final isBright = themeType == 'bright';

    return Scaffold(
      backgroundColor: isBright ? const Color(0xFF090514) : AppColors.matteBlack,
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
              // ── 3D CINEMATIC INTRO VIDEO EFFECT (STREAMING SETUP) ──
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // 3D Isometric grid background
                      CustomPaint(
                        size: const Size(260, 180),
                        painter: CinematicIntroPainter(_animationController.value),
                      ),
                      
                      // Animated Softbox studio lights (beaming)
                      Positioned(
                        left: 20,
                        top: 10,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x44D4AF37),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.wb_sunny_rounded, color: AppColors.currentViolet, size: 22),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 800.ms),
                      ),
                      Positioned(
                        right: 20,
                        top: 10,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x44D4AF37),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.wb_sunny_rounded, color: AppColors.currentViolet, size: 22),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 800.ms, delay: 400.ms),
                      ),

                      // Rotating studio camera lens
                      Positioned(
                        top: 30,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(color: Colors.white24, width: 1.2),
                            boxShadow: const [AppGlows.violetGlow],
                          ),
                          child: Transform.rotate(
                            angle: _animationController.value * 6.28,
                            child: const Icon(Icons.camera_rounded, color: AppColors.currentViolet, size: 38),
                          ),
                        ),
                      ),

                      // Floating Condenser Microphone
                      Positioned(
                        bottom: 25,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(color: Colors.white10, width: 1),
                          ),
                          child: const Icon(Icons.mic_external_on_rounded, color: Colors.white70, size: 20)
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .slideY(begin: 0.1, end: -0.1, duration: 900.ms),
                        ),
                      ),
                    ],
                  );
                },
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 1000.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 16),

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

              const SizedBox(height: 48),

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

// ── Cinematic 3D Studio perspective painter ──────────────────
class CinematicIntroPainter extends CustomPainter {
  final double progress;

  CinematicIntroPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    // Draw perspective deck lines
    for (int i = -6; i <= 6; i++) {
      canvas.drawLine(
        Offset(centerX + i * 20, centerY + 20),
        Offset(centerX + i * 45, centerY + 100),
        gridPaint,
      );
    }
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(centerX - 150, centerY + 20 + i * 20),
        Offset(centerX + 150, centerY + 20 + i * 20),
        gridPaint,
      );
    }

    // Spotlights (warm studio lights)
    final pathLeft = Path()
      ..moveTo(centerX - 60, centerY - 60)
      ..lineTo(centerX - 130, centerY + 80)
      ..lineTo(centerX - 40, centerY + 80)
      ..close();
    final pathRight = Path()
      ..moveTo(centerX + 60, centerY - 60)
      ..lineTo(centerX + 40, centerY + 80)
      ..lineTo(centerX + 130, centerY + 80)
      ..close();

    final lightPaint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.currentViolet.withValues(alpha: 0.15), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset(centerX, centerY - 60), radius: 150));

    canvas.drawPath(pathLeft, lightPaint);
    canvas.drawPath(pathRight, lightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
