import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/storage/hive_boxes.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../history/domain/entities/habit_log_entity.dart';
import '../../../history/domain/repositories/habit_log_repository.dart';
import '../../../history/presentation/providers/habit_log_providers.dart';
import '../../data/models/habit_model.dart';
import '../../data/repositories/hive_habit_repository.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HiveHabitRepository(Hive.box<HabitModel>(HiveBoxes.habits));
});

DateTime get _todayDate => HabioDateUtils.startOfDay(DateTime.now());

final allHabitsProvider = StreamProvider<List<HabitEntity>>((ref) {
  return ref.watch(habitRepositoryProvider).watchAll();
});

final todayHabitsProvider = StreamProvider<List<HabitEntity>>((ref) {
  return ref.watch(habitRepositoryProvider).watchHabitsForDate(_todayDate).map(
    (habits) => habits.where((h) => h.deletedAt == null).toList(),
  );
});

final todayHabitLogsProvider = StreamProvider<List<HabitLogEntity>>((ref) {
  final today = _todayDate;
  return ref.watch(habitLogRepositoryProvider).watchLogsForRange(today, today);
});

final habitActionsProvider = Provider<HabitActions>((ref) {
  return HabitActions(
    habitRepository: ref.watch(habitRepositoryProvider),
    habitLogRepository: ref.watch(habitLogRepositoryProvider),
  );
});

class HabitActions {
  HabitActions({
    required HabitRepository habitRepository,
    required HabitLogRepository habitLogRepository,
    NotificationService? notificationService,
  })  : _habitRepository = habitRepository,
        _habitLogRepository = habitLogRepository,
        _notificationService = notificationService ?? NotificationServiceHolder.instance;

  final HabitRepository _habitRepository;
  final HabitLogRepository _habitLogRepository;
  final NotificationService _notificationService;

  Future<void> saveHabit({
    HabitEntity? existingHabit,
    required String name,
    required String categoryId,
    required List<int> selectedWeekdays,
    required bool isActive,
    int? reminderMinutes,
    int? reminderIntervalMinutes,
    int? durationMinutes,
    int timesPerDay = 1,
  }) async {
    final normalizedName = name.trim();
    final now = DateTime.now();
    final deactivatedAt = existingHabit != null && existingHabit.isActive && !isActive
        ? now
        : existingHabit?.deactivatedAt;
    final reactivated = existingHabit != null && !existingHabit.isActive && isActive;
    final habit = HabitEntity(
      id: existingHabit?.id ?? IdGenerator.next(),
      name: normalizedName,
      categoryId: categoryId,
      selectedWeekdays: List<int>.from(selectedWeekdays)..sort(),
      reminderMinutes: reminderMinutes,
      reminderIntervalMinutes: reminderIntervalMinutes,
      durationMinutes: durationMinutes,
      timesPerDay: timesPerDay < 1 ? 1 : timesPerDay,
      isActive: isActive,
      createdAt: existingHabit?.createdAt ?? now,
      deactivatedAt: reactivated ? null : deactivatedAt,
    );

    await _habitRepository.save(habit);

    if (existingHabit?.reminderMinutes != null) {
      _notificationService.cancelHabitReminder(existingHabit!.id);
    }
    if (habit.isActive && habit.reminderMinutes != null) {
      _notificationService.scheduleHabitReminder(
        habitId: habit.id,
        name: habit.name,
        reminderMinutes: habit.reminderMinutes!,
        reminderIntervalMinutes: habit.reminderIntervalMinutes,
        timesPerDay: habit.timesPerDay,
        selectedWeekdays: habit.selectedWeekdays,
      );
    }
  }

  Future<void> deleteHabit(String habitId) async {
    final habits = await _habitRepository.getAll();
    final habit = habits.firstWhere((h) => h.id == habitId);
    await _habitRepository.save(habit.copyWith(deletedAt: DateTime.now()));
    _notificationService.cancelHabitReminder(habitId);
  }

  Future<void> setHabitCompletion({
    required HabitEntity habit,
    required DateTime date,
    required bool isCompleted,
  }) async {
    final target = isCompleted ? habit.timesPerDay : 0;
    await setHabitCompletionCount(
      habit: habit,
      date: date,
      completedCount: target,
    );
  }

  Future<void> setHabitCompletionCount({
    required HabitEntity habit,
    required DateTime date,
    required int completedCount,
  }) async {
    final currentLog = await _habitLogRepository.findByHabitAndDate(habit.id, date);
    final normalizedDate = HabioDateUtils.startOfDay(date);
    final timesPerDay = habit.timesPerDay < 1 ? 1 : habit.timesPerDay;
    final count = completedCount.clamp(0, timesPerDay);

    if (count <= 0) {
      if (currentLog != null) {
        await _habitLogRepository.delete(currentLog.id);
      }
      return;
    }

    final isFullyCompleted = count >= timesPerDay;
    final log = HabitLogEntity(
      id: currentLog?.id ?? IdGenerator.next(),
      habitId: habit.id,
      date: normalizedDate,
      isCompleted: isFullyCompleted,
      completedAt:
          currentLog?.isCompleted == true || isFullyCompleted
              ? (currentLog?.completedAt ?? DateTime.now())
              : null,
      habitName: habit.name,
      durationMinutes: habit.durationMinutes,
      completedCount: count,
      timesPerDay: timesPerDay,
    );

    await _habitLogRepository.save(log);
  }
}
