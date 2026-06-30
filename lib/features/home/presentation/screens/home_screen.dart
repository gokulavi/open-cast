// ============================================================
// lib/features/home/presentation/screens/home_screen.dart
// Cyberpunk main control dashboard
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/live_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final session = ref.watch(streamSessionProvider);
    final stats = ref.watch(analyticsProvider);
    final isLive = session.status == StreamStatus.live;

    final themeType = ref.watch(themeProvider);
    final isBright = themeType == 'bright';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final subheadColor = isDark ? Colors.white38 : Colors.black45;
    final iconColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Colors.transparent, // Shell handles background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // â”€â”€ TOP BAR â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME BACK,',
                        style: AppTheme.getBodyStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: subheadColor,
                        ),
                      ),
                      Text(
                        user?.username.toUpperCase() ?? 'STREAMER',
                        style: AppTheme.getHeaderStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ).copyWith(
                          color: Colors.amber,
                          shadows: [
                            Shadow(
                              color: Colors.amber.withValues(alpha: 0.6),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.amberAccent,
                          decorationStyle: TextDecorationStyle.double,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'CREATOR SHORTCUTS',
                          style: AppTheme.getH2Style(fontSize: 10, color: AppColors.currentViolet),
                        ),
                        const SizedBox(height: 6),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              _ToolChip(label: 'AI Auto Captions', icon: Icons.closed_caption_rounded),
                              _ToolChip(label: 'Screen Overlay', icon: Icons.branding_watermark_rounded, active: true),
                              _ToolChip(label: 'Alert Animations', icon: Icons.celebration_rounded, active: true),
                              _ToolChip(label: 'Noise Cancellation', icon: Icons.waves_rounded),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // â”€â”€ LIVE STREAMING BANNER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              if (isLive) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.currentViolet, AppColors.liveRed],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [AppGlows.violetGlow],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LiveBadge(showViewerCount: false),
                            const SizedBox(height: 12),
                            Text(
                              session.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.getHeaderStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Category: ${session.category} â€¢ Active Platforms: ${session.activePlatforms.join(", ")}',
                              style: AppTheme.getBodyStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.videocam_rounded, color: Colors.white, size: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // â”€â”€ QUICK ACTIONS (2x2 Grid) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Text(
                'QUICK OPERATIONS',
                style: AppTheme.getH2Style(fontSize: 14, color: AppColors.currentViolet),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 550;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isWide ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.25,
                    children: [
                      _QuickActionCard(
                        icon: Icons.videocam_rounded,
                        title: 'Go Live Setup',
                        color: AppColors.onlineGreen,
                        onTap: () => context.push('/go-live'),
                      ),
                      _QuickActionCard(
                        icon: Icons.layers_rounded,
                        title: 'Stream Studio',
                        color: AppColors.currentViolet,
                        onTap: () => context.push('/studio'),
                      ),
                      _QuickActionCard(
                        icon: Icons.chat_bubble_rounded,
                        title: 'Chat Overlay',
                        color: AppColors.infoBlue,
                        onTap: () => context.push('/chat'),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // â”€â”€ STREAM HEALTH STATS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              // ——————————————————————————————————————————————————————————
              if (isLive) ...[
                Text(
                  'STREAM METRICS & HEALTH',
                  style: AppTheme.getH2Style(fontSize: 14, color: AppColors.currentViolet),
                ),
                const SizedBox(height: 12),
                GlassCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _HealthMetric(label: 'Bitrate', value: '${session.bitrate.toInt()} kbps'),
                      _HealthMetric(label: 'FPS', value: '${session.fps.toInt()}'),
                      _HealthMetric(label: 'Health', value: 'Excellent', color: AppColors.onlineGreen),
                      _HealthMetric(label: 'Delay', value: '0.8s'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── RECENT STREAMS LIST ──────────────────────────────────────
              Text(
                'RECENT STREAM LOGS',
                style: AppTheme.getH2Style(fontSize: 14, color: AppColors.currentViolet),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.recentStreams.length,
                itemBuilder: (context, i) {
                  final stream = stats.recentStreams[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(Icons.videocam_rounded, color: AppColors.accentPurpleGlow),
                      title: Text(
                        stream['title'],
                        style: AppTheme.getBodyStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${stream['date']} • Duration: ${stream['duration']}',
                        style: AppTheme.getBodyStyle(fontSize: 11, color: AppColors.textFaded),
                      ),
                      trailing: Text(
                        '${stream['views']} Views',
                        style: AppTheme.getHeaderStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onlineGreen),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),


            ],
          ),
        ),
      ),
    );
  }
}

// ——————————————————————————————————————————————————————————
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.getHeaderStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// ——————————————————————————————————————————————————————————
class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _HealthMetric({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: AppTheme.getBodyStyle(fontSize: 10, color: Colors.white30),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.getHeaderStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.softWhite,
          ),
        ),
      ],
    );
  }
}

// â”€â”€ Shortcuts Toggle Chip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _ToolChip extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool active;

  const _ToolChip({required this.label, required this.icon, this.active = false});

  @override
  State<_ToolChip> createState() => _ToolChipState();
}

class _ToolChipState extends State<_ToolChip> {
  late bool _active;

  @override
  void initState() {
    super.initState();
    _active = widget.active;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor;
    final Color borderColor;
    final Color contentColor;

    if (isDark) {
      bgColor = _active 
          ? AppColors.currentViolet.withValues(alpha: 0.15) 
          : Colors.white.withValues(alpha: 0.04);
      borderColor = _active 
          ? AppColors.accentPurpleGlow 
          : AppColors.border;
      contentColor = _active 
          ? AppColors.softWhite 
          : Colors.white54;
    } else {
      // Bright mode (Light theme)
      bgColor = _active 
          ? AppColors.currentViolet.withValues(alpha: 0.2) 
          : Colors.black.withValues(alpha: 0.05);
      borderColor = _active 
          ? AppColors.currentViolet 
          : Colors.black12;
      contentColor = _active 
          ? Colors.black 
          : Colors.black87;
    }

    return GestureDetector(
      onTap: () => setState(() => _active = !_active),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
          boxShadow: _active && isDark ? [AppGlows.violetGlow] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: contentColor,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: AppTheme.getBodyStyle(
                fontSize: 12,
                fontWeight: _active ? FontWeight.bold : FontWeight.normal,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

