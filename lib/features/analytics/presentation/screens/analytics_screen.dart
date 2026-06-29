// ============================================================
// lib/features/analytics/presentation/screens/analytics_screen.dart
// Creator performance statistics & charts using fl_chart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../theme/app_theme.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/widgets/glass_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(analyticsProvider);
    final user = ref.watch(userProvider);
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator(color: AppColors.currentViolet)),
      );
    }

    final isTwitchConnected = user.platformConnections.contains('Twitch');
    final isYouTubeConnected = user.platformConnections.contains('YouTube');
    final isTikTokConnected = user.platformConnections.contains('TikTok');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STREAM ANALYTICS',
                style: AppTheme.getHeaderStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.currentViolet),
              ),
              const SizedBox(height: 24),

              Text(
                'PLATFORM CONNECTIONS',
                style: AppTheme.getH2Style(fontSize: 12, color: AppColors.currentViolet),
              ),
              const SizedBox(height: 8),
              GlassCard(
                child: Column(
                  children: [
                    _buildPlatformRow(ref, 'Twitch', isTwitchConnected),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildPlatformRow(ref, 'YouTube', isYouTubeConnected),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildPlatformRow(ref, 'TikTok', isTikTokConnected),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: AppColors.accentPurpleGlow),
                          onPressed: () {
                            ref.read(userProvider.notifier).connectPlatform('NewPlatform');
                          },
                        ),
                        Text('Add Platform', style: TextStyle(color: AppColors.accentPurpleGlow)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),


              // â”€â”€ TOP METRICS ROW (Grid) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatTile('Avg Viewers', '${stats.averageViewers}', Icons.people_rounded),
                  _buildStatTile('Total Streams', '${stats.totalStreams}', Icons.podcasts_rounded),
                  _buildStatTile('Followers Count', '${stats.totalFollowers}', Icons.person_add_rounded),
                  _buildStatTile('Estimated Revenue', '\$${stats.totalRevenue.toInt()}', Icons.monetization_on_rounded),
                ],
              ),
              const SizedBox(height: 24),

              // â”€â”€ VIEWER DURATION HISTORY LINE GRAPH â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Text(
                'VIEWER GROWTH (LAST 30 DAYS)',
                style: AppTheme.getH2Style(fontSize: 12, color: AppColors.currentViolet),
              ),
              const SizedBox(height: 8),
              GlassCard(
                child: SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 250),
                            FlSpot(2, 270),
                            FlSpot(4, 300),
                            FlSpot(6, 350),
                            FlSpot(8, 410),
                            FlSpot(10, 480),
                            FlSpot(12, 520),
                            FlSpot(14, 600),
                            FlSpot(16, 650),
                            FlSpot(18, 750),
                            FlSpot(20, 890),
                            FlSpot(22, 980),
                            FlSpot(24, 1100),
                            FlSpot(26, 1300),
                            FlSpot(28, 1500),
                            FlSpot(30, 1850),
                          ],
                          isCurved: true,
                          color: AppColors.accentPurpleGlow,
                          barWidth: 4,
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.currentViolet.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),


              // â”€â”€ RECENT STREAMS LIST â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
              Text(
                'RECENT STREAM LOGS',
                style: AppTheme.getH2Style(fontSize: 12, color: AppColors.currentViolet),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stats.recentStreams.length,
                itemBuilder: (context, i) {
                  final stream = stats.recentStreams[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(Icons.videocam_rounded, color: AppColors.accentPurpleGlow),
                      title: Text(
                        stream['title'],
                        style: AppTheme.getBodyStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${stream['date']} â€¢ Duration: ${stream['duration']}',
                        style: AppTheme.getBodyStyle(fontSize: 11, color: AppColors.textFaded),
                      ),
                      trailing: Text(
                        '${stream['views']} Views',
                        style: AppTheme.getHeaderStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onlineGreen),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatTile(String title, String val, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTheme.getBodyStyle(fontSize: 10, color: AppColors.textFaded),
              ),
              Icon(icon, color: AppColors.currentViolet, size: 16),
            ],
          ),
          Text(
            val,
            style: AppTheme.getHeaderStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Widget _buildPlatformRow(WidgetRef ref, String name, bool connected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!connected) Icon(Icons.add, size: 20, color: AppColors.accentPurpleGlow),
              Text(
                name,
                style: AppTheme.getBodyStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              if (connected) {
                ref.read(userProvider.notifier).disconnectPlatform(name);
              } else {
                ref.read(userProvider.notifier).connectPlatform(name);
              }
            },
            child: Text(
              connected ? 'Disconnect' : 'Connect',
              style: TextStyle(
                color: connected ? AppColors.liveRed : AppColors.onlineGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

