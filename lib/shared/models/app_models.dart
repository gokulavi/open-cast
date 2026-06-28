// ============================================================
// lib/shared/models/app_models.dart
// Consolidated target data models for OPEN CAST
// ============================================================

import 'dart:math';

// ── USER MODEL ──────────────────────────────────────────────
class UserModel {
  final String id;
  final String username;
  final String email;
  final String avatarUrl;
  final String bio;
  final int followers;
  final int following;
  final int totalViews;
  final bool isVerified;
  final List<String> platformConnections;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.bio,
    this.followers = 0,
    this.following = 0,
    this.totalViews = 0,
    this.isVerified = false,
    this.platformConnections = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      bio: json['bio'] ?? '',
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      platformConnections: List<String>.from(json['platformConnections'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'followers': followers,
      'following': following,
      'totalViews': totalViews,
      'isVerified': isVerified,
      'platformConnections': platformConnections,
    };
  }

  UserModel copyWith({
    String? username,
    String? avatarUrl,
    String? bio,
    int? followers,
    int? following,
    int? totalViews,
    bool? isVerified,
    List<String>? platformConnections,
  }) {
    return UserModel(
      id: id,
      email: email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      totalViews: totalViews ?? this.totalViews,
      isVerified: isVerified ?? this.isVerified,
      platformConnections: platformConnections ?? this.platformConnections,
    );
  }

  static UserModel get mock => const UserModel(
        id: 'user_123',
        username: 'StreamerPro',
        email: 'pro.streamer@opencast.app',
        avatarUrl: 'https://i.pravatar.cc/150?img=33',
        bio: 'Just a professional streamer doing Flutter things! 🔴 Live almost daily.',
        followers: 12450,
        following: 184,
        totalViews: 98200,
        isVerified: true,
        platformConnections: ['Twitch', 'YouTube'],
      );
}

// ── STREAM SESSION ───────────────────────────────────────────
enum StreamStatus { idle, connecting, live, ended, error }
enum StreamHealth { excellent, good, warning, poor, critical }

class StreamSession {
  final String id;
  final String title;
  final String category;
  final DateTime startTime;
  final DateTime? endTime;
  final StreamStatus status;
  final int viewerCount;
  final int peakViewers;
  final int chatMessages;
  final double bitrate; // kbps
  final double fps;
  final StreamHealth health;
  final List<String> activePlatforms;

  const StreamSession({
    required this.id,
    required this.title,
    required this.category,
    required this.startTime,
    this.endTime,
    this.status = StreamStatus.idle,
    this.viewerCount = 0,
    this.peakViewers = 0,
    this.chatMessages = 0,
    this.bitrate = 0.0,
    this.fps = 0.0,
    this.health = StreamHealth.excellent,
    this.activePlatforms = const [],
  });

  static StreamSession get mock => StreamSession(
        id: 'session_999',
        title: '🔥 Cyberpunk Live Streaming Sandbox | Chill & Code',
        category: 'Tech',
        startTime: DateTime.now().subtract(const Duration(hours: 1, minutes: 24)),
        status: StreamStatus.live,
        viewerCount: 1420,
        peakViewers: 1890,
        chatMessages: 382,
        bitrate: 4500.0,
        fps: 60.0,
        health: StreamHealth.excellent,
        activePlatforms: const ['Twitch', 'YouTube'],
      );
}

// ── SCENE SOURCE ─────────────────────────────────────────────
enum SourceType { camera, screen, image, audio, overlay, widget }

class SceneSource {
  final String id;
  final String name;
  final SourceType type;
  final bool isVisible;
  final bool isMuted;

  const SceneSource({
    required this.id,
    required this.name,
    required this.type,
    this.isVisible = true,
    this.isMuted = false,
  });

