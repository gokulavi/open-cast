// ============================================================
// lib/features/stream/presentation/screens/go_live_screen.dart
// Pre-stream configuration panel & countdown trigger
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glow_button.dart';

class GoLiveScreen extends ConsumerStatefulWidget {
  const GoLiveScreen({super.key});

  @override
  ConsumerState<GoLiveScreen> createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends ConsumerState<GoLiveScreen> {
  final _titleCtrl = TextEditingController();
  final _rtmpUrlCtrl = TextEditingController();
  final _rtmpKeyCtrl = TextEditingController();

  String _category = 'Gaming';
  final List<String> _platforms = [
    'Twitch',
    'YouTube',
    'Facebook',
    'Kick',
    'Trovo',
    'Instagram',
    'SOOP',
    'NAVER TV',
    'BAND',
    'NAVER Shopping',
    'CHZZK',
    'NOW',
    'NAVER Cloud Platform',
    'Custom RTMP',
  ];
  final List<String> _selectedPlatforms = [];
  
  String _resolution = '1080p (60fps)';
  String _bitrate = '4500 kbps';
  String _encoder = 'NVENC';

  String _orientation = 'Landscape (16:9)';
  String _layoutPreset = 'Picture-in-Picture (PiP)';

  bool _micOn = true;
  bool _camOn = true;

  // Countdown controller
  bool _showCountdown = false;
  int _countdownNumber = 3;
  Timer? _countdownTimer;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _rtmpUrlCtrl.dispose();
    _rtmpKeyCtrl.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _onTogglePlatform(String platform) {
    setState(() {
      if (_selectedPlatforms.contains(platform)) {
        _selectedPlatforms.remove(platform);
      } else {
        _selectedPlatforms.add(platform);
      }
    });
  }

  void _triggerGoLive() {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a stream title!')),
      );
      return;
    }
    if (_selectedPlatforms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one stream platform!')),
      );
      return;
    }

    setState(() {
      _showCountdown = true;
      _countdownNumber = 3;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownNumber == 1) {
        timer.cancel();
        // Start streaming state
        ref.read(streamSessionProvider.notifier).startSession(
              title: _titleCtrl.text.trim(),
              category: _category,
              platforms: _selectedPlatforms,
            );
        // Set volume/toggles
        ref.read(micMutedProvider.notifier).state = !_micOn;
        ref.read(musicMutedProvider.notifier).state = !_camOn;

        if (mounted) {
          context.go('/studio');
        }
      } else {
        setState(() {
          _countdownNumber--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scenes = ref.watch(scenesProvider);
    final activeScene = scenes.firstWhere((s) => s.isActive, orElse: () => scenes.first);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-aware colors
    final scaffoldBg = isDark ? AppColors.matteBlack : const Color(0xFFE4E7EC);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.white54 : const Color(0xFF64748B);
    final textTertiary = isDark ? Colors.white30 : const Color(0xFF94A3B8);
    final textMuted = isDark ? Colors.white38 : const Color(0xFFAEB8C4);
    final inputFill = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.04);
    final dropdownBg = isDark ? AppColors.matteBlack : Colors.white;
    final dropdownSurfaceBg = isDark ? AppColors.surface : const Color(0xFFF1F5F9);
    final bottomBarBg = isDark ? const Color(0xFF161616) : const Color(0xFFFFFFFF);
    final platformInactive = isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03);
    final platformTextInactive = isDark ? Colors.white54 : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // Main Config panel
          CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  'CREATE STREAM SESSION',
                  style: AppTheme.getHeaderStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.currentViolet : AppColors.currentViolet),
                ),
                centerTitle: true,
                pinned: true,
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // â”€â”€ TITLE INPUT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      Text(
                        'STREAM TITLE (MAX 140 CHARS)',
                        style: AppTheme.getH2Style(fontSize: 12, color: AppColors.currentViolet),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _titleCtrl,
                        maxLength: 140,
                        maxLines: 2,
                        style: AppTheme.getBodyStyle(color: textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Enter title here (e.g. Chill Coding Session)...',
                          hintStyle: AppTheme.getBodyStyle(color: textTertiary),
                          filled: true,
                          fillColor: inputFill,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // â”€â”€ CATEGORY DROP DOWN â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'STREAM CATEGORY',
                                  style: AppTheme.getH2Style(fontSize: 12, color: AppColors.currentViolet),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: inputFill,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor: dropdownBg,
                                        textTheme: Theme.of(context).textTheme.copyWith(
                                          titleMedium: AppTheme.getBodyStyle(color: textPrimary),
                                          bodyLarge: AppTheme.getBodyStyle(color: textPrimary),
                                          bodyMedium: AppTheme.getBodyStyle(color: textPrimary),
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: _category,
                                        isExpanded: true,
                                        dropdownColor: dropdownBg,
                                        style: AppTheme.getBodyStyle(color: textPrimary),
                                        items: ['Gaming', 'Just Chatting', 'Music', 'Art', 'Tech', 'IRL']
                                            .map((c) => DropdownMenuItem(
                                                  value: c,
                                                  child: Text(
                                                    c,
                                                    style: AppTheme.getBodyStyle(color: textPrimary),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (val) => setState(() => _category = val ?? 'Gaming'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Active Scene Preview thumb
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ACTIVE SCENE PREVIEW',
                                  style: AppTheme.getH2Style(fontSize: 12, color: AppColors.currentViolet),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(activeScene.thumbnail),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(color: AppColors.accentPurpleGlow),
                                  ),
                                  child: Center(
                                    child: Container(
                                      color: Colors.black54,
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Text(
                                        activeScene.name,
                                        style: AppTheme.getHeaderStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // â”€â”€ PLATFORMS GRID â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      Text(
                        'STREAM PLATFORMS',
                        style: AppTheme.getH2Style(fontSize: 12, color: AppColors.currentViolet),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: _platforms.length,
                        itemBuilder: (context, i) {
                          final platform = _platforms[i];
                          final active = _selectedPlatforms.contains(platform);
                          return GestureDetector(
                            onTap: () => _onTogglePlatform(platform),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: active ? AppColors.currentViolet.withValues(alpha: 0.15) : platformInactive,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: active ? AppColors.accentPurpleGlow : AppColors.border,
                                  width: 1.5,
                                ),
                                boxShadow: active ? [AppGlows.violetGlow] : [],
                              ),
                              child: Center(
                                child: Text(
                                  platform,
                                  style: AppTheme.getHeaderStyle(
                                    fontSize: 13,
                                    fontWeight: active ? FontWeight.bold : FontWeight.w500,
                                    color: active ? (isDark ? AppColors.softWhite : AppColors.currentViolet) : platformTextInactive,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Custom RTMP Configuration Fields expansion
                      if (_selectedPlatforms.contains('Custom RTMP')) ...[
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CUSTOM RTMP SERVER SETTINGS',
                                style: AppTheme.getHeaderStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondary),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _rtmpUrlCtrl,
                                style: AppTheme.getBodyStyle(color: textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'rtmp://your-streaming-server-url.com/live',
                                  labelText: 'RTMP URL',
                                  labelStyle: TextStyle(color: textSecondary),
                                  filled: false,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _rtmpKeyCtrl,
                                obscureText: true,
                                style: AppTheme.getBodyStyle(color: textPrimary),
                                decoration: InputDecoration(
                                  hintText: 'Enter stream key...',
                                  labelText: 'Stream Key',
                                  labelStyle: TextStyle(color: textSecondary),
                                  filled: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // â”€â”€ QUALITY PRESETS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      Text(
                        'VIDEO QUALITY PRESETS',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondary),
                      ),
                      const SizedBox(height: 8),
                      GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            _buildQualityDropdown('Resolution', _resolution, ['720p (30fps)', '720p (60fps)', '1080p (30fps)', '1080p (60fps)'], (v) => setState(() => _resolution = v)),
                            const SizedBox(width: 12),
                            _buildQualityDropdown('Bitrate', _bitrate, ['2500 kbps', '4500 kbps', '6000 kbps', '8000 kbps'], (v) => setState(() => _bitrate = v)),
                            const SizedBox(width: 12),
                            _buildQualityDropdown('Encoder', _encoder, ['x264', 'NVENC', 'AMF', 'QuickSync'], (v) => setState(() => _encoder = v)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // â”€â”€ STREAM LAYOUT & ORIENTATION â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                      Text(
                        'STREAM LAYOUT & ORIENTATION',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondary),
                      ),
                      const SizedBox(height: 8),
                      GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Orientation', style: AppTheme.getBodyStyle(fontSize: 10, color: textMuted)),
                                      const SizedBox(height: 4),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: dropdownSurfaceBg,
                                          textTheme: Theme.of(context).textTheme.copyWith(
                                            titleMedium: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                                            bodyLarge: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                                            bodyMedium: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                                          ),
                                        ),
                                        child: DropdownButton<String>(
                                          value: _orientation,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          dropdownColor: dropdownSurfaceBg,
                                          style: AppTheme.getBodyStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary),
                                          items: ['Landscape (16:9)', 'Portrait (9:16)'].map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e,
                                              style: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                                            ),
                                          )).toList(),
                                          onChanged: (v) => setState(() => _orientation = v!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Layout Preset', style: AppTheme.getBodyStyle(fontSize: 10, color: textMuted)),
                                      const SizedBox(height: 4),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: dropdownSurfaceBg,
                                          textTheme: Theme.of(context).textTheme.copyWith(
                                            titleMedium: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                                            bodyLarge: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                                            bodyMedium: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                                          ),
                                        ),
                                        child: DropdownButton<String>(
                                          value: _layoutPreset,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          dropdownColor: dropdownSurfaceBg,
                                          style: AppTheme.getBodyStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary),
                                          items: ['Single Source', 'Picture-in-Picture (PiP)', 'Split Screen', 'Side-by-Side'].map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(
                                              e,
                                              style: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                                            ),
                                          )).toList(),
                                          onChanged: (v) => setState(() => _layoutPreset = v!),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Orientation icon representation:
                            Row(
                              children: [
                                Icon(
                                  _orientation.contains('Portrait') ? Icons.stay_current_portrait_rounded : Icons.stay_current_landscape_rounded,
                                  color: AppColors.currentViolet,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _orientation.contains('Portrait') 
                                        ? 'Optimized for TikTok, Reels, & Shorts (Mobile portrait streams)'
                                        : 'Optimized for YouTube, Twitch, & Facebook (Widescreen landscape streams)',
                                    style: AppTheme.getBodyStyle(fontSize: 10, color: textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120), // Bottom spacer
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar containing hardware toggles and the triggers
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: bottomBarBg,
                border: Border(top: BorderSide(color: AppColors.border)),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  // Mic toggle
                  IconButton(
                    icon: Icon(_micOn ? Icons.mic_rounded : Icons.mic_off_rounded, color: _micOn ? AppColors.accentPurpleGlow : AppColors.liveRed),
                    onPressed: () => setState(() => _micOn = !_micOn),
                  ),
                  // Camera toggle
                  IconButton(
                    icon: Icon(_camOn ? Icons.videocam_rounded : Icons.videocam_off_rounded, color: _camOn ? AppColors.accentPurpleGlow : AppColors.liveRed),
                    onPressed: () => setState(() => _camOn = !_camOn),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlowButton(
                      text: 'LAUNCH BROADCAST',
                      gradient: LinearGradient(colors: [AppColors.onlineGreen, Color(0xFF1B5E20)]),
                      onTap: _triggerGoLive,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // â”€â”€ COUNTDOWN OVERLAY â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          if (_showCountdown)
            Container(
              color: Colors.black.withValues(alpha: 0.9),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'STARTING IN',
                      style: AppTheme.getHeaderStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '$_countdownNumber',
                      style: AppTheme.getHeaderStyle(
                        fontSize: 120,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentPurpleGlow,
                      ),
                    )
                        .animate(key: ValueKey(_countdownNumber))
                        .scale(
                          begin: const Offset(0.2, 0.2),
                          end: const Offset(1.0, 1.0),
                          duration: 400.ms,
                          curve: Curves.elasticOut,
                        )
                        .fadeOut(delay: 600.ms, duration: 400.ms),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQualityDropdown(String label, String value, List<String> options, Function(String) onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textTertiary = isDark ? Colors.white30 : const Color(0xFF94A3B8);
    final dropdownBg = isDark ? AppColors.matteBlack : Colors.white;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTheme.getBodyStyle(fontSize: 10, color: textTertiary)),
          DropdownButtonHideUnderline(
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: dropdownBg,
                textTheme: Theme.of(context).textTheme.copyWith(
                  titleMedium: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                  bodyLarge: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                  bodyMedium: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                ),
              ),
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: dropdownBg,
                style: AppTheme.getBodyStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary),
                items: options.map((o) => DropdownMenuItem(
                  value: o,
                  child: Text(
                    o,
                    style: AppTheme.getBodyStyle(fontSize: 12, color: textPrimary),
                  ),
                )).toList(),
                onChanged: (val) {
                  if (val != null) onChanged(val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

