// ============================================================
// lib/shared/providers/app_providers.dart
// Riverpod global state providers for OPEN CAST
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';

// ── Theme Provider ──────────────────────────────────────────
final themeProvider = StateProvider<String>((ref) => 'darkPro');

// ── User Provider (Auth State) ──────────────────────────────
class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  void login(UserModel user) {
    state = user;
  }

  void logout() {
    state = null;
  }

  void updateBio(String bio) {
    if (state != null) {
      state = state!.copyWith(bio: bio);
    }
  }

  void updateUsername(String name) {
    if (state != null) {
      state = state!.copyWith(username: name);
    }
  }

  void connectPlatform(String platform) {
    if (state != null && !state!.platformConnections.contains(platform)) {
      state = state!.copyWith(
        platformConnections: [...state!.platformConnections, platform],
      );
    }
  }

  void disconnectPlatform(String platform) {
    if (state != null) {
      state = state!.copyWith(
        platformConnections: state!.platformConnections.where((p) => p != platform).toList(),
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

// ── Stream Session Provider (Broadcasting State) ─────────────
class StreamSessionNotifier extends StateNotifier<StreamSession> {
  StreamSessionNotifier()
      : super(StreamSession(
          id: '',
          title: '',
          category: 'Gaming',
          startTime: DateTime.now(),
          status: StreamStatus.idle,
        ));

  void startSession({required String title, required String category, List<String> platforms = const []}) {
    state = StreamSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      startTime: DateTime.now(),
      status: StreamStatus.live,
      bitrate: 4500.0,
      fps: 60.0,
      health: StreamHealth.excellent,
      activePlatforms: platforms,
    );
  }

  void updateBitrate(double bitrate) {
    state = StreamSession(
      id: state.id,
      title: state.title,
      category: state.category,
      startTime: state.startTime,
      endTime: state.endTime,
      status: state.status,
      viewerCount: state.viewerCount,
      peakViewers: state.peakViewers,
      chatMessages: state.chatMessages,
      bitrate: bitrate,
      fps: state.fps,
      health: bitrate < 1500 ? StreamHealth.critical : (bitrate < 3000 ? StreamHealth.warning : StreamHealth.excellent),
      activePlatforms: state.activePlatforms,
    );
  }

  void endSession() {
    state = StreamSession(
      id: state.id,
      title: state.title,
      category: state.category,
      startTime: state.startTime,
      endTime: DateTime.now(),
      status: StreamStatus.ended,
      viewerCount: state.viewerCount,
      peakViewers: state.peakViewers,
      chatMessages: state.chatMessages,
      bitrate: 0.0,
      fps: 0.0,
      health: StreamHealth.excellent,
      activePlatforms: state.activePlatforms,
    );
  }
}

final streamSessionProvider = StateNotifierProvider<StreamSessionNotifier, StreamSession>((ref) {
  return StreamSessionNotifier();
});

// ── Scenes Provider (List of scenes and active status) ───────
class ScenesNotifier extends StateNotifier<List<SceneModel>> {
  ScenesNotifier() : super(SceneModel.mockList);

  void selectScene(String id) {
    state = state.map((scene) {
      return scene.copyWith(isActive: scene.id == id);
    }).toList();
  }

  void toggleSourceVisibility(String sceneId, String sourceId) {
    state = state.map((scene) {
      if (scene.id == sceneId) {
        final updatedSources = scene.sources.map((source) {
          if (source.id == sourceId) {
            return source.copyWith(isVisible: !source.isVisible);
          }
          return source;
        }).toList();
        return scene.copyWith(sources: updatedSources);
      }
      return scene;
    }).toList();
  }
}

final scenesProvider = StateNotifierProvider<ScenesNotifier, List<SceneModel>>((ref) {
  return ScenesNotifier();
});

// ── Chat Messages Provider (Live messages) ────────────────────
class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super(ChatMessage.mockList);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void clearChat() {
    state = [];
  }
}

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier();
});

// ── Audio Mixer volume controls & toggles ─────────────────────
final micMutedProvider = StateProvider<bool>((ref) => false);
final cameraMutedProvider = StateProvider<bool>((ref) => false);
final micVolumeProvider = StateProvider<double>((ref) => 0.8);
final musicVolumeProvider = StateProvider<double>((ref) => 0.4);

// ── Settings Provider ─────────────────────────────────────────
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());

  void updateSettings(AppSettings settings) {
    state = settings;
  }

  void updateTheme(String theme) {
    state = state.copyWith(themeType: theme);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

// ── Analytics Provider (Read-Only) ─────────────────────────────
final analyticsProvider = Provider<AnalyticsData>((ref) {
  return AnalyticsData.mock;
});

// ── Navigation Index Provider ─────────────────────────────────
final navIndexProvider = StateProvider<int>((ref) => 0);
