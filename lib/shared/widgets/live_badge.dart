// ============================================================
// lib/shared/widgets/live_badge.dart
// Live stream status badge with pulsing dot animation
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class LiveBadge extends StatelessWidget {
  final int? viewerCount;
  final bool showViewerCount;

  const LiveBadge({
    super.key,
    this.viewerCount,
    this.showViewerCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.liveRed,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [AppGlows.redGlow],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing Dot
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.3, 1.3),
                duration: 750.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(width: 6),
          Text(
            'LIVE',
            style: AppTheme.getHeaderStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          if (showViewerCount && viewerCount != null) ...[
            const SizedBox(width: 8),
            Container(
              width: 1,
              height: 10,
              color: Colors.white24,
            ),
            const SizedBox(width: 8),
            Text(
              '$viewerCount',
              style: AppTheme.getBodyStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

