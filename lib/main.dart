// ============================================================
// lib/main.dart
// Open Cast entry point with ProviderScope and system lock
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'shared/providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for consistent UI
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Shared Preferences
  final prefs = await SharedPreferences.getInstance();

  // Safe Firebase Initialization
  try {
    if (!kIsWeb) {
      await Firebase.initializeApp();
    } else {
      debugPrint('ℹ️ Web environment detected. Starting in offline demo mode.');
    }
  } catch (e) {
    debugPrint('⚠️ Firebase options not configured yet. Starting in offline demo mode. Error: $e');
  }

  runApp(
    // ── RIVERPOD ROOT PROVIDERSCOPE ──────────────────────────────
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const OpenCastApp(),
    ),
  );
}
