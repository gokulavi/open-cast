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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          if (isDesktop) {
            // â”€â”€ DESKTOP LAYOUT (3 columns side-by-side) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
                    child: _buildStudioPreviewColumn(context, ref, session, scenes, messages),
                  ),
                  const SizedBox(width: 16),
                  
                  // Column 3: Live Chat & Alerts
                  Expanded(
                    flex: 2,
                    child: _buildChatAndAlertsColumn(context, ref),
                  ),
                ],
              ),
            );
          }

          // â”€â”€ MOBILE LAYOUT (Tabbed view) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: const Color(0xFF161616),
                title: Text(
                  'STREAM STUDIO',
                  style: AppTheme.getHeaderStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.stop_circle_rounded, color: AppColors.liveRed),
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
                    child: _buildStudioPreviewColumn(context, ref, session, scenes, messages),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildChatAndAlertsColumn(context, ref),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // â”€â”€ Column 1 helper: Scenes & Sources manager â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildScenesAndSourcesColumn(WidgetRef ref, List<SceneModel> scenes) {
    final activeScene = scenes.firstWhere((s) => s.isActive, orElse: () => scenes.first);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ACTIVE SCENES',
          style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
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
                          Icon(Icons.check_circle_rounded, color: AppColors.accentPurpleGlow, size: 18),
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
          style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
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
                    color: AppColors.textMuted,
                  ),
                  title: Text(
                    src.name,
                    style: AppTheme.getBodyStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (src.type == SourceType.camera)
                        IconButton(
                          icon: const Icon(Icons.qr_code_rounded, size: 16),
                          color: AppColors.currentViolet,
                          tooltip: 'Connect Mobile Camera (OpenCast Lens)',
                          onPressed: () => _showMobileLensDialog(context),
                        ),
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

  // â”€â”€ Column 2 helper: Studio Preview & monitor controls â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildStudioPreviewColumn(BuildContext context, WidgetRef ref, StreamSession session, List<SceneModel> scenes, List<ChatMessage> messages) {
    final activeScene = scenes.firstWhere((s) => s.isActive, orElse: () => scenes.first);

    final textController = TextEditingController();

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
        Text(
          'PROGRAM MONITOR',
          style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
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
                        child: Icon(
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
                      style: AppTheme.getHeaderStyle(fontSize: 10, color: AppColors.textMuted),
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
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STUDIO LIVE CHAT',
              style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: AppColors.warningAmber.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              icon: Icon(Icons.star_rounded, color: AppColors.warningAmber, size: 12),
              label: Text(
                'SIM SUB',
                style: AppTheme.getHeaderStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.warningAmber),
              ),
              onPressed: () {
                ref.read(chatMessagesProvider.notifier).addMessage(ChatMessage(
                      id: 'sim_sub_${DateTime.now().millisecondsSinceEpoch}',
                      username: 'Subscriber${DateTime.now().second}',
                      message: 'Just subscribed for Tier 1! ðŸŽ‰',
                      timestamp: DateTime.now(),
                      type: ChatMessageType.subscription,
                      usernameColor: '#FFB300',
                      badges: const ['subscriber'],
                    ));
              },
            ),
          ],
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
                              : AppColors.textPrimary.withValues(alpha: 0.04),
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
                                  style: AppTheme.getBodyStyle(fontSize: 9, color: AppColors.textFaded),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              msg.message,
                              style: AppTheme.getBodyStyle(fontSize: 12, color: AppColors.textPrimary.withValues(alpha: 0.8)),
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
                          hintStyle: AppTheme.getBodyStyle(fontSize: 13, color: AppColors.textFaded),
                          filled: true,
                          fillColor: AppColors.textPrimary.withValues(alpha: 0.04),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onSubmitted: (_) => submitChat(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send_rounded, color: AppColors.accentPurpleGlow, size: 18),
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

  // â”€â”€ Column 3 helper: Live Chat scrolling feed â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildChatAndAlertsColumn(BuildContext context, WidgetRef ref) {
    final discordConnected = ref.watch(discordConnectedProvider);
    final discordParticipants = ref.watch(discordVoiceParticipantsProvider);

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
                    style: AppTheme.getHeaderStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                      'ðŸ”Š Room: ðŸŽ§ Friends Voice',
                      style: AppTheme.getBodyStyle(fontSize: 10, color: AppColors.textMuted),
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
                            style: AppTheme.getBodyStyle(fontSize: 9, color: AppColors.textFaded),
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

        // Control mixers and volume bar row
        Text(
          'BROADCAST CONTROLS',
          style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
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
                
                // ── AUDIO MIXER ────────────────────────────────────────────
                Column(
                  children: [
                    _AudioSlider(
                      title: 'Broadcaster Mic',
                      icon: Icons.mic_rounded,
                      muteProvider: micMutedProvider,
                      volumeProvider: micVolumeProvider,
                    ),
                    const Divider(height: 16, color: Colors.white10),
                    _AudioSlider(
                      title: 'Background Music',
                      icon: Icons.music_note_rounded,
                      muteProvider: cameraMutedProvider,
                      volumeProvider: musicVolumeProvider,
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
}

// â”€â”€ Studio Action Control Circle â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
              color: active ? AppColors.currentViolet.withValues(alpha: 0.15) : AppColors.textPrimary.withValues(alpha: 0.05),
              border: Border.all(color: active ? AppColors.accentPurpleGlow : AppColors.border),
            ),
            child: Icon(icon, color: active ? AppColors.accentPurpleGlow : Colors.white24, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTheme.getBodyStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

// â”€â”€ OpenCast Lens Dialog Helper â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
void _showMobileLensDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: _OpenCastLensWidget(),
      );
    },
  );
}

