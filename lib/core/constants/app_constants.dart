// ============================================================
// lib/core/constants/app_constants.dart
// Central place for all app-wide constants
// ============================================================

class AppConstants {
  AppConstants._(); // private constructor — do not instantiate

  // ── App Info ────────────────────────────────────────────────
  static const String appName = 'OPEN CAST';
  static const String appVersion = '1.0.0';

  // ── Agora Configuration ────────────────────────────────────
  // 🔧 SETUP: Go to https://console.agora.io
  //   1. Create a project
  //   2. Copy your App ID below
  //   3. For production, generate tokens server-side
  // ── Backend Server ──────────────────────────────────────────
  // 🔧 Replace with your Railway URL after deployment
  static const String serverUrl =
      'open-cast-server-production-e142.up.railway.app';

  static const String agoraAppId = 'f699204bb6e54c7683caeba0455ca4bf';

  // Agora token — use empty string for testing mode (no auth).
  // For production ALWAYS generate tokens from your server.
  static const String agoraToken = '';

  // ── Firebase Collections ────────────────────────────────────
  static const String usersCollection = 'users';
  static const String streamsCollection = 'streams';
  static const String chatsSubcollection = 'chats';

  // ── Navigation Routes ───────────────────────────────────────
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeHome = '/home';
  static const String routeGoLive = '/go-live';
  static const String routeViewer = '/viewer';
  static const String routeProfile = '/profile';

  // ── Stream Categories ───────────────────────────────────────
  static const List<String> categories = [
    '🔥 Trending',
    '🎮 Gaming',
    '💬 Chat',
    '🎵 Music',
    '🎨 Art',
    '📱 Tech',
  ];

  // ── Dummy Thumbnails (Unsplash) ─────────────────────────────
  static const List<String> dummyThumbnails = [
    'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=400&q=80',
    'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=400&q=80',
    'https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?w=400&q=80',
    'https://images.unsplash.com/photo-1614680376573-df3480f0c6ff?w=400&q=80',
    'https://images.unsplash.com/photo-1598550476439-6847785fcea6?w=400&q=80',
    'https://images.unsplash.com/photo-1579373903781-fd5c0c30c4cd?w=400&q=80',
  ];

  // ── Dummy Avatars ───────────────────────────────────────────
  static const List<String> dummyAvatars = [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
    'https://i.pravatar.cc/150?img=4',
    'https://i.pravatar.cc/150?img=5',
  ];
}
