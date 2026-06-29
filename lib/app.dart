// ============================================================
// lib/app.dart
// Open Cast MaterialApp.router core definition
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation/app_router.dart';
import 'theme/app_theme.dart';
import 'shared/providers/app_providers.dart';

import 'shared/widgets/live_theme_background.dart';

class OpenCastApp extends ConsumerWidget {
  const OpenCastApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeConfig = ref.watch(themeProvider);
    
    // Dynamically update the app's static color palette based on config
    AppTheme.updateColors(themeConfig);

    return MaterialApp.router(
      title: 'OPEN CAST',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.getThemeData(themeConfig),
      builder: (context, child) {
        return LiveThemeBackground(
          themeConfig: themeConfig,
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
