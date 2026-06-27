// ============================================================
// lib/features/stream/presentation/screens/stream_studio_screen.dart
// Cyberpunk main live streaming studio dashboard
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/live_badge.dart';

class StreamStudioScreen extends ConsumerWidget {
  const StreamStudioScreen({super.key});

  void _onConfirmEndStream(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'END LIVE STREAM?',
          style: AppTheme.getHeaderStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.liveRed),
        ),
        content: Text(
          'Are you sure you want to stop broadcasting to all platforms?',
          style: AppTheme.getBodyStyle(fontSize: 14, color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text('CANCEL', style: AppTheme.getBodyStyle(fontWeight: FontWeight.bold, color: Colors.white54)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.liveRed),
            child: Text('STOP STREAM', style: AppTheme.getHeaderStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(streamSessionProvider.notifier).endSession();
              context.go('/home');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(streamSessionProvider);
    final scenes = ref.watch(scenesProvider);
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      backgroundColor: AppColors.matteBlack,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          if (isDesktop) {
            // ── DESKTOP LAYOUT (3 columns side-by-side) ─────────────────
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Column 1: Scenes & Sources
                  Expanded(
                    flex: 2,
                    child: _buildScenesAndSourcesColumn(ref, scenes),
                  ),
                  const SizedBox(width: 16),
                  
                  // Column 2: Video Monitor preview & stream controls
                  Expanded(
                    flex: 4,
                    child: _buildStudioPreviewColumn(context, ref, session, scenes),
                  ),
                  const SizedBox(width: 16),
                  
                  // Column 3: Live Chat & Alerts
                  Expanded(
                    flex: 2,
                    child: _buildChatAndAlertsColumn(ref, messages),
                  ),
                ],
              ),
            );
          }

          // ── MOBILE LAYOUT (Tabbed view) ────────────────────────────
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: AppColors.matteBlack,
              appBar: AppBar(
                backgroundColor: const Color(0xFF161616),
                title: Text(
                  'STREAM STUDIO',
                  style: AppTheme.getHeaderStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.stop_circle_rounded, color: AppColors.liveRed),
                    onPressed: () => _onConfirmEndStream(context, ref),
                  ),
                ],
                bottom: TabBar(
                  dividerColor: AppColors.border,
                  indicatorColor: AppColors.accentPurpleGlow,
                  labelStyle: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: AppTheme.getBodyStyle(fontSize: 12),
                  tabs: const [
                    Tab(text: 'SCENES', icon: Icon(Icons.layers_rounded, size: 20)),
                    Tab(text: 'PREVIEW', icon: Icon(Icons.videocam_rounded, size: 20)),
                    Tab(text: 'CHAT & ALERTS', icon: Icon(Icons.chat_bubble_rounded, size: 20)),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildScenesAndSourcesColumn(ref, scenes),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildStudioPreviewColumn(context, ref, session, scenes),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildChatAndAlertsColumn(ref, messages),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Column 1 helper: Scenes & Sources manager ─────────────────────
  Widget _buildScenesAndSourcesColumn(WidgetRef ref, List<SceneModel> scenes) {
    final activeScene = scenes.firstWhere((s) => s.isActive, orElse: () => scenes.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ACTIVE SCENES',
          style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 4,
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: scenes.length,
              itemBuilder: (context, i) {
                final scene = scenes[i];
                return GestureDetector(
                  onTap: () => ref.read(scenesProvider.notifier).selectScene(scene.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: scene.isActive ? AppColors.currentViolet.withValues(alpha: 0.15) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: scene.isActive ? AppColors.accentPurpleGlow : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(scene.thumbnail, width: 48, height: 32, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            scene.name,
                            style: AppTheme.getHeaderStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (scene.isActive)
                          const Icon(Icons.check_circle_rounded, color: AppColors.accentPurpleGlow, size: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'SCENE LAYER SOURCES',
          style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 6,
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: activeScene.sources.length,
              itemBuilder: (context, i) {
                final src = activeScene.sources[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: Icon(
                    src.type == SourceType.camera ? Icons.videocam_rounded : (src.type == SourceType.screen ? Icons.monitor_rounded : Icons.audiotrack_rounded),
                    color: Colors.white60,
                  ),
                  title: Text(
                    src.name,
                    style: AppTheme.getBodyStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(src.isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded, size: 16),
                        color: src.isVisible ? AppColors.accentPurpleGlow : Colors.white24,
                        onPressed: () => ref.read(scenesProvider.notifier).toggleSourceVisibility(activeScene.id, src.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Column 2 helper: Studio Preview & monitor controls ─────────────
  Widget _buildStudioPreviewColumn(BuildContext context, WidgetRef ref, StreamSession session, List<SceneModel> scenes) {
    final activeScene = scenes.firstWhere((s) => s.isActive, orElse: () => scenes.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'PROGRAM MONITOR',
          style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
        ),
        const SizedBox(height: 8),
        
        // 16:9 Monitor View Card
        AspectRatio(
          aspectRatio: 16 / 9,
          child: GlassCard(
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                // Mock Video preview animation
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(activeScene.thumbnail),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.black38,
                      child: Center(
                        child: const Icon(
                          Icons.podcasts_rounded,
                          color: AppColors.accentPurpleGlow,
                          size: 48,
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1.1, 1.1),
                              duration: 1.5.seconds,
                              curve: Curves.easeInOut,
                            ),
                      ),
                    ),
                  ),
                ),
                
                // Live stats overlays
                Positioned(
                  top: 12,
                  left: 12,
                  child: LiveBadge(viewerCount: session.viewerCount),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'REC 01:24:50',
                      style: AppTheme.getHeaderStyle(fontSize: 10, color: Colors.white70),
                    ),
                  ),
                ),
                
                // Bottom title overlay
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      session.title.isEmpty ? 'Program Offline' : session.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.getHeaderStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Control mixers and volume bar row
        Text(
          'BROADCAST CONTROLS',
          style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Quick toggles row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StudioControlBadge(
                      icon: ref.watch(micMutedProvider) ? Icons.mic_off_rounded : Icons.mic_rounded,
                      active: !ref.watch(micMutedProvider),
                      label: 'Mic',
                      onTap: () => ref.read(micMutedProvider.notifier).state = !ref.read(micMutedProvider),
                    ),
                    const SizedBox(width: 24),
                    _StudioControlBadge(
                      icon: ref.watch(cameraMutedProvider) ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                      active: !ref.watch(cameraMutedProvider),
                      label: 'Cam',
                      onTap: () => ref.read(cameraMutedProvider.notifier).state = !ref.read(cameraMutedProvider),
                    ),
                  ],
                ),
                
                // End Stream Trigger
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.liveRed,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.stop_rounded, color: Colors.white),
                  label: Text('STOP STREAM BROADCAST', style: AppTheme.getHeaderStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  onPressed: () => _onConfirmEndStream(context, ref),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Column 3 helper: Live Chat scrolling feed ──────────────────────
  Widget _buildChatAndAlertsColumn(WidgetRef ref, List<ChatMessage> messages) {
    final textController = TextEditingController();
    final discordConnected = ref.watch(discordConnectedProvider);
    final discordParticipants = ref.watch(discordVoiceParticipantsProvider);

    void submitChat() {
      if (textController.text.trim().isEmpty) return;
      ref.read(chatMessagesProvider.notifier).addMessage(ChatMessage(
            id: 'msg_new_${DateTime.now().millisecondsSinceEpoch}',
            username: 'Broadcaster',
            message: textController.text.trim(),
            timestamp: DateTime.now(),
            usernameColor: '#D4AF37',
          ));
      textController.clear();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Discord Integration Panel
        GlassCard(
          padding: const EdgeInsets.all(12),
          bgOpacity: 0.45,
          borderOpacity: 0.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.headset_mic_rounded, color: Color(0xFF5865F2), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'DISCORD VOICE CHAT',
                    style: AppTheme.getHeaderStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: discordConnected ? AppColors.onlineGreen : Colors.white24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (!discordConnected)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5865F2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => ref.read(discordConnectedProvider.notifier).state = true,
                  child: Text(
                    'CONNECT VOICE CHANNEL',
                    style: AppTheme.getHeaderStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '🔊 Room: 🎧 Friends Voice',
                      style: AppTheme.getBodyStyle(fontSize: 10, color: Colors.white70),
                    ),
                    InkWell(
                      onTap: () => ref.read(discordConnectedProvider.notifier).state = false,
                      child: Text(
                        'Disconnect',
                        style: AppTheme.getBodyStyle(fontSize: 9, color: AppColors.liveRed, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Divider(height: 8, color: Colors.white10),
                ...discordParticipants.map((friend) {
                  final String name = friend['name'];
                  final bool isTalking = friend['isTalking'];
                  final bool isMuted = friend['isMuted'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          isTalking
                              ? Icons.volume_up_rounded
                              : (isMuted ? Icons.mic_off_rounded : Icons.volume_mute_rounded),
                          size: 13,
                          color: isTalking ? AppColors.onlineGreen : Colors.white30,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '@$name',
                          style: AppTheme.getBodyStyle(
                            fontSize: 10,
                            color: isTalking ? Colors.white : Colors.white70,
                            fontWeight: isTalking ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const Spacer(),
                        if (isTalking)
                          Text(
                            'Speaking...',
                            style: AppTheme.getBodyStyle(fontSize: 9, color: AppColors.onlineGreen),
                          )
                        else if (isMuted)
                          Text(
                            'Muted',
                            style: AppTheme.getBodyStyle(fontSize: 9, color: Colors.white24),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),

        Text(
          'STUDIO LIVE CHAT',
          style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      final msg = messages[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: msg.type == ChatMessageType.donation
                              ? AppColors.warningAmber.withValues(alpha: 0.1)
                              : Colors.white.withValues(alpha: 0.02),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  msg.username,
                                  style: AppTheme.getBodyStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: msg.type == ChatMessageType.donation ? AppColors.warningAmber : AppColors.accentPurpleGlow,
                                  ),
                                ),
                                Text(
                                  '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                                  style: AppTheme.getBodyStyle(fontSize: 9, color: Colors.white24),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              msg.message,
                              style: AppTheme.getBodyStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                
                // TextInput row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        style: AppTheme.getBodyStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Type message...',
                          hintStyle: AppTheme.getBodyStyle(fontSize: 13, color: Colors.white30),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.04),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onSubmitted: (_) => submitChat(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.accentPurpleGlow, size: 18),
                      onPressed: submitChat,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Studio Action Control Circle ─────────────────────────────
class _StudioControlBadge extends StatelessWidget {
  final IconData icon;
  final bool active;
  final String label;
  final VoidCallback onTap;

  const _StudioControlBadge({
    required this.icon,
    required this.active,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? AppColors.currentViolet.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
              border: Border.all(color: active ? AppColors.accentPurpleGlow : AppColors.border),
            ),
            child: Icon(icon, color: active ? AppColors.accentPurpleGlow : Colors.white24, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTheme.getBodyStyle(fontSize: 11, color: Colors.white54)),
        ],
      ),
    );
  }
}
