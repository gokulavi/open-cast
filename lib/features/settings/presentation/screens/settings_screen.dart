// ============================================================
// lib/features/settings/presentation/screens/settings_screen.dart
// Configurator dashboard for streaming parameters & themes
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/widgets/glass_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final themeType = ref.watch(themeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STUDIO SETTINGS',
                style: AppTheme.getHeaderStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.currentViolet,
                ),
              ),
              const SizedBox(height: 24),

              // ── APPEARANCE & BRAND THEME ──────────────────────────────
              Text(
                'APPEARANCE',
                style: AppTheme.getH2Style(
                  fontSize: 12,
                  color: AppColors.currentViolet,
                ),
              ),
              const SizedBox(height: 8),
              GlassCard(
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Dark Pro', style: AppTheme.getBodyStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Minimalist deep matte black with violet accents.',
                        style: AppTheme.getBodyStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
                      ),
                      value: 'darkPro',
                      groupValue: themeType,
                      activeColor: AppColors.currentViolet,
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(themeProvider.notifier).state = val;
                          ref.read(settingsProvider.notifier).updateTheme(val);
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    RadioListTile<String>(
                      title: Text('Bright', style: AppTheme.getBodyStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Premium bright theme with light background.',
                        style: AppTheme.getBodyStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38),
                      ),
                      value: 'bright',
                      groupValue: themeType,
                      activeColor: AppColors.currentViolet,
                      onChanged: (val) {
                        if (val != null) {
                          ref.read(themeProvider.notifier).state = val;
                          ref.read(settingsProvider.notifier).updateTheme(val);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── STREAM QUALITY PRESETS ─────────────────────────────────
              Text(
                'STREAM QUALITY CONFIGURATION',
                style: AppTheme.getH2Style(
                  fontSize: 12,
                  color: AppColors.currentViolet,
                ),
              ),
              const SizedBox(height: 8),
              GlassCard(
                child: Column(
                  children: [
                    _buildSettingsDropdown(
                      context,
                      'Broadcast Quality Preset',
                      settings.videoQuality,
                      ['720p (30fps)', '720p (60fps)', '1080p (30fps)', '1080p (60fps)'],
                      (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(videoQuality: v)),
                    ),
                    const Divider(height: 20),
                    _buildSettingsDropdown(
                      context,
                      'Video Hardware Encoder',
                      settings.encoder,
                      ['x264', 'NVENC', 'AMF', 'QuickSync'],
                      (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(encoder: v)),
                    ),
                    const Divider(height: 20),
                    _buildSettingsDropdown(
                      context,
                      'Target Streaming Bitrate',
                      '${settings.bitrate} kbps',
                      ['2500 kbps', '4500 kbps', '6000 kbps', '8000 kbps'],
                      (v) => ref.read(settingsProvider.notifier).updateSettings(
                            settings.copyWith(bitrate: int.parse(v.replaceAll(' kbps', ''))),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── HARDWARE & DEVICES ─────────────────────────────────────
              Text(
                'AUDIO & CAPTURE DEVICES',
                style: AppTheme.getH2Style(
                  fontSize: 12,
                  color: AppColors.currentViolet,
                ),
              ),
              const SizedBox(height: 8),
              GlassCard(
                child: Column(
                  children: [
                    _buildSettingsDropdown(
                      context,
                      'Input Microphone Source',
                      settings.audioInputDevice,
                      ['Default Studio Mic', 'Webcam Mic Input', 'System Virtual Link'],
                      (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(audioInputDevice: v)),
                    ),
                    const Divider(height: 20),
                    _buildSettingsDropdown(
                      context,
                      'Active Video Webcam Source',
                      settings.videoInputDevice,
                      ['Default Webcam', 'External Camlink Input', 'Virtual OBS Source'],
                      (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(videoInputDevice: v)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── CREATOR AI SHORTCUTS (BETA) ────────────────────────────
              Text(
                'AI CO-STREAM FEATURES (BETA)',
                style: AppTheme.getH2Style(
                  fontSize: 12,
                  color: AppColors.currentViolet,
                ),
              ),
              const SizedBox(height: 8),
              GlassCard(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text('Real-time Speech Captions', style: AppTheme.getBodyStyle(fontSize: 14)),
                      value: settings.enableAICaptions,
                      activeColor: AppColors.currentViolet,
                      onChanged: (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(enableAICaptions: v)),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: Text('Smart Noise Cancellation', style: AppTheme.getBodyStyle(fontSize: 14)),
                      value: settings.enableNoiseCancel,
                      activeColor: AppColors.currentViolet,
                      onChanged: (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(enableNoiseCancel: v)),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: Text(
                        'Virtual Avatar tracking (Future)',
                        style: AppTheme.getBodyStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white24 : Colors.black26,
                        ),
                      ),
                      value: false,
                      onChanged: null, // Disabled
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── RESET TO DEFAULT ACTION ────────────────────────────────
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.liveRed),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ref.read(settingsProvider.notifier).updateSettings(const AppSettings());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings reset to default!')),
                  );
                },
                child: Text(
                  'RESET TO DEFAULTS',
                  style: AppTheme.getHeaderStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.liveRed),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsDropdown(
    BuildContext context,
    String label,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.getBodyStyle(
              fontSize: 12,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: isDark ? AppColors.matteBlack : Colors.white,
              style: AppTheme.getHeaderStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
              items: options.map((o) {
                return DropdownMenuItem(
                  value: o,
                  child: Text(
                    o,
                    style: AppTheme.getBodyStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
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
