import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_time_extensions.dart';
import '../../../../core/widgets/app_components.dart';
import '../../../../core/widgets/banner_ad_widget.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/providers/category_providers.dart';
import '../../../history/domain/entities/habit_log_entity.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../providers/habit_providers.dart';
import 'habit_form_sheet.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final theme = Theme.of(context);
    final habitsAsync = ref.watch(todayHabitsProvider);
    final logsAsync = ref.watch(todayHabitLogsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final settings = ref.watch(settingsControllerProvider);
    final showAds = settings.adsRemoved == false;

    return categoriesAsync.when(
      data: (categories) {
        final categoryById = {
          for (final category in categories) category.id: category,
        };

        return logsAsync.when(
          data: (logs) {
            return habitsAsync.when(
              data: (habits) {
                final completedByHabitId = {
                  for (final log in logs.where((item) => item.isCompleted))
                    log.habitId: log,
                };
                final activeHabits =
                    habits.where((h) => h.isActive).toList();
                final completedCount = activeHabits
                    .where((habit) => completedByHabitId.containsKey(habit.id))
                    .length;
                final progress = activeHabits.isEmpty
                    ? 0.0
                    : completedCount / activeHabits.length;
                final totalCount = activeHabits.length;

                final body = <Widget>[
                  Text(
                    now.greeting,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    now.spanishLongDate,
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ProgressSection(
                    progress: progress,
                    completedCount: completedCount,
                    totalCount: totalCount,
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Hábitos de hoy',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                ];

                return Column(
                  children: [
                    if (showAds) const Center(child: BannerAdWidget()),
                    Expanded(
                      child: ListView(
                        padding:
                            const EdgeInsets.fromLTRB(20, 24, 20, 120),
                        children: [
                          ...body,
                          if (habits.isEmpty)
                            const _EmptyHabitsCard()
                          else
                            ...habits.map((habit) => Padding(
                              key: ValueKey(habit.id),
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _HabitCard(
                                isActive: habit.isActive,
                                daysLabel: _formatDaysLabel(habit.selectedWeekdays),
                                habitName: habit.name,
                                reminderLabel:
                                    _formatReminderLabel(habit.reminderMinutes),
                                durationLabel:
                                    '${habit.durationMinutes ?? 25} min',
                                category: categoryById[habit.categoryId],
                                isCompleted:
                                    completedByHabitId.containsKey(habit.id),
                                onChanged: (value) async {
                                  await ref
                                      .read(habitActionsProvider)
                                      .setHabitCompletion(
                                        habit: habit,
                                        date: now,
                                        isCompleted: value ?? false,
                                      );
                                },
                                onEdit: () {
                                  showHabitFormSheet(
                                      context, initialHabit: habit);
                                },
                                onDelete: () async {
                                  final confirmed = await _confirmDelete(
                                      context, habit.name);
                                  if (!confirmed) return;
                                  await ref
                                      .read(habitActionsProvider)
                                      .deleteHabit(habit.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Se eliminó "${habit.name}".'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (error, _) => _StateCard(
                title: 'No pudimos cargar tus hábitos',
                message: '$error',
              ),
              loading: () => const _LoadingState(),
            );
          },
          error: (error, _) => _StateCard(
            title: 'No pudimos cargar el progreso',
            message: '$error',
          ),
          loading: () => const _LoadingState(),
        );
      },
      error: (error, _) => _StateCard(
        title: 'No pudimos cargar las categorías',
        message: '$error',
      ),
      loading: () => const _LoadingState(),
    );
  }

  static Future<bool> _confirmDelete(
      BuildContext context, String habitName) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar hábito'),
        content: Text('¿Quieres eliminar "$habitName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static String _formatReminderLabel(int? reminderMinutes) {
    if (reminderMinutes == null) return 'Sin hora';
    final hour = (reminderMinutes ~/ 60).toString().padLeft(2, '0');
    final minute = (reminderMinutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _formatDaysLabel(List<int> weekdays) {
    const names = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final sorted = List<int>.from(weekdays)..sort();
    if (sorted.length == 7) return 'Todos los días';
    return sorted.map((d) => names[d - 1]).join(', ');
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.progress,
    required this.completedCount,
    required this.totalCount,
  });

  final double progress;
  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();
    final pendingCount = (totalCount - completedCount).clamp(0, totalCount);

    return Column(
      children: [
        ProgressRing(
          progress: progress,
          size: 140,
          strokeWidth: 8,
          glowIntensity: 0.5,
          gradientColors: progress == 1
              ? [AppColors.success, AppColors.success]
              : [AppColors.primary, AppColors.secondary],
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedCounter(
                  value: percent,
                  duration: const Duration(milliseconds: 500),
                  builder: (v) => Text(
                    '$v%',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Progreso diario',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        totalCount == 0
            ? const Text(
                'Crea tu primer hábito para empezar.',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                ),
              )
            : AnimatedCounter(
                value: completedCount,
                duration: const Duration(milliseconds: 500),
                builder: (v) => Text(
                  '$v de $totalCount completados',
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 14,
                  ),
                ),
              ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedCounter(
              value: completedCount,
              duration: const Duration(milliseconds: 500),
              builder: (v) => _MetricBadge(
                icon: Icons.check_circle_rounded,
                label: '$v completados',
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 8),
            if (pendingCount > 0)
              AnimatedCounter(
                value: pendingCount,
                duration: const Duration(milliseconds: 500),
                builder: (v) => _MetricBadge(
                  icon: Icons.circle_outlined,
                  label: '$v pendientes',
                  color: AppColors.textTertiary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _MetricBadge extends StatelessWidget {
  const _MetricBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHabitsCard extends StatelessWidget {
  const _EmptyHabitsCard();

  @override
  Widget build(BuildContext context) {
    return EmptyStateCard(
      icon: Icons.check_circle_outline_rounded,
      title: 'Todavía no hay hábitos',
      subtitle: 'Usa el botón + para crear tu primer hábito.',
    );
  }
}

class _HabitCard extends StatefulWidget {
  const _HabitCard({
    required this.isActive,
    required this.daysLabel,
    required this.habitName,
    required this.reminderLabel,
    required this.durationLabel,
    required this.category,
    required this.isCompleted,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final bool isActive;
  final String daysLabel;
  final String habitName;
  final String reminderLabel;
  final String durationLabel;
  final CategoryEntity? category;
  final bool isCompleted;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<_HabitCard>
    with TickerProviderStateMixin {
  late final AnimationController _checkController;
  late final AnimationController _springController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
    _checkController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (_isCompleted) _checkController.value = 1;
  }

  @override
  void didUpdateWidget(_HabitCard old) {
    super.didUpdateWidget(old);
    if (widget.isCompleted != old.isCompleted) {
      _isCompleted = widget.isCompleted;
      if (_isCompleted) {
        _checkController.forward();
        _fireSpring();
      } else {
        _checkController.reverse();
        _fireSpring();
      }
    }
  }

  void _fireSpring() {
    _springController.forward(from: 0);
  }

  @override
  void dispose() {
    _checkController.dispose();
    _springController.dispose();
    super.dispose();
  }

  void _toggle() {
    final newValue = !_isCompleted;
    setState(() => _isCompleted = newValue);
    widget.onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPressable(
      onTap: _toggle,
      onLongPress: () => _showMenu(context),
      borderRadius: 10,
      child: AnimatedBuilder(
        animation: _springController,
        builder: (context, child) {
          final p = _springController.value;
          final oscillation = math.exp(-p * 7) *
              math.sin(p * math.pi * 4 + math.pi);
          final cardScale = 1.0 + oscillation * 0.025;
          return Transform.scale(
            scale: cardScale,
            child: child,
          );
        },
        child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
              ),
              child: Opacity(
                opacity: _isCompleted ? 0.3 : widget.isActive ? 1 : 0.55,
                child: Row(
              children: [
            GestureDetector(
              onTap: _toggle,
              child: AnimatedBuilder(
                animation: _checkController,
                builder: (context, _) {
                  final scale = _checkController.value * 0.3 + 0.7;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isCompleted
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : Colors.transparent,
                        border: Border.all(
                          color: _isCompleted
                              ? Colors.transparent
                              : AppColors.textTertiary,
                          width: 2,
                        ),
                      ),
                      child: _isCompleted
                          ? Icon(Icons.check_rounded,
                              size: 16, color: Colors.white.withValues(alpha: 0.5))
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 14),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.categoryColor(widget.category?.id ?? '').withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                boxShadow: null,
              ),
              child: Icon(
                IconData(
                  widget.category?.iconCodePoint ??
                      Icons.apps_rounded.codePoint,
                  fontFamily: 'MaterialIcons',
                ),
                color: AppColors.categoryColor(widget.category?.id ?? '')
                    .withValues(alpha: _isCompleted ? 0.5 : 1),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.habitName,
                                style: TextStyle(
                                  color: _isCompleted
                                      ? AppColors.textTertiary
                                      : AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  decoration: _isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.textTertiary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.isActive
                                    ? widget.daysLabel
                                    : 'Inactivo · ${widget.daysLabel}',
                                style: TextStyle(
                                  color: widget.isActive
                                      ? AppColors.textTertiary
                                      : AppColors.warning,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.category?.name ?? 'Sin categoría',
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _infoBadge(Icons.schedule_rounded, widget.reminderLabel),
                      const SizedBox(width: 6),
                      _infoBadge(
                          Icons.timer_outlined, widget.durationLabel),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showMenu(context),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ),
            ),
              ],
              ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: GradientBorderPainter(
                    radius: 10,
                    borderWidth: 1,
                    gradient: const LinearGradient(
                      colors: [AppColors.border, AppColors.border],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _infoBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: AppColors.textTertiary),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textTertiary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined,
                  color: AppColors.textPrimary),
              title: const Text('Editar'),
              onTap: () {
                Navigator.of(ctx).pop();
                widget.onEdit();
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: AppColors.error),
              title: const Text('Eliminar',
                  style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.of(ctx).pop();
                widget.onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          ShimmerLoading(height: 120),
          SizedBox(height: 12),
          ShimmerLoading(height: 80),
          SizedBox(height: 12),
          ShimmerLoading(height: 80),
        ],
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(message,
                style:
                    const TextStyle(color: AppColors.textTertiary, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
