// ============================================================
// lib/features/auth/presentation/screens/permissions_screen.dart
// Cyberpunk Permission request center for Camera, Mic & Notifications
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glow_button.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  PermissionStatus _cameraStatus = PermissionStatus.denied;
  PermissionStatus _micStatus = PermissionStatus.denied;
  PermissionStatus _notificationStatus = PermissionStatus.denied;
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final camera = await Permission.camera.status;
    final mic = await Permission.microphone.status;
    final notification = await Permission.notification.status;

    if (mounted) {
      setState(() {
        _cameraStatus = camera;
        _micStatus = mic;
        _notificationStatus = notification;
        _hasChecked = true;
      });
    }
  }

  Future<void> _requestPermissions() async {
    // Request all permissions
    final statuses = await [
      Permission.camera,
      Permission.microphone,
      Permission.notification,
    ].request();

    if (mounted) {
      setState(() {
        _cameraStatus = statuses[Permission.camera] ?? _cameraStatus;
        _micStatus = statuses[Permission.microphone] ?? _micStatus;
        _notificationStatus = statuses[Permission.notification] ?? _notificationStatus;
      });
    }
  }

  void _onContinue() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('has_requested_permissions', true);
    ref.read(permissionsRequestedProvider.notifier).state = true;
    if (mounted) {
      context.go('/home');
    }
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String description,
    required PermissionStatus status,
    required Future<void> Function() onRequest,
  }) {
    Color statusColor;
    String statusText;

    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        statusColor = AppColors.onlineGreen;
        statusText = 'GRANTED';
        break;
      case PermissionStatus.permanentlyDenied:
        statusColor = AppColors.liveRed;
        statusText = 'PERMANENTLY DENIED';
        break;
      case PermissionStatus.restricted:
        statusColor = AppColors.liveRed;
        statusText = 'RESTRICTED';
        break;
      case PermissionStatus.denied:
      default:
        statusColor = AppColors.warningAmber;
        statusText = 'NOT GRANTED';
        break;
    }

    final isGranted = status == PermissionStatus.granted || status == PermissionStatus.limited;

    return GestureDetector(
      onTap: isGranted
          ? null
          : () async {
              if (status == PermissionStatus.permanentlyDenied) {
                await openAppSettings();
              } else {
                await onRequest();
              }
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isGranted ? AppColors.border : AppColors.currentViolet.withValues(alpha: 0.25),
            width: isGranted ? 0.8 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.currentViolet.withValues(alpha: 0.1),
              ),
              child: Icon(icon, color: AppColors.currentViolet, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.getHeaderStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.softWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.getBodyStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
                  ),
                  child: Text(
                    statusText,
                    style: AppTheme.getBodyStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                if (status == PermissionStatus.permanentlyDenied) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: openAppSettings,
                    child: const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.infoBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeType = ref.watch(themeProvider);
    final isBright = themeType == 'bright';

    if (!_hasChecked) {
      return Scaffold(
        backgroundColor: isBright ? const Color(0xFF090514) : AppColors.matteBlack,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.currentViolet),
        ),
      );
    }

    final isAnyPermanentlyDenied = _cameraStatus == PermissionStatus.permanentlyDenied ||
        _micStatus == PermissionStatus.permanentlyDenied ||
        _notificationStatus == PermissionStatus.permanentlyDenied;

    return Scaffold(
      backgroundColor: isBright ? const Color(0xFF090514) : AppColors.matteBlack,
      body: Stack(
        children: [
          // Cyberpunk background glowing circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.currentViolet.withValues(alpha: 0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.currentViolet.withValues(alpha: 0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon and title area
                    const Icon(
                      Icons.security_rounded,
                      color: AppColors.currentViolet,
                      size: 56,
                    )
                        .animate()
                        .scale(duration: 500.ms, curve: Curves.easeOutBack)
                        .fadeIn(),
                    const SizedBox(height: 12),
                    Text(
                      'SYSTEM ACCESS REQUIRED',
                      textAlign: TextAlign.center,
                      style: AppTheme.getHeaderStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 6),
                    Text(
                      'Open Cast needs the following permissions to enable studio broadcasting & chat notifications.',
                      textAlign: TextAlign.center,
                      style: AppTheme.getBodyStyle(
                        fontSize: 13,
                        color: Colors.white38,
                      ),
                    ).animate().fadeIn(delay: 350.ms),
                    const SizedBox(height: 28),

                    // Permissions Card
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildPermissionTile(
                            icon: Icons.camera_rounded,
                            title: 'Camera',
                            description: 'Required for broadcasting your video feed.',
                            status: _cameraStatus,
                            onRequest: () async {
                              await Permission.camera.request();
                              await _checkPermissions();
                            },
                          ),
                          _buildPermissionTile(
                            icon: Icons.mic_rounded,
                            title: 'Microphone',
                            description: 'Required for capturing stream audio.',
                            status: _micStatus,
                            onRequest: () async {
                              await Permission.microphone.request();
                              await _checkPermissions();
                            },
                          ),
                          _buildPermissionTile(
                            icon: Icons.notifications_rounded,
                            title: 'Notifications',
                            description: 'Required for chat and live status alerts.',
                            status: _notificationStatus,
                            onRequest: () async {
                              await Permission.notification.request();
                              await _checkPermissions();
                            },
                          ),
                        ],
                      ),
                    ).animate().slideY(begin: 0.1, end: 0, duration: 500.ms, curve: Curves.easeOut).fadeIn(),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _requestPermissions,
                            child: Text(
                              'GRANT ACCESS',
                              style: AppTheme.getHeaderStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GlowButton(
                            text: 'CONTINUE',
                            onTap: _onContinue,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 500.ms),
                    
                    if (isAnyPermanentlyDenied) ...[
                      const SizedBox(height: 20),
                      Text(
                        'One or more permissions are permanently denied. Please click the Settings link to enable them manually in System Settings.',
                        textAlign: TextAlign.center,
                        style: AppTheme.getBodyStyle(
                          fontSize: 11,
                          color: AppColors.liveRed.withValues(alpha: 0.8),
                        ),
                      ).animate().fadeIn(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
