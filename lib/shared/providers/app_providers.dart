// ============================================================
// lib/shared/providers/app_providers.dart
// Riverpod global state providers for OPEN CAST
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final Ref _ref;

  ChatMessagesNotifier(this._ref) : super(ChatMessage.mockList);

  void addMessage(ChatMessage message) {
    state = [...state, message];
    _processChatbot(message);
  }

  void clearChat() {
    state = [];
  }

  void _processChatbot(ChatMessage message) {
    final settings = _ref.read(settingsProvider);
    if (!settings.enableChatbot) return;

    // Safety: ignore bot messages to avoid loops
    if (message.badges.contains('bot') || message.username == settings.chatbotName) {
      return;
    }

    // Handle subscriber thank-you
    if (message.type == ChatMessageType.subscription) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          final replyText = settings.chatbotReplyTemplate.replaceAll('{username}', message.username);
          addMessage(ChatMessage(
            id: 'bot_sub_${DateTime.now().millisecondsSinceEpoch}',
            username: settings.chatbotName,
            message: replyText,
            timestamp: DateTime.now(),
            type: ChatMessageType.normal,
            usernameColor: '#00E5FF',
            badges: const ['bot'],
          ));
        }
      });
      return;
    }

    // Handle commands
    final text = message.message.trim();
    if (text.startsWith('!')) {
      final command = text.split(' ')[0].toLowerCase();
      String? reply;

      if (command == '!help') {
        reply = 'Chatbot commands: !uptime, !stats, !socials, !joke';
      } else if (command == '!uptime') {
        final session = _ref.read(streamSessionProvider);
        if (session.status != StreamStatus.live) {
          reply = 'Stream is currently offline.';
        } else {
          final diff = DateTime.now().difference(session.startTime);
          final hours = diff.inHours.toString().padLeft(2, '0');
          final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
          reply = 'Stream uptime: $hours:$minutes:$seconds';
        }
      } else if (command == '!stats') {
        final session = _ref.read(streamSessionProvider);
        if (session.status != StreamStatus.live) {
          reply = 'Stream is offline. No stats available.';
        } else {
          reply = 'Viewer Count: ${session.viewerCount} | Bitrate: ${session.bitrate.toInt()} kbps | Health: ${session.health.name.toUpperCase()}';
        }
      } else if (command == '!socials') {
        reply = 'Follow us on Twitter: @OpenCastApp | Discord: dsc.gg/opencast | YouTube: OpenCastLive';
      } else if (command == '!joke') {
        final jokes = [
          "Why do programmers wear glasses? Because they can't C#!",
          "There are 10 types of people in the world: those who understand binary, and those who don't.",
          "Why was the mobile phone wearing glasses? Because it lost its contacts.",
          "What is a streamer's favorite key? The Space bar, to give their viewers some space!",
          "How many programmers does it take to change a light bulb? None, that's a hardware problem."
        ];
        reply = jokes[DateTime.now().millisecond % jokes.length];
      }

      if (reply != null) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            addMessage(ChatMessage(
              id: 'bot_cmd_${DateTime.now().millisecondsSinceEpoch}',
              username: settings.chatbotName,
              message: reply!,
              timestamp: DateTime.now(),
              type: ChatMessageType.normal,
              usernameColor: '#00E5FF',
              badges: const ['bot'],
            ));
          }
        });
      }
    }
  }
}

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier(ref);
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

// ── Discord Voice Chat Integration Providers ─────────────────
final discordConnectedProvider = StateProvider<bool>((ref) => false);
final discordVoiceParticipantsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return [
    {'name': 'gokulavi', 'isTalking': true, 'isMuted': false},
    {'name': 'stream_bud', 'isTalking': false, 'isMuted': true},
    {'name': 'gamer_girl', 'isTalking': false, 'isMuted': false},
  ];
});

// ── Shared Preferences Provider ──────────────────────────────
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main.dart');
});

// ── Permissions Requested State Provider ─────────────────────
final permissionsRequestedProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool('has_requested_permissions') ?? false;
});

