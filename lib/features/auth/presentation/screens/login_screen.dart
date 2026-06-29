// ============================================================
// lib/features/auth/presentation/screens/login_screen.dart
// Cyberpunk Login UI screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glow_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    // Simulate login delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (_emailCtrl.text == 'test@opencast.app' && _passCtrl.text == 'password') {
      ref.read(userProvider.notifier).login(UserModel.mock);
      context.go('/home');
    } else {
      setState(() {
        _errorMsg = 'Invalid email or password. Use test@opencast.app / password';
        _loading = false;
      });
    }
  }

  void _onGuestSignIn() {
    ref.read(userProvider.notifier).login(const UserModel(
          id: 'guest_user',
          username: 'Guest Broadcaster',
          email: 'guest@opencast.app',
          avatarUrl: '',
          bio: 'Guest streamer trying out Open Cast.',
        ));
    context.go('/home');
  }

  void _onGoogleSignIn() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    ref.read(userProvider.notifier).login(UserModel.mock.copyWith(
          username: 'Google Streamer',
          avatarUrl: 'https://i.pravatar.cc/150?img=12',
          platformConnections: ['Google', 'YouTube'],
        ));
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final themeType = ref.watch(themeProvider);
    final isBright = themeType == 'bright';

    return Scaffold(
      backgroundColor: isBright ? const Color(0xFF090514) : AppColors.matteBlack,
      body: Stack(
        children: [
          // Animated background element
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.currentViolet.withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.currentViolet.withValues(alpha: 0.15),
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
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    // Brand Header
                    Icon(
                      Icons.podcasts_rounded,
                      color: AppColors.accentPurpleGlow,
                      size: 60,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'OPEN CAST',
                      style: AppTheme.getHeaderStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ultimate Control Center',
                      style: AppTheme.getBodyStyle(
                        fontSize: 14,
                        color: Colors.white38,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Login glass card
                    GlassCard(
                      padding: const EdgeInsets.all(28),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Sign In',
                              style: AppTheme.getHeaderStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Email input
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              style: AppTheme.getBodyStyle(),
                              decoration: InputDecoration(
                                hintText: 'Email address',
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.05),
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.white30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.accentPurpleGlow, width: 1.5),
                                ),
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Email is required' : null,
                            ),
                            const SizedBox(height: 16),

                            // Password input
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: true,
                              style: AppTheme.getBodyStyle(),
                              decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.05),
                                prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.white30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: AppColors.accentPurpleGlow, width: 1.5),
                                ),
                              ),
                              validator: (val) => val == null || val.isEmpty ? 'Password is required' : null,
                            ),
                            
                            if (_errorMsg != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                _errorMsg!,
                                style: const TextStyle(color: AppColors.liveRed, fontSize: 13),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Submit Button
                            GlowButton(
                              text: 'SIGN IN',
                              loading: _loading,
                              onTap: _onSignIn,
                            ),

                            const SizedBox(height: 20),

                            // Google Auth
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppColors.border),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.login, color: Colors.white70, size: 20),
                              label: Text(
                                'Sign In with Google',
                                style: AppTheme.getBodyStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: _loading ? null : _onGoogleSignIn,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Navigation to Register & Guest
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => context.go('/register'),
                          child: Text(
                            "New account? Register",
                            style: AppTheme.getBodyStyle(
                              fontSize: 13,
                              color: AppColors.accentPurpleGlow,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _onGuestSignIn,
                          child: Text(
                            "Continue as Guest",
                            style: AppTheme.getBodyStyle(
                              fontSize: 13,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ],
                    ),
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

