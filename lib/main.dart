// ============================================================
// lib/main.dart
// Open Cast entry point with ProviderScope and system lock
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode for consistent UI
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Safe Firebase Initialization
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('⚠️ Firebase options not configured yet. Starting in offline demo mode. Error: $e');
  }

  runApp(
    // ── RIVERPOD ROOT PROVIDERSCOPE ──────────────────────────────
    const ProviderScope(
      child: OpenCastApp(),
    ),
  );
}
