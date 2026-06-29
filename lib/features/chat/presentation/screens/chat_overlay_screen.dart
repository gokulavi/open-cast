// ============================================================
// lib/features/chat/presentation/screens/chat_overlay_screen.dart
// Chat overlay customization panel
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/glow_button.dart';

class ChatOverlayScreen extends ConsumerStatefulWidget {
  const ChatOverlayScreen({super.key});

  @override
  ConsumerState<ChatOverlayScreen> createState() => _ChatOverlayScreenState();
}

class _ChatOverlayScreenState extends ConsumerState<ChatOverlayScreen> {
  String _position = 'Bottom Left';
  double _opacity = 0.8;
  double _fontSize = 14.0;
  String _bgStyle = 'Glass';
  double _maxMessages = 15;
  String _animStyle = 'Slide';

  bool _showFollowAlerts = true;
  bool _showDonations = true;
  final _blockCtrl = TextEditingController();

  @override
  void dispose() {
    _blockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.matteBlack,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                title: Text(
                  'CHAT OVERLAY CUSTOMIZER',
                  style: AppTheme.getHeaderStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                pinned: true,
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── OVERLAY PREVIEW WINDOW (Top 40% proportional height) ──
                      Text(
                        'OVERLAY PREVIEW',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(14),
                                image: const DecorationImage(
                                  image: NetworkImage('https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600&q=80'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Simulated overlay alignment
                                  _buildOverlayPositionWidget(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── POSITION CONFIGURATION ───────────────────────────
                      Text(
                        'SCREEN POSITION',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Top Left', 'Top Right', 'Bottom Left', 'Bottom Right'].map((pos) {
                          final selected = _position == pos;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _position = pos),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: selected ? AppColors.currentViolet.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: selected ? AppColors.accentPurpleGlow : AppColors.border),
                                ),
                                child: Text(
                                  pos,
                                  textAlign: TextAlign.center,
                                  style: AppTheme.getHeaderStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // ── OPACITY & TEXT CONFIG ─────────────────────────────
                      Text(
                        'VISUAL PREFERENCES',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
                      ),
                      const SizedBox(height: 8),
                      GlassCard(
                        child: Column(
                          children: [
                            // Opacity slider
                            _buildSliderRow(
                              'Background Opacity',
                              _opacity,
                              0.1,
                              1.0,
                              (v) => setState(() => _opacity = v),
                              '${(_opacity * 100).toInt()}%',
                            ),
                            const Divider(height: 24),
                            // Font scale
                            _buildSliderRow(
                              'Font Size',
                              _fontSize,
                              10.0,
                              24.0,
                              (v) => setState(() => _fontSize = v),
                              '${_fontSize.toInt()} px',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── BACKGROUND STYLE & ANIMATIONS ──────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropDownSelector(
                              'Background Theme',
                              _bgStyle,
                              ['None', 'Dark', 'Glass'],
                              (v) => setState(() => _bgStyle = v),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropDownSelector(
                              'Entrance Animation',
                              _animStyle,
                              ['Slide', 'Fade', 'Pop'],
                              (v) => setState(() => _animStyle = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── FILTERS & SAFETY ───────────────────────────────────
                      Text(
                        'CONTENT FILTERS',
                        style: AppTheme.getHeaderStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54),
                      ),
                      const SizedBox(height: 8),
                      GlassCard(
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text('Show Follower Alerts', style: AppTheme.getBodyStyle(fontSize: 14)),
                              value: _showFollowAlerts,
                              activeColor: AppColors.accentPurpleGlow,
                              onChanged: (v) => setState(() => _showFollowAlerts = v),
                            ),
                            SwitchListTile(
                              title: Text('Show Donation Messages', style: AppTheme.getBodyStyle(fontSize: 14)),
                              value: _showDonations,
                              activeColor: AppColors.accentPurpleGlow,
                              onChanged: (v) => setState(() => _showDonations = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120), // spacer
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Save customization buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: GlowButton(
                text: 'APPLY CUSTOM OVERLAYS',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat Overlay preferences updated!')),
                  );
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayPositionWidget() {
    Alignment alignment = Alignment.bottomLeft;
    if (_position == 'Top Left') alignment = Alignment.topLeft;
    if (_position == 'Top Right') alignment = Alignment.topRight;
    if (_position == 'Bottom Right') alignment = Alignment.bottomRight;

    // Sample chat messages for preview
    final sampleMessages = [
      {'user': 'Viewer1', 'text': 'Nice layout!', 'isHighlight': true},
      {'user': 'Subscriber', 'text': 'Low latency 🚀', 'isHighlight': false},
      {'user': 'ModBot', 'text': 'Welcome everyone!', 'isHighlight': true},
      {'user': 'Fan99', 'text': 'GG 🔥', 'isHighlight': false},
      {'user': 'NewUser', 'text': 'First time here!', 'isHighlight': false},
    ];
    final visibleCount = _maxMessages.toInt().clamp(1, sampleMessages.length);
    final visibleMessages = sampleMessages.take(visibleCount).toList();

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: 140,
        constraints: const BoxConstraints(maxHeight: 120),
        decoration: BoxDecoration(
          color: _bgStyle == 'None'
              ? Colors.transparent
              : (_bgStyle == 'Dark'
                  ? Colors.black.withValues(alpha: _opacity)
                  : Colors.white.withValues(alpha: _opacity * 0.15)),
          borderRadius: BorderRadius.circular(8),
          border: _bgStyle == 'Glass' ? Border.all(color: AppColors.border) : null,
        ),
        padding: const EdgeInsets.all(6),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: visibleMessages.map((msg) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '${msg['user']}: ${msg['text']}',
                  style: TextStyle(
                    fontSize: _fontSize - 5,
                    color: msg['isHighlight'] == true ? AppColors.accentPurpleGlow : Colors.white70,
                    fontWeight: msg['isHighlight'] == true ? FontWeight.bold : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderRow(String label, double val, double min, double max, Function(double) onChanged, String formatted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.getBodyStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            Text(formatted, style: AppTheme.getHeaderStyle(fontSize: 12, color: AppColors.accentPurpleGlow)),
          ],
        ),
        Slider(
          value: val,
          min: min,
          max: max,
          activeColor: AppColors.currentViolet,
          inactiveColor: AppColors.border,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropDownSelector(String label, String value, List<String> items, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTheme.getHeaderStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white54)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: AppColors.matteBlack,
                textTheme: Theme.of(context).textTheme.copyWith(
                  titleMedium: AppTheme.getBodyStyle(color: Colors.white),
                  bodyLarge: AppTheme.getBodyStyle(color: Colors.white),
                  bodyMedium: AppTheme.getBodyStyle(color: Colors.white),
                ),
              ),
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: AppColors.matteBlack,
                style: AppTheme.getBodyStyle(color: Colors.white),
                items: items.map((i) => DropdownMenuItem(
                  value: i,
                  child: Text(
                    i,
                    style: AppTheme.getBodyStyle(color: Colors.white),
                  ),
                )).toList(),
                onChanged: (val) {
                  if (val != null) onChanged(val);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