// â”€â”€ OpenCast Lens Stateful Connector Interface â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _OpenCastLensWidget extends StatefulWidget {
  @override
  State<_OpenCastLensWidget> createState() => _OpenCastLensWidgetState();
}

class _OpenCastLensWidgetState extends State<_OpenCastLensWidget> {
  int _activeLens = 1;
  bool _motionOff = false;
  bool _lensInUse = true;
  String _bgMode = 'Original';
  int _selectedBgIndex = 0;

  final List<Color> _bgGradients = [
    Colors.deepPurple,
    Colors.teal,
    Colors.orange,
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 820,
      height: 520,
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // â”€â”€ Window Title Bar â”€â”€
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF16161C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.videocam_rounded, color: AppColors.currentViolet, size: 18),
                const SizedBox(width: 8),
                Text(
                  'OpenCast Lens',
                  style: AppTheme.getHeaderStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Spacer(),
                Icon(Icons.minimize_rounded, color: AppColors.textMuted, size: 14),
                const SizedBox(width: 12),
                Icon(Icons.check_box_outline_blank_rounded, color: AppColors.textMuted, size: 12),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close_rounded, color: AppColors.textMuted, size: 16),
                ),
              ],
            ),
          ),

          // â”€â”€ Main Content Body â”€â”€
          Expanded(
            child: Row(
              children: [
                // Workspace Panel (Left Side)
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFF0F0F12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Lens Tabs Row
                        Row(
                          children: [
                            _buildLensTab(1),
                            const Spacer(),
                            Icon(Icons.flip_rounded, color: AppColors.textFaded, size: 16),
                            const SizedBox(width: 12),
                            Icon(Icons.cached_rounded, color: AppColors.textFaded, size: 16),
                            const SizedBox(width: 12),
                            Icon(Icons.crop_free_rounded, color: AppColors.textFaded, size: 16),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Center QR Card
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Mock QR Code Drawing
                                Container(
                                  width: 130,
                                  height: 130,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: CustomPaint(
                                    painter: _MockQrPainter(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Please scan the QR code in the CONNECT menu of the OpenCast mobile app.',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.getBodyStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Your PC and mobile must use the same WiFi.',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.getBodyStyle(color: Colors.black54, fontSize: 10),
                                ),
                                const SizedBox(height: 16),
                                // Google Play & App Store buttons row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildStoreBadge(Icons.play_arrow_rounded, 'Google Play'),
                                    const SizedBox(width: 12),
                                    _buildStoreBadge(Icons.apple_rounded, 'App Store'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Bottom Actions row
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E1E24),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Edit Image',
                                style: AppTheme.getHeaderStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Checkbox(
                                  value: _motionOff,
                                  activeColor: AppColors.currentViolet,
                                  onChanged: (v) => setState(() => _motionOff = v!),
                                ),
                                Text(
                                  'Motion Off',
                                  style: AppTheme.getBodyStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.refresh_rounded, color: AppColors.textMuted, size: 16),
                            const SizedBox(width: 16),
                            Icon(Icons.flip_rounded, color: AppColors.textMuted, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Settings Panel (Right Side)
                Container(
                  width: 240,
                  decoration: const BoxDecoration(
                    color: Color(0xFF16161C),
                    border: Border(left: BorderSide(color: Colors.white10)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Connect mobile selector dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF202028),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.phone_android_rounded, color: AppColors.textMuted, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Connect OpenCast Mobile',
                                style: AppTheme.getBodyStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textFaded, size: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Virtual Background',
                        style: AppTheme.getHeaderStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 8),

                      // Original / Remove BG selector buttons
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _bgMode = 'Original'),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _bgMode == 'Original' ? AppColors.currentViolet.withValues(alpha: 0.15) : const Color(0xFF202028),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _bgMode == 'Original' ? AppColors.currentViolet : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Original',
                                    style: AppTheme.getBodyStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _bgMode = 'Remove'),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _bgMode == 'Remove' ? Colors.white10 : const Color(0xFF202028),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _bgMode == 'Remove' ? AppColors.currentViolet : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Remove BG',
                                    style: AppTheme.getBodyStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Tabs for backgrounds
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildBgTab('RECENT', false),
                          _buildBgTab('OPENCAST', true),
                          _buildBgTab('FREE', false),
                          _buildBgTab('MY', false),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Virtual background grids with play icons
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: _bgGradients.length,
                          itemBuilder: (context, idx) {
                            final selected = _selectedBgIndex == idx;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedBgIndex = idx),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  gradient: LinearGradient(
                                    colors: [
                                      _bgGradients[idx],
                                      _bgGradients[idx].withValues(alpha: 0.5),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: selected ? AppColors.currentViolet : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.play_circle_filled_rounded, color: AppColors.textMuted, size: 20),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Tool Toolbar (Rightmost thin edge)
                Container(
                  width: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF101014),
                    border: Border(left: BorderSide(color: Colors.white10)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildToolbarIcon(Icons.face_rounded),
                      _buildToolbarIcon(Icons.emoji_emotions_rounded),
                      _buildToolbarIcon(Icons.auto_awesome_rounded),
                      _buildToolbarIcon(Icons.filter_hdr_rounded),
                      _buildToolbarIcon(Icons.tune_rounded),
                      _buildToolbarIcon(Icons.crop_free_rounded),
                      _buildToolbarIcon(Icons.more_horiz_rounded),
                      const Spacer(),
                      _buildToolbarIcon(Icons.notifications_rounded),
                      _buildToolbarIcon(Icons.warning_amber_rounded),
                      _buildToolbarIcon(Icons.add_circle_rounded),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // â”€â”€ Bottom Status Bar â”€â”€
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF16161C),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.settings_rounded, color: AppColors.textFaded, size: 14),
                const SizedBox(width: 6),
                Text(
                  '1280 x 720',
                  style: AppTheme.getBodyStyle(fontSize: 10, color: AppColors.textMuted),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                ),
                const SizedBox(width: 4),
                Text(
                  'CPU: 2.92%',
                  style: AppTheme.getBodyStyle(fontSize: 10, color: AppColors.textMuted),
                ),
                const SizedBox(width: 12),
                Text(
                  'GPU: 0.00%',
                  style: AppTheme.getBodyStyle(fontSize: 10, color: AppColors.textMuted),
                ),
                const Spacer(),
                Text(
                  'OpenCast Lens 1 is in use',
                  style: AppTheme.getBodyStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _lensInUse ? AppColors.currentViolet : Colors.white38,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 20,
                  width: 32,
                  child: Switch(
                    value: _lensInUse,
                    activeColor: AppColors.currentViolet,
                    onChanged: (v) => setState(() => _lensInUse = v),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLensTab(int index) {
    final active = _activeLens == index;
    return GestureDetector(
      onTap: () => setState(() => _activeLens = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF282830) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'OpenCast Lens $index',
          style: AppTheme.getHeaderStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: active ? AppColors.currentViolet : Colors.white38,
          ),
        ),
      ),
    );
  }

  Widget _buildStoreBadge(IconData icon, String store) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            store,
            style: AppTheme.getBodyStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBgTab(String label, bool active) {
    return Text(
      label,
      style: AppTheme.getHeaderStyle(
        fontSize: 9,
        fontWeight: FontWeight.bold,
        color: active ? AppColors.currentViolet : Colors.white38,
      ),
    );
  }

  Widget _buildToolbarIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Icon(icon, color: AppColors.textFaded, size: 18),
    );
  }
}

// â”€â”€ Mock QR Code custom painter â”€â”€
class _MockQrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Draw standard QR three corner eye squares
    _drawEye(canvas, paint, 0, 0, 30);
    _drawEye(canvas, paint, size.width - 30, 0, 30);
    _drawEye(canvas, paint, 0, size.height - 30, 30);

    // Draw some random dots to look like a QR code
    final randPaint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(10, 40, 10, 10), randPaint);
    canvas.drawRect(Rect.fromLTWH(40, 10, 10, 10), randPaint);
    canvas.drawRect(Rect.fromLTWH(45, 45, 15, 10), randPaint);
    canvas.drawRect(Rect.fromLTWH(20, 60, 10, 20), randPaint);
    canvas.drawRect(Rect.fromLTWH(70, 70, 20, 10), randPaint);
    canvas.drawRect(Rect.fromLTWH(60, 40, 15, 15), randPaint);
    canvas.drawRect(Rect.fromLTWH(80, 20, 10, 30), randPaint);
    canvas.drawRect(Rect.fromLTWH(30, 85, 30, 10), randPaint);
  }

  void _drawEye(Canvas canvas, Paint paint, double x, double y, double s) {
    // Outer square
    canvas.drawRect(Rect.fromLTWH(x, y, s, s), paint);
    // Inner white hole
    canvas.drawRect(Rect.fromLTWH(x + 5, y + 5, s - 10, s - 10), Paint()..color = Colors.white);
    // Inner black dot
    canvas.drawRect(Rect.fromLTWH(x + 9, y + 9, s - 18, s - 18), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Audio Mixer Slider ────────────────────────────────────────────
class _AudioSlider extends ConsumerWidget {
  final String title;
  final IconData icon;
  final StateProvider<bool> muteProvider;
  final StateProvider<double> volumeProvider;

  const _AudioSlider({
    required this.title,
    required this.icon,
    required this.muteProvider,
    required this.volumeProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muted = ref.watch(muteProvider);
    final volume = ref.watch(volumeProvider);

    return Row(
      children: [
        IconButton(
          icon: Icon(
            muted ? Icons.volume_off_rounded : icon,
            color: muted ? AppColors.liveRed : AppColors.accentPurpleGlow,
            size: 22,
          ),
          onPressed: () => ref.read(muteProvider.notifier).state = !muted,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: AppTheme.getBodyStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  Text(
                    muted ? 'MUTED' : '${(volume * 100).toInt()}%',
                    style: AppTheme.getHeaderStyle(fontSize: 11, color: muted ? AppColors.liveRed : Colors.white60),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  activeTrackColor: muted ? AppColors.border : AppColors.currentViolet,
                  inactiveTrackColor: AppColors.border,
                  thumbColor: muted ? AppColors.border : AppColors.accentPurpleGlow,
                  overlayColor: AppColors.accentPurpleGlow.withValues(alpha: 0.1),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                ),
                child: Slider(
                  value: muted ? 0.0 : volume,
                  onChanged: muted
                      ? null
                      : (val) => ref.read(volumeProvider.notifier).state = val,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
