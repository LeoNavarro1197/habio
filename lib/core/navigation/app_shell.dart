import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/habits/presentation/pages/habit_form_sheet.dart';
import '../../features/settings/presentation/providers/settings_providers.dart';
import '../services/ads_service.dart';
import '../theme/app_colors.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with SingleTickerProviderStateMixin {
  InterstitialAdManager? _interstitialAdManager;
  late final AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _initInterstitial();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
  }

  void _initInterstitial() {
    final adsService = AdsServiceHolder.instance;
    _interstitialAdManager = InterstitialAdManager(
      adUnitId: adsService.interstitialAdUnitId,
    );
    _interstitialAdManager!.load();
  }

  void _onDestinationSelected(int index) {
    final currentIndex = widget.navigationShell.currentIndex;
    final isTodayToHistory = currentIndex == 0 && index == 1;
    final isHistoryToToday = currentIndex == 1 && index == 0;

    if (!isTodayToHistory && !isHistoryToToday) {
      widget.navigationShell.goBranch(
        index,
        initialLocation: index == currentIndex,
      );
      return;
    }

    final settings = ref.read(settingsControllerProvider);
    if (settings.adsRemoved) {
      widget.navigationShell.goBranch(
        index,
        initialLocation: index == currentIndex,
      );
      return;
    }

    _interstitialAdManager?.show(
      onFinished: () {
        if (!mounted) return;
        widget.navigationShell.goBranch(
          index,
          initialLocation: index == currentIndex,
        );
      },
    );
  }

  @override
  void dispose() {
    _interstitialAdManager?.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;

    return Scaffold(
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: KeyedSubtree(
            key: ValueKey(currentIndex),
            child: widget.navigationShell,
          ),
        ),
      ),
      floatingActionButton: currentIndex == 0
          ? ScaleTransition(
              scale: CurvedAnimation(
                parent: _fabController,
                curve: Curves.easeOutBack,
              ),
              child: FloatingActionButton.extended(
                onPressed: () => showHabitFormSheet(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Nuevo hábito'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          : null,
      bottomNavigationBar: _buildNavBar(currentIndex),
    );
  }

  Widget _buildNavBar(int currentIndex) {
    const tabs = [
      (icon: Icons.today_rounded, label: 'Hoy'),
      (icon: Icons.query_stats_rounded, label: 'Historial'),
      (icon: Icons.timer_outlined, label: 'Temporizador'),
      (icon: Icons.settings_rounded, label: 'Ajustes'),
    ];

    return Container(
      padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = currentIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => _onDestinationSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: anim,
                        child: child,
                      ),
                      child: Icon(
                        tabs[index].icon,
                        key: ValueKey('$selected-$index'),
                        size: 22,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textTertiary,
                      ),
                      child: Text(tabs[index].label),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
