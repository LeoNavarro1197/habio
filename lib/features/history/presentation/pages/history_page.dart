import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_components.dart';
import '../../../../core/widgets/banner_ad_widget.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/providers/category_providers.dart';
import '../../../habits/domain/entities/habit_entity.dart';
import '../../../habits/presentation/providers/habit_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../../../timer/domain/entities/timer_log_entity.dart';
import '../../../timer/presentation/providers/timer_log_providers.dart';
import '../providers/habit_log_providers.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(lastMonthLogsProvider);
    final timerLogsAsync = ref.watch(lastMonthTimerLogsProvider);
    final habitsAsync = ref.watch(allHabitsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final settings = ref.watch(settingsControllerProvider);
    final showAds = settings.adsRemoved == false;

    return categoriesAsync.when(
      data: (categories) {
        final categoryById = {
          for (final cat in categories) cat.id: cat,
        };
        return habitsAsync.when(
          data: (allHabits) {
            return timerLogsAsync.when(
              data: (timerLogs) => logsAsync.when(
                data: (logs) => _HistoryContent(
                  allHabits: allHabits,
                  logs: logs,
                  timerLogs: timerLogs,
                  categoryById: categoryById,
                  showAds: showAds,
                ),
                error: (error, _) => _StateCard(
                  title: 'No pudimos cargar el historial',
                  message: '$error',
                ),
                loading: () => const _LoadingState(),
              ),
              error: (error, _) => _StateCard(
                title: 'No pudimos cargar el historial del timer',
                message: '$error',
              ),
              loading: () => const _LoadingState(),
            );
          },
          error: (error, _) => _StateCard(
            title: 'No pudimos cargar los hábitos',
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
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({
    required this.allHabits,
    required this.logs,
    required this.timerLogs,
    required this.categoryById,
    required this.showAds,
  });

  final List<HabitEntity> allHabits;
  final List<HabitLogEntity> logs;
  final List<TimerLogEntity> timerLogs;
  final Map<String, CategoryEntity> categoryById;
  final bool showAds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habitById = {for (final h in allHabits) h.id: h};

    final today = HabioDateUtils.startOfDay(DateTime.now());
    final rangeEnd = today;
    final rangeStart = today.subtract(const Duration(days: 29));
    final earliestActivity = <DateTime>[
      ...allHabits.map((h) => HabioDateUtils.startOfDay(h.createdAt)),
      ...logs.map((l) => HabioDateUtils.startOfDay(l.date)),
      ...timerLogs.map((l) => HabioDateUtils.startOfDay(l.completedAt)),
    ].fold<DateTime>(rangeEnd, (a, b) => b.isBefore(a) ? b : a);
    final start = earliestActivity.isBefore(rangeStart) ? rangeStart : earliestActivity;
    final daysToShow = rangeEnd.difference(start).inDays + 1;
    final recentDates = List.generate(daysToShow, (i) => rangeEnd.subtract(Duration(days: i)));

    final logsByDate = <String, List<HabitLogEntity>>{};
    for (final log in logs) {
      final key = HabioDateUtils.startOfDay(log.date).toIso8601String();
      logsByDate.putIfAbsent(key, () => []);
      logsByDate[key]!.add(log);
    }

    final timerLogsByDate = <String, List<TimerLogEntity>>{};
    for (final log in timerLogs) {
      final key = HabioDateUtils.startOfDay(log.completedAt).toIso8601String();
      timerLogsByDate.putIfAbsent(key, () => []);
      timerLogsByDate[key]!.add(log);
    }

    return Column(
      children: [
        if (showAds) const Center(child: BannerAdWidget()),
        Expanded(
          child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      children: [
        Text('Historial', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 4),
        const Text(
          'Últimos 30 días',
          style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
        ),
        if (recentDates.isEmpty) ...[
          const SizedBox(height: 24),
          const EmptyStateCard(
            icon: Icons.query_stats_rounded,
            title: 'Aún no hay historial',
            subtitle: 'Completa hábitos o usa el temporizador para ver tu historial.',
          ),
        ] else ...[
          const SizedBox(height: 24),
          StaggeredFadeSlideIn(
            children: recentDates.map((date) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DaySummaryCard(
                date: date,
                logs: logsByDate[date.toIso8601String()] ?? [],
                timerLogs: timerLogsByDate[date.toIso8601String()] ?? [],
                habitById: habitById,
                categoryById: categoryById,
                allHabits: allHabits,
              ),
            )).toList(),
          ),
          ],
        ],
      ),
    ),
  ],
);
  }
}

class _DaySummaryCard extends StatelessWidget {
  const _DaySummaryCard({
    required this.date,
    required this.logs,
    required this.timerLogs,
    required this.habitById,
    required this.categoryById,
    required this.allHabits,
  });

  final DateTime date;
  final List<HabitLogEntity> logs;
  final List<TimerLogEntity> timerLogs;
  final Map<String, HabitEntity> habitById;
  final Map<String, CategoryEntity> categoryById;
  final List<HabitEntity> allHabits;

  @override
  Widget build(BuildContext context) {
    final completedLogs = logs.where((l) => l.isCompleted).toList();
    final completedHabitIds = completedLogs.map((l) => l.habitId).toSet();
    final activeHabits = allHabits.where((h) {
      if (!h.isActive) return false;
      if (!h.isScheduledFor(date)) return false;
      if (HabioDateUtils.startOfDay(h.createdAt).isAfter(date)) return false;
      if (h.deletedAt != null &&
          !HabioDateUtils.startOfDay(h.deletedAt!).isAfter(date)) {
        return false;
      }
      return true;
    }).toList();
    final allRelevantIds = <String>{
      ...activeHabits.map((h) => h.id),
      ...completedHabitIds,
    };
    final totalCount = allRelevantIds.length;
    final completedCount = completedHabitIds.length;
    final uncompletedHabits = activeHabits
        .where((h) => !completedHabitIds.contains(h.id))
        .toList();
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;
    final percent = (progress * 100).round();

    const weekdays = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves',
      'Viernes', 'Sábado', 'Domingo',
    ];
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];

    final dayName = weekdays[date.weekday - 1];
    final monthName = months[date.month - 1];
    final isToday = HabioDateUtils.isSameDay(date, DateTime.now());

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isToday ? 'Hoy' : dayName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day} de $monthName',
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              ProgressRing(
                progress: progress,
                size: 56,
                strokeWidth: 5,
                glowIntensity: 0.3,
                gradientColors: progress == 1 && totalCount > 0
                    ? [AppColors.success, AppColors.success]
                    : [AppColors.primary, AppColors.secondary],
                child: Center(
                  child: AnimatedCounter(
                    value: percent,
                    duration: const Duration(milliseconds: 400),
                    builder: (v) => Text(
                      '$v%',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              AnimatedCounter(
                value: completedCount,
                duration: const Duration(milliseconds: 400),
                builder: (v) => _chip(
                  '$v completados',
                  AppColors.success.withValues(alpha: 0.12),
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 6),
              AnimatedCounter(
                value: totalCount - completedCount,
                duration: const Duration(milliseconds: 400),
                builder: (v) => _chip(
                  '$v pendientes',
                  AppColors.textTertiary.withValues(alpha: 0.12),
                  AppColors.textTertiary,
                ),
              ),
            ],
          ),
          if (completedLogs.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 14),
            ...completedLogs.map((log) {
              final habit = habitById[log.habitId];
              if (habit == null) {
                final name = log.habitName ?? 'Hábito eliminado';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.textTertiary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          log.habitName != null
                              ? Icons.check_circle_outline_rounded
                              : Icons.help_outline_rounded,
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                      if (log.completedAt != null)
                        Text(
                          _formatTime(log.completedAt!),
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                );
              }
              final category = categoryById[habit.categoryId];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.categoryColor(category?.id ?? '').withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        IconData(
                          category?.iconCodePoint ??
                              Icons.check_circle.codePoint,
                          fontFamily: 'MaterialIcons',
                        ),
                        size: 16,
                        color: AppColors.categoryColor(category?.id ?? ''),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        habit.name,
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    if (log.completedAt != null)
                      Text(
                        _formatTime(log.completedAt!),
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
          if (uncompletedHabits.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 14),
            Text(
              'Pendientes',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            ...uncompletedHabits.map((habit) {
              final category = categoryById[habit.categoryId];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.categoryColor(category?.id ?? '')
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        IconData(
                          category?.iconCodePoint ??
                              Icons.check_circle.codePoint,
                          fontFamily: 'MaterialIcons',
                        ),
                        size: 16,
                        color: AppColors.categoryColor(category?.id ?? '')
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        habit.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Pendiente',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          if (timerLogs.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(height: 1, color: AppColors.divider),
            const SizedBox(height: 14),
            Text(
              'Sesiones de temporizador',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            ...timerLogs.map((log) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.timer_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      log.activityName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '${log.durationMinutes} min',
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )),
          ],
          if (totalCount == 0 && timerLogs.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Sin hábitos programados para este día',
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
          ShimmerLoading(height: 120),
          SizedBox(height: 12),
          ShimmerLoading(height: 120),
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
