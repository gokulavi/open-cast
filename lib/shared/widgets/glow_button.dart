// ============================================================
// lib/shared/widgets/glow_button.dart
// Premium glowing cyberpunk button with scale animations
// ============================================================

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class GlowButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool loading;
  final IconData? icon;
  final bool enableGlow;
  final double height;
  final double borderRadius;
  final LinearGradient? gradient;

  const GlowButton({
    super.key,
    required this.text,
    required this.onTap,
    this.loading = false,
    this.icon,
    this.enableGlow = true,
    this.height = 50.0,
    this.borderRadius = 12.0,
    this.gradient,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _animController.forward(),
        onTapUp: (_) => _animController.reverse(),
        onTapCancel: () => _animController.reverse(),
        onTap: widget.loading ? null : widget.onTap,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.gradient ?? AppColors.brandGradient,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.enableGlow ? [AppGlows.violetGlow] : [],
          ),
          child: widget.loading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: AppTheme.getHeaderStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