  SceneSource copyWith({
    bool? isVisible,
    bool? isMuted,
  }) {
    return SceneSource(
      id: id,
      name: name,
      type: type,
      isVisible: isVisible ?? this.isVisible,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}

// ── SCENE MODEL ──────────────────────────────────────────────
class SceneModel {
  final String id;
  final String name;
  final List<SceneSource> sources;
  final bool isActive;
  final String thumbnail;

  const SceneModel({
    required this.id,
    required this.name,
    required this.sources,
    this.isActive = false,
    required this.thumbnail,
  });

  SceneModel copyWith({
    bool? isActive,
    List<SceneSource>? sources,
  }) {
    return SceneModel(
      id: id,
      name: name,
      isActive: isActive ?? this.isActive,
      sources: sources ?? this.sources,
      thumbnail: thumbnail,
    );
  }

  static List<SceneModel> get mockList => [
        const SceneModel(
          id: 'scene_1',
          name: '🎮 Gameplay Main',
          isActive: true,
          thumbnail: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=200&q=80',
          sources: [
            SceneSource(id: 'src_cam', name: 'Facecam (Logitech)', type: SourceType.camera),
            SceneSource(id: 'src_screen', name: 'Primary Screen Capture', type: SourceType.screen),
            SceneSource(id: 'src_overlay', name: 'Twitch Overlay Overlay', type: SourceType.overlay),
            SceneSource(id: 'src_mic', name: 'Studio Microphone', type: SourceType.audio),
          ],
        ),
        const SceneModel(
          id: 'scene_2',
          name: '💬 Just Chatting',
          isActive: false,
          thumbnail: 'https://images.unsplash.com/photo-1614680376573-df3480f0c6ff?w=200&q=80',
          sources: [
            SceneSource(id: 'src_cam_full', name: 'Facecam Fullscreen', type: SourceType.camera),
            SceneSource(id: 'src_chat_widget', name: 'Chat Overlay Widget', type: SourceType.widget),
            SceneSource(id: 'src_music', name: 'Spotify Audio Capture', type: SourceType.audio, isMuted: true),
          ],
        ),
        const SceneModel(
          id: 'scene_3',
          name: '⏳ Be Right Back',
          isActive: false,
          thumbnail: 'https://images.unsplash.com/photo-1579373903781-fd5c0c30c4cd?w=200&q=80',
          sources: [
            SceneSource(id: 'src_brb_bg', name: 'BRB Loop Animation', type: SourceType.image),
            SceneSource(id: 'src_timer', name: 'Countdown Timer', type: SourceType.widget),
          ],
        ),
      ];
}

// ── CHAT MESSAGE ─────────────────────────────────────────────
enum ChatMessageType { normal, donation, follow, subscription, raid }

class ChatMessage {
  final String id;
  final String username;
  final String message;
  final DateTime timestamp;
  final ChatMessageType type;
  final String usernameColor;
  final List<String> badges;
  final double donationAmount;
  final String donationCurrency;

  const ChatMessage({
    required this.id,
    required this.username,
    required this.message,
    required this.timestamp,
    this.type = ChatMessageType.normal,
    this.usernameColor = '#7F3DFF',
    this.badges = const [],
    this.donationAmount = 0.0,
    this.donationCurrency = 'USD',
  });

  static List<ChatMessage> get mockList => [
        ChatMessage(
          id: 'msg_1',
          username: 'NeonRider',
          message: 'This layout looks absolutely amazing! 🚀',
          timestamp: DateTime.now().subtract(const Duration(seconds: 45)),
          usernameColor: '#A970FF',
          badges: ['subscriber', 'moderator'],
        ),
        ChatMessage(
          id: 'msg_2',
          username: 'cyber_guy',
          message: 'How is the latency so low? WebRTC is fire.',
          timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
          usernameColor: '#00B4FF',
          badges: ['vip'],
        ),
        ChatMessage(
          id: 'msg_3',
          username: 'GenerousGamer',
          message: 'Keep up the awesome streams!',
          timestamp: DateTime.now().subtract(const Duration(seconds: 15)),
          type: ChatMessageType.donation,
          donationAmount: 25.00,
          donationCurrency: 'USD',
          usernameColor: '#00E676',
          badges: ['donor'],
        ),
        ChatMessage(
          id: 'msg_4',
          username: 'LottieLover',
          message: 'Just subscribed for Tier 1! 🎉',
          timestamp: DateTime.now().subtract(const Duration(seconds: 5)),
          type: ChatMessageType.subscription,
          usernameColor: '#FFB300',
          badges: ['subscriber'],
        ),
      ];
}

// ── ANALYTICS DATA ───────────────────────────────────────────
class AnalyticsData {
  final List<double> viewerHistory;
  final int totalStreams;
  final double totalStreamTime; // in hours
  final int averageViewers;
  final int totalFollowers;
  final int newFollowersThisMonth;
  final double totalRevenue;
  final List<Map<String, dynamic>> recentStreams;

  const AnalyticsData({
    required this.viewerHistory,
    required this.totalStreams,
    required this.totalStreamTime,
    required this.averageViewers,
    required this.totalFollowers,
    required this.newFollowersThisMonth,
    required this.totalRevenue,
    required this.recentStreams,
  });

  static AnalyticsData get mock => const AnalyticsData(
        viewerHistory: [250, 480, 600, 890, 1100, 1420, 1850],
        totalStreams: 24,
        totalStreamTime: 78.5,
        averageViewers: 850,
        totalFollowers: 12450,
        newFollowersThisMonth: 1850,
        totalRevenue: 1450.75,
        recentStreams: [
          {'date': '2026-06-25', 'title': 'Synthwave Chill Coding', 'views': 2400, 'duration': '3h 15m'},
          {'date': '2026-06-23', 'title': 'Vite + React Dashboard Building', 'views': 1850, 'duration': '2h 45m'},
          {'date': '2026-06-20', 'title': 'Twitch API Live Integration', 'views': 3100, 'duration': '4h 05m'},
        ],
      );
}

// ── APP SETTINGS ─────────────────────────────────────────────
class AppSettings {
  final String themeType; // 'darkPro' or 'bright'
  final String videoQuality; // '360p' to '1080p'
  final int bitrate; // kbps
  final String encoder; // 'x264', 'NVENC', etc.
  final bool enableNoiseCancel;
  final bool enableAICaptions;
  final bool enableStreamAlerts;
  final bool enableChatOverlay;
  final String audioInputDevice;
  final String videoInputDevice;
  final bool recordLocally;
  final String recordingPath;

  const AppSettings({
    this.themeType = 'darkPro',
    this.videoQuality = '1080p (60fps)',
    this.bitrate = 4500,
    this.encoder = 'NVENC',
    this.enableNoiseCancel = true,
    this.enableAICaptions = false,
    this.enableStreamAlerts = true,
    this.enableChatOverlay = true,
    this.audioInputDevice = 'Default Studio Mic',
    this.videoInputDevice = 'Default Webcam',
    this.recordLocally = false,
    this.recordingPath = '/storage/opencast/records',
  });

  AppSettings copyWith({
    String? themeType,
    String? videoQuality,
    int? bitrate,
    String? encoder,
    bool? enableNoiseCancel,
    bool? enableAICaptions,
    bool? enableStreamAlerts,
    bool? enableChatOverlay,
    String? audioInputDevice,
    String? videoInputDevice,
    bool? recordLocally,
    String? recordingPath,
  }) {
    return AppSettings(
      themeType: themeType ?? this.themeType,
      videoQuality: videoQuality ?? this.videoQuality,
      bitrate: bitrate ?? this.bitrate,
      encoder: encoder ?? this.encoder,
      enableNoiseCancel: enableNoiseCancel ?? this.enableNoiseCancel,
      enableAICaptions: enableAICaptions ?? this.enableAICaptions,
      enableStreamAlerts: enableStreamAlerts ?? this.enableStreamAlerts,
      enableChatOverlay: enableChatOverlay ?? this.enableChatOverlay,
      audioInputDevice: audioInputDevice ?? this.audioInputDevice,
      videoInputDevice: videoInputDevice ?? this.videoInputDevice,
      recordLocally: recordLocally ?? this.recordLocally,
      recordingPath: recordingPath ?? this.recordingPath,
    );
  }
}
