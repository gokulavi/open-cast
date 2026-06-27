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
import '../../../../shared/models/app_models.dart';
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
  final List<String> _platforms = ['Twitch', 'YouTube', 'Facebook', 'TikTok', 'Kick', 'Custom RTMP'];
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
        const SnackBar(content: Text('Please select at least one stream destination!')),
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
        ref.read(cameraMutedProvider.notifier).state = !_camOn;

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

    return Scaffold(
      backgroundColor: AppColors.matteBlack,
      body: Stack(
        children: [
          // Main Config panel
          CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  'CREATE STREAM SESSION',
                  style: AppTheme.getHeaderStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      // ── TITLE INPUT ───────────────────────────────────────
                      Text(
                        'STREAM TITLE (MAX 140 CHARS)',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _titleCtrl,
                        maxLength: 140,
                        maxLines: 2,
                        style: AppTheme.getBodyStyle(),
                        decoration: InputDecoration(
                          hintText: 'Enter title here (e.g. Chill Coding Session)...',
                          hintStyle: AppTheme.getBodyStyle(color: Colors.white30),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── CATEGORY DROP DOWN ────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'STREAM CATEGORY',
                                  style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _category,
                                      isExpanded: true,
                                      dropdownColor: AppColors.matteBlack,
                                      style: AppTheme.getBodyStyle(),
                                      items: ['Gaming', 'Just Chatting', 'Music', 'Art', 'Tech', 'IRL']
                                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                          .toList(),
                                      onChanged: (val) => setState(() => _category = val ?? 'Gaming'),
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
                                  style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
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

                      // ── DESTINATIONS GRID ──────────────────────────────────
                      Text(
                        'STREAM DESTINATIONS',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.6,
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
                                color: active ? AppColors.currentViolet.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
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
                                    color: active ? AppColors.softWhite : Colors.white54,
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
                                style: AppTheme.getHeaderStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white54),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _rtmpUrlCtrl,
                                style: AppTheme.getBodyStyle(),
                                decoration: const InputDecoration(
                                  hintText: 'rtmp://your-streaming-server-url.com/live',
                                  labelText: 'RTMP URL',
                                  labelStyle: TextStyle(color: Colors.white54),
                                  filled: false,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _rtmpKeyCtrl,
                                obscureText: true,
                                style: AppTheme.getBodyStyle(),
                                decoration: const InputDecoration(
                                  hintText: 'Enter stream key...',
                                  labelText: 'Stream Key',
                                  labelStyle: TextStyle(color: Colors.white54),
                                  filled: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // ── QUALITY PRESETS ────────────────────────────────────
                      Text(
                        'VIDEO QUALITY PRESETS',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
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

                      // ── STREAM LAYOUT & ORIENTATION ────────────────────────────
                      Text(
                        'STREAM LAYOUT & ORIENTATION',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
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
                                      Text('Orientation', style: AppTheme.getBodyStyle(fontSize: 10, color: Colors.white38)),
                                      const SizedBox(height: 4),
                                      DropdownButton<String>(
                                        value: _orientation,
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.surface,
                                        style: AppTheme.getBodyStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        items: ['Landscape (16:9)', 'Portrait (9:16)'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                        onChanged: (v) => setState(() => _orientation = v!),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Layout Preset', style: AppTheme.getBodyStyle(fontSize: 10, color: Colors.white38)),
                                      const SizedBox(height: 4),
                                      DropdownButton<String>(
                                        value: _layoutPreset,
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        dropdownColor: AppColors.surface,
                                        style: AppTheme.getBodyStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        items: ['Single Source', 'Picture-in-Picture (PiP)', 'Split Screen', 'Side-by-Side'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                                        onChanged: (v) => setState(() => _layoutPreset = v!),
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
                                    style: AppTheme.getBodyStyle(fontSize: 10, color: Colors.white54),
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
              decoration: const BoxDecoration(
                color: Color(0xFF161616),
                border: Border(top: BorderSide(color: AppColors.border)),
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
                      gradient: const LinearGradient(colors: [AppColors.onlineGreen, Color(0xFF1B5E20)]),
                      onTap: _triggerGoLive,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── COUNTDOWN OVERLAY ──────────────────────────────────────
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
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: AppTheme.getBodyStyle(fontSize: 10, color: Colors.white30)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.matteBlack,
              style: AppTheme.getBodyStyle(fontSize: 12, fontWeight: FontWeight.bold),
              items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
