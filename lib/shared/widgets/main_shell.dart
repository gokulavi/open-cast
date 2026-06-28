// ============================================================
// lib/shared/widgets/main_shell.dart
// Responsive navigation shell - Bottom Nav (Mobile) vs Sidebar (Desktop)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../providers/app_providers.dart';

class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/analytics')) return 1;
    if (location.startsWith('/settings')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, WidgetRef ref) {
    ref.read(navIndexProvider.notifier).state = index;
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/analytics');
        break;
      case 2:
        context.go('/settings');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = _calculateSelectedIndex(context);
    final themeMode = ref.watch(themeProvider);
    final isBright = themeMode == 'bright';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                // ── Sidebar Left ──────────────────────────────────────────
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: isBright ? const Color(0xFF140A26) : AppColors.surface,
                    border: const Border(
                      right: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      // Logo Monogram
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.currentViolet.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.currentViolet, width: 1.5),
                            ),
                            child: const Icon(
                              Icons.podcasts_rounded,
                              color: AppColors.accentPurpleGlow,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'OPEN CAST',
                            style: AppTheme.getHeaderStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      // Sidebar navigation items
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _SidebarItem(
                                icon: Icons.dashboard_rounded,
                                label: 'Home Feed',
                                selected: selectedIndex == 0,
                                isBright: isBright,
                                onTap: () => _onItemTapped(0, context, ref),
                              ),
                              const SizedBox(height: 12),
                              _SidebarItem(
                                icon: Icons.analytics_rounded,
                                label: 'Analytics',
                                selected: selectedIndex == 1,
                                isBright: isBright,
                                onTap: () => _onItemTapped(1, context, ref),
                              ),
                              const SizedBox(height: 12),
                              _SidebarItem(
                                icon: Icons.settings_rounded,
                                label: 'Settings',
                                selected: selectedIndex == 2,
                                isBright: isBright,
                                onTap: () => _onItemTapped(2, context, ref),
                              ),
                              const SizedBox(height: 12),
                              _SidebarItem(
                                icon: Icons.person_rounded,
                                label: 'My Profile',
                                selected: selectedIndex == 3,
                                isBright: isBright,
                                onTap: () => _onItemTapped(3, context, ref),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Streaming Action Trigger
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.onlineGreen,
                            minimumSize: const Size.fromHeight(50),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => context.push('/go-live'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.stream_rounded, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'GO LIVE',
                                style: AppTheme.getHeaderStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Main Context ──────────────────────────────────────────
                Expanded(child: child),
              ],
            ),
          );
        }

        // Mobile & Tablet: Bottom Navbar Layout
        return Scaffold(
          body: child,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isBright ? const Color(0xFF140A26) : AppColors.surface,
              border: const Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) => _onItemTapped(index, context, ref),
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.accentPurpleGlow,
              unselectedItemColor: Colors.white38,
              elevation: 0,
              showSelectedLabels: isTablet,
              showUnselectedLabels: isTablet,
              selectedLabelStyle: AppTheme.getBodyStyle(fontSize: 12, fontWeight: FontWeight.bold),
              unselectedLabelStyle: AppTheme.getBodyStyle(fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_rounded),
                  label: 'Analytics',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_rounded),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
          floatingActionButton: constraints.maxWidth < 900
              ? FloatingActionButton(
                  onPressed: () => context.push('/go-live'),
                  backgroundColor: AppColors.onlineGreen,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.stream_rounded, color: Colors.white),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}

// ── Sidebar Menu Row Widget ──────────────────────────────────
class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool isBright;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isBright,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.currentViolet.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? (isBright ? AppColors.accentPurpleGlow : AppColors.currentViolet)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: selected ? [AppGlows.violetGlow] : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? AppColors.accentPurpleGlow : Colors.white60,
              size: 22,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: AppTheme.getHeaderStyle(
                fontSize: 15,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected ? AppColors.softWhite : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
