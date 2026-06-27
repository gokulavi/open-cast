// ============================================================
// lib/app.dart
// Open Cast MaterialApp.router core definition
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation/app_router.dart';
import 'theme/app_theme.dart';
import 'shared/providers/app_providers.dart';

class OpenCastApp extends ConsumerWidget {
  const OpenCastApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeType = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'OPEN CAST',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: themeType == 'violetNeon' ? AppTheme.violetNeon : AppTheme.darkPro,
    );
  }
}
