// ============================================================
// lib/navigation/app_router.dart
// Central GoRouter navigation map for OPEN CAST
// ============================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/providers/app_providers.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/profile_screen.dart';
import '../features/auth/presentation/screens/permissions_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/analytics/presentation/screens/analytics_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/stream/presentation/screens/go_live_screen.dart';
import '../features/stream/presentation/screens/stream_studio_screen.dart';
import '../features/chat/presentation/screens/chat_overlay_screen.dart';
import '../shared/widgets/main_shell.dart';

// ── CUSTOM TRANSITIONS ───────────────────────────────────────

CustomTransitionPage<T> buildFadeTransitionPage<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

CustomTransitionPage<T> buildScaleTransitionPage<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        child: child,
      );
    },
  );
}

CustomTransitionPage<T> buildSlideUpTransitionPage<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

// ── ROUTER PROVIDER ──────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final user = ref.watch(userProvider);
  final permissionsRequested = ref.watch(permissionsRequestedProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/';
      final isPermissions = state.matchedLocation == '/permissions';

      if (isSplash) return null;

      // Auth Guard
      if (user == null) {
        return isLoggingIn ? null : '/login';
      }

      // If logged in but hasn't completed/seen the permissions screen, redirect to /permissions
      if (!permissionsRequested) {
        return isPermissions ? null : '/permissions';
      }

      // If logged in and completed permissions, redirect away from auth and permissions screens to home
      if (isLoggingIn || isPermissions) {
        return '/home';
      }

      return null;
    },
    routes: [
      // ── Splash Screen ──
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => buildFadeTransitionPage(
          context: context,
          state: state,
          child: const SplashScreen(),
        ),
      ),
      
      // ── Auth Screens ──
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => buildFadeTransitionPage(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => buildFadeTransitionPage(
          context: context,
          state: state,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/permissions',
        pageBuilder: (context, state) => buildFadeTransitionPage(
          context: context,
          state: state,
          child: const PermissionsScreen(),
        ),
      ),

      // ── Shell Navigation Shell ──
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => buildFadeTransitionPage(
              context: context,
              state: state,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/analytics',
            pageBuilder: (context, state) => buildFadeTransitionPage(
              context: context,
              state: state,
              child: const AnalyticsScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => buildFadeTransitionPage(
              context: context,
              state: state,
              child: const SettingsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => buildFadeTransitionPage(
              context: context,
              state: state,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),

      // ── Full Screen Overlays ──
      GoRoute(
        path: '/go-live',
        pageBuilder: (context, state) => buildScaleTransitionPage(
          context: context,
          state: state,
          child: const GoLiveScreen(),
        ),
      ),
      GoRoute(
        path: '/studio',
        pageBuilder: (context, state) => buildScaleTransitionPage(
          context: context,
          state: state,
          child: const StreamStudioScreen(),
        ),
      ),
      GoRoute(
        path: '/chat',
        pageBuilder: (context, state) => buildSlideUpTransitionPage(
          context: context,
          state: state,
          child: const ChatOverlayScreen(),
        ),
      ),
    ],
  );
});
