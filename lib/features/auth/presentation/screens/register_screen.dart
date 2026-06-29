// ============================================================
// lib/features/auth/presentation/screens/register_screen.dart
// Cyberpunk Account Registration Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glow_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _termsAccepted = false;
  bool _loading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _userCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _onCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      setState(() => _errorMsg = 'You must accept the Terms and Conditions');
      return;
    }

    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: _userCtrl.text,
      email: _emailCtrl.text,
      avatarUrl: 'https://i.pravatar.cc/150?img=60',
      bio: 'New streamer on Open Cast!',
    );

    ref.read(userProvider.notifier).login(newUser);
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
          // Background Glow
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.currentViolet.withValues(alpha: 0.12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.currentViolet.withValues(alpha: 0.12),
                    blurRadius: 90,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    Text(
                      'CREATE ACCOUNT',
                      style: AppTheme.getHeaderStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Join the streaming revolution',
                      style: AppTheme.getBodyStyle(
                        fontSize: 13,
                        color: Colors.white38,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Registration Form Card
                    GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Username
                            TextFormField(
                              controller: _userCtrl,
                              style: AppTheme.getBodyStyle(),
                              decoration: _inputDecoration('Username', Icons.person_outline_rounded),
                              validator: (val) => val == null || val.isEmpty ? 'Username is required' : null,
                            ),
                            const SizedBox(height: 14),

                            // Email
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              style: AppTheme.getBodyStyle(),
                              decoration: _inputDecoration('Email address', Icons.email_outlined),
                              validator: (val) => val == null || val.isEmpty ? 'Email is required' : null,
                            ),
                            const SizedBox(height: 14),

                            // Password
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: true,
                              style: AppTheme.getBodyStyle(),
                              decoration: _inputDecoration('Password', Icons.lock_outline_rounded),
                              validator: (val) => val == null || val.length < 6 ? 'Min 6 characters required' : null,
                            ),
                            const SizedBox(height: 14),

                            // Confirm Password
                            TextFormField(
                              controller: _confirmPassCtrl,
                              obscureText: true,
                              style: AppTheme.getBodyStyle(),
                              decoration: _inputDecoration('Confirm Password', Icons.lock_clock_outlined),
                              validator: (val) => val != _passCtrl.text ? 'Passwords do not match' : null,
                            ),
                            
                            const SizedBox(height: 16),

                            // Terms & Conditions Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: _termsAccepted,
                                  onChanged: (val) {
                                    setState(() => _termsAccepted = val ?? false);
                                  },
                                  activeColor: AppColors.currentViolet,
                                  side: const BorderSide(color: Colors.white38),
                                ),
                                Expanded(
                                  child: Text(
                                    'I agree to the Terms & Conditions and Privacy Policy.',
                                    style: AppTheme.getBodyStyle(fontSize: 12, color: Colors.white60),
                                  ),
                                ),
                              ],
                            ),

                            if (_errorMsg != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _errorMsg!,
                                style: const TextStyle(color: AppColors.liveRed, fontSize: 13),
                              ),
                            ],

                            const SizedBox(height: 20),

                            // Submit Button
                            GlowButton(
                              text: 'CREATE ACCOUNT',
                              loading: _loading,
                              onTap: _onCreateAccount,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Back to login button
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        "Already have an account? Sign In",
                        style: AppTheme.getBodyStyle(
                          fontSize: 13,
                          color: AppColors.accentPurpleGlow,
                        ),
                      ),
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

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      prefixIcon: Icon(icon, color: Colors.white30, size: 20),
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
    );
  }
}

