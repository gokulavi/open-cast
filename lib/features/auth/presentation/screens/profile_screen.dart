// ============================================================
// lib/features/auth/presentation/screens/profile_screen.dart
// User account profile details & integrations
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/widgets/glass_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _bioCtrl = TextEditingController();
  bool _editingBio = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    if (user != null) {
      _bioCtrl.text = user.bio;
    }
  }

  @override
  void dispose() {
    _bioCtrl.dispose();
    super.dispose();
  }

  void _onToggleEditBio() {
    if (_editingBio) {
      ref.read(userProvider.notifier).updateBio(_bioCtrl.text);
    }
    setState(() => _editingBio = !_editingBio);
  }

  void _onSignOut() {
    ref.read(userProvider.notifier).logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final themeType = ref.watch(themeProvider);
    final isBright = themeType == 'bright';

    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator(color: AppColors.currentViolet)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MY PROFILE',
                style: AppTheme.getHeaderStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.currentViolet),
              ),
              const SizedBox(height: 24),

              // ── AVATAR & INFO CARD ─────────────────────────────────────
              GlassCard(
                child: Column(
                  children: [
                    // Avatar Glow
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accentPurpleGlow, width: 2.5),
                        boxShadow: const [AppGlows.violetGlow],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: user.avatarUrl.isNotEmpty == true
                            ? NetworkImage(user.avatarUrl)
                            : null,
                        backgroundColor: AppColors.currentViolet,
                        child: user.avatarUrl.isEmpty == true
                            ? Text(
                                user.username[0].toUpperCase(),
                                style: const TextStyle(fontSize: 24, color: Colors.white),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.username,
                      style: AppTheme.getHeaderStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: AppTheme.getBodyStyle(fontSize: 13, color: Colors.white38),
                    ),
                    
                    const SizedBox(height: 16),
                    // Bio section
                    Row(
                      children: [
                        Expanded(
                          child: _editingBio
                              ? TextField(
                                  controller: _bioCtrl,
                                  style: AppTheme.getBodyStyle(),
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withValues(alpha: 0.05),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                )
                              : Text(
                                  user.bio,
                                  textAlign: TextAlign.center,
                                  style: AppTheme.getBodyStyle(fontSize: 13, color: Colors.white70),
                                ),
                        ),
                        IconButton(
                          icon: Icon(
                            _editingBio ? Icons.check_circle_outline_rounded : Icons.edit_rounded,
                            color: AppColors.accentPurpleGlow,
                            size: 20,
                          ),
                          onPressed: _onToggleEditBio,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── FOLLOWER STATS GRID ────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem('Followers', '${user.followers}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem('Following', '${user.following}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem('Total Views', '${user.totalViews}'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── CONNECTED PLATFORMS ────────────────────────────────────
              Text(
                'CONNECTED PLATFORMS',
                style: AppTheme.getHeaderStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.currentViolet),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildPlatformRow('Twitch', user.platformConnections.contains('Twitch')),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildPlatformRow('YouTube', user.platformConnections.contains('YouTube')),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildPlatformRow('TikTok', user.platformConnections.contains('TikTok')),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── GENERAL ACCOUNT OPTIONS ────────────────────────────────
              Text(
                'ACCOUNT SETTINGS',
                style: AppTheme.getHeaderStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.currentViolet),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildSettingTile('Two-Factor Authentication', Icons.security_rounded),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildSettingTile('Privacy Control Panel', Icons.privacy_tip_rounded),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildSettingTile('Download Stream History Data', Icons.download_rounded),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── SIGN OUT TRIGGER ───────────────────────────────────────
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.liveRed),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _onSignOut,
                child: Text(
                  'SIGN OUT',
                  style: AppTheme.getHeaderStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.liveRed,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.getHeaderStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.getBodyStyle(fontSize: 11, color: Colors.white30),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformRow(String name, bool connected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: AppTheme.getBodyStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          TextButton(
            onPressed: () {
              if (connected) {
                ref.read(userProvider.notifier).disconnectPlatform(name);
              } else {
                ref.read(userProvider.notifier).connectPlatform(name);
              }
            },
            child: Text(
              connected ? 'Disconnect' : 'Connect',
              style: TextStyle(
                color: connected ? AppColors.liveRed : AppColors.onlineGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(String label, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accentPurpleGlow, size: 20),
      title: Text(
        label,
        style: AppTheme.getBodyStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
      onTap: () {},
    );
  }
}
