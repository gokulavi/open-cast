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
    final themeConfig = ref.watch(themeProvider);
        final user = ref.watch(userProvider);
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator(color: AppColors.currentViolet)),
      );
    }

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

              // â”€â”€ APPEARANCE & BRAND THEME â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
                      child: Text('THEME MODE', style: AppTheme.getBodyStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.currentViolet)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text('Dark Pro', style: AppTheme.getBodyStyle(fontSize: 14)),
                            value: true,
                            groupValue: themeConfig.isDark,
                            activeColor: AppColors.currentViolet,
                            onChanged: (val) {
                              if (val != null) {
                                final newConfig = themeConfig.copyWith(isDark: val);
                                ref.read(themeProvider.notifier).state = newConfig;
                                ref.read(settingsProvider.notifier).updateTheme(newConfig);
                              }
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text('Bright', style: AppTheme.getBodyStyle(fontSize: 14)),
                            value: false,
                            groupValue: themeConfig.isDark,
                            activeColor: AppColors.currentViolet,
                            onChanged: (val) {
                              if (val != null) {
                                final newConfig = themeConfig.copyWith(isDark: val);
                                ref.read(themeProvider.notifier).state = newConfig;
                                ref.read(settingsProvider.notifier).updateTheme(newConfig);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 8),
                      child: Text('COLOR PALETTE', style: AppTheme.getBodyStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.currentViolet)),
                    ),
                    RadioListTile<ThemePalette>(
                      title: Text('Golden (Default)', style: AppTheme.getBodyStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      subtitle: Text('Classic OpenCast luxury gold and black.', style: AppTheme.getBodyStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38)),
                      value: ThemePalette.gold,
                      groupValue: themeConfig.palette,
                      activeColor: const Color(0xFFD4AF37),
                      onChanged: (val) {
                        if (val != null) {
                          final newConfig = themeConfig.copyWith(palette: val);
                          ref.read(themeProvider.notifier).state = newConfig;
                          ref.read(settingsProvider.notifier).updateTheme(newConfig);
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    RadioListTile<ThemePalette>(
                      title: Text('Sea Green', style: AppTheme.getBodyStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      subtitle: Text('Refreshing and vibrant natural green aesthetic.', style: AppTheme.getBodyStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38)),
                      value: ThemePalette.seaGreen,
                      groupValue: themeConfig.palette,
                      activeColor: const Color(0xFF2E8A56),
                      onChanged: (val) {
                        if (val != null) {
                          final newConfig = themeConfig.copyWith(palette: val);
                          ref.read(themeProvider.notifier).state = newConfig;
                          ref.read(settingsProvider.notifier).updateTheme(newConfig);
                        }
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    RadioListTile<ThemePalette>(
                      title: Text('Vicious Violet', style: AppTheme.getBodyStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      subtitle: Text('Deep neon violet for a true cyberpunk feel.', style: AppTheme.getBodyStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.black38)),
                      value: ThemePalette.violet,
                      groupValue: themeConfig.palette,
                      activeColor: const Color(0xFF9343A3),
                      onChanged: (val) {
                        if (val != null) {
                          final newConfig = themeConfig.copyWith(palette: val);
                          ref.read(themeProvider.notifier).state = newConfig;
                          ref.read(settingsProvider.notifier).updateTheme(newConfig);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // â”€â”€ STREAM QUALITY PRESETS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
                      ['x264', 'NVENC', 'QuickSync'],
                      (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(encoder: v)),
                    ),
                    const Divider(height: 20),
                    _buildSettingsDropdown(
                      context,
                      'Target Streaming Bitrate',
                      '${settings.bitrate} kbps',
                      ['2500 kbps', '4000 kbps', '4500 kbps', '8000 kbps'],
                      (v) => ref.read(settingsProvider.notifier).updateSettings(
                            settings.copyWith(bitrate: int.parse(v.replaceAll(' kbps', ''))),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // â”€â”€ HARDWARE & DEVICES â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

              // â”€â”€ CREATOR AI SHORTCUTS (BETA) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

                  ],
                ),
              ),
              const SizedBox(height: 24),

              // â”€â”€ CHATBOT ASSISTANT CONFIG â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Text(
                'CHATBOT ASSISTANT CONFIG',
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
                      title: Text('Enable Chatbot Assistant', style: AppTheme.getBodyStyle(fontSize: 14)),
                      value: settings.enableChatbot,
                      activeColor: AppColors.currentViolet,
                      onChanged: (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(enableChatbot: v)),
                    ),
                    if (settings.enableChatbot) ...[
                      const Divider(height: 1),
                      _buildTextField(
                        context: context,
                        label: 'Chatbot Bot Display Name',
                        initialValue: settings.chatbotName,
                        onChanged: (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(chatbotName: v.trim())),
                      ),
                      const Divider(height: 1),
                      _buildTextField(
                        context: context,
                        label: 'Subscriber Welcome Greeting Template',
                        initialValue: settings.chatbotReplyTemplate,
                        helperText: 'Use {username} to automatically insert the subscriber\'s name.',
                        onChanged: (v) => ref.read(settingsProvider.notifier).updateSettings(settings.copyWith(chatbotReplyTemplate: v)),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // â”€â”€ RESET TO DEFAULT ACTION â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.liveRed),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ref.read(settingsProvider.notifier).updateSettings(const AppSettings());
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Settings reset to default!',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: AppColors.currentViolet,
                    ),
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
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDark ? Colors.white12 : Colors.black12,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      o,
                      style: AppTheme.getBodyStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
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

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
    String? helperText,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initialValue,
            style: AppTheme.getBodyStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.black.withValues(alpha: 0.03),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              helperText: helperText,
              helperStyle: AppTheme.getBodyStyle(fontSize: 10, color: isDark ? Colors.white30 : Colors.black38),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

