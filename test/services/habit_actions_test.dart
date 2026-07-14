import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:habio/core/services/notification_service.dart';
import 'package:habio/features/habits/domain/entities/habit_entity.dart';
import 'package:habio/features/habits/domain/repositories/habit_repository.dart';
import 'package:habio/features/habits/presentation/providers/habit_providers.dart';
import 'package:habio/features/history/domain/entities/habit_log_entity.dart';
import 'package:habio/features/history/domain/repositories/habit_log_repository.dart';

class _MockNotificationService extends NotificationService {
  @override
  void cancelHabitReminder(String habitId) {
    // no-op to avoid platform channel access
  }
}

class _MockHabitRepository implements HabitRepository {
  final _habits = <HabitEntity>[];
  final _streamController = StreamController<List<HabitEntity>>();

  @override
  Future<void> delete(String id) async {
    _habits.removeWhere((h) => h.id == id);
  }

  @override
  Future<List<HabitEntity>> getAll() async => _habits.toList();

  @override
  Future<List<HabitEntity>> getHabitsForDate(DateTime date) async {
    return _habits.where((h) => h.isScheduledFor(date)).toList();
  }

  @override
  Future<void> save(HabitEntity habit) async {
    _habits.removeWhere((h) => h.id == habit.id);
    _habits.add(habit);
  }

  @override
  Stream<List<HabitEntity>> watchAll() => _streamController.stream;

  @override
  Stream<List<HabitEntity>> watchHabitsForDate(DateTime date) => _streamController.stream;
}

class _MockHabitLogRepository implements HabitLogRepository {
  final _logs = <HabitLogEntity>[];
  final _streamController = StreamController<List<HabitLogEntity>>();

  @override
  Future<void> delete(String id) async {
    _logs.removeWhere((l) => l.id == id);
  }

  @override
  Future<void> deleteByHabitId(String habitId) async {
    _logs.removeWhere((l) => l.habitId == habitId);
  }

  @override
  Future<HabitLogEntity?> findByHabitAndDate(String habitId, DateTime date) async {
    for (final log in _logs) {
      if (log.habitId == habitId) return log;
    }
    return null;
  }

  @override
  Future<List<HabitLogEntity>> getLogsForRange(DateTime start, DateTime end) async {
    return _logs.toList();
  }

  @override
  Future<void> save(HabitLogEntity log) async {
    _logs.add(log);
  }

  @override
  Stream<List<HabitLogEntity>> watchLogsForRange(DateTime start, DateTime end) =>
      _streamController.stream;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('HabitActions', () {
    late _MockHabitRepository mockHabitRepo;
    late _MockHabitLogRepository mockLogRepo;
    late _MockNotificationService mockNotif;
    late HabitActions actions;

    setUp(() {
      mockHabitRepo = _MockHabitRepository();
      mockLogRepo = _MockHabitLogRepository();
      mockNotif = _MockNotificationService();
      actions = HabitActions(
        habitRepository: mockHabitRepo,
        habitLogRepository: mockLogRepo,
        notificationService: mockNotif,
      );
    });

    group('saveHabit', () {
      test('creates a new habit with generated id', () async {
        await actions.saveHabit(
          name: 'Leer 30 min',
          categoryId: 'study',
          selectedWeekdays: [1, 2, 3, 4, 5],
          isActive: true,
          durationMinutes: 30,
        );

        final habits = await mockHabitRepo.getAll();
        expect(habits.length, 1);
        expect(habits[0].name, 'Leer 30 min');
        expect(habits[0].categoryId, 'study');
        expect(habits[0].id.isNotEmpty, isTrue);
      });

      test('trims whitespace from name', () async {
        await actions.saveHabit(
          name: '  Correr  ',
          categoryId: 'health',
          selectedWeekdays: [1],
          isActive: true,
        );

        final habits = await mockHabitRepo.getAll();
        expect(habits[0].name, 'Correr');
      });

      test('sorts selected weekdays', () async {
        await actions.saveHabit(
          name: 'Test',
          categoryId: 'cat',
          selectedWeekdays: [5, 1, 3],
          isActive: true,
        );

        final habits = await mockHabitRepo.getAll();
        expect(habits[0].selectedWeekdays, [1, 3, 5]);
      });

      test('updates existing habit preserving createdAt', () async {
        final existing = HabitEntity(
          id: 'existing_id',
          name: 'Old',
          categoryId: 'cat',
          selectedWeekdays: [1],
          isActive: true,
          createdAt: DateTime(2025, 1, 1),
        );
        await mockHabitRepo.save(existing);

        await actions.saveHabit(
          existingHabit: existing,
          name: 'Updated',
          categoryId: 'cat',
          selectedWeekdays: [1],
          isActive: true,
        );

        final habits = await mockHabitRepo.getAll();
        expect(habits.length, 1);
        expect(habits[0].name, 'Updated');
        expect(habits[0].createdAt, DateTime(2025, 1, 1));
        expect(habits[0].id, 'existing_id');
      });
    });

    group('deleteHabit', () {
      test('soft-deletes habit but preserves its logs', () async {
        await mockHabitRepo.save(HabitEntity(
          id: 'del_id', name: 'Delete me', categoryId: 'cat',
          selectedWeekdays: [1], isActive: true, createdAt: DateTime.now(),
        ));
        await mockLogRepo.save(HabitLogEntity(
          id: 'log_del', habitId: 'del_id', date: DateTime.now(),
          isCompleted: true,
        ));

        await actions.deleteHabit('del_id');

        final habits = await mockHabitRepo.getAll();
        expect(habits.length, 1);
        expect(habits[0].deletedAt, isNotNull);

        final logs = await mockLogRepo.getLogsForRange(
          DateTime(2020), DateTime(2030),
        );
        expect(logs.length, 1);
      });
    });

    group('setHabitCompletion', () {
      final habit = HabitEntity(
        id: 'h1', name: 'Test', categoryId: 'cat',
        selectedWeekdays: [1], isActive: true, createdAt: DateTime.now(),
      );
      final date = DateTime(2026, 7, 6);

      test('creates a log when completing', () async {
        await actions.setHabitCompletion(
          habit: habit, date: date, isCompleted: true,
        );

        final logs = await mockLogRepo.getLogsForRange(date, date);
        expect(logs.length, 1);
        expect(logs[0].habitId, 'h1');
        expect(logs[0].isCompleted, isTrue);
        expect(logs[0].habitName, 'Test');
      });

      test('unchecking deletes the log', () async {
        await mockLogRepo.save(HabitLogEntity(
          id: 'existing', habitId: 'h1', date: date, isCompleted: true,
        ));

        await actions.setHabitCompletion(
          habit: habit, date: date, isCompleted: false,
        );

        final logs = await mockLogRepo.getLogsForRange(date, date);
        expect(logs, isEmpty);
      });

      test('unchecking when no log exists does nothing', () async {
        await actions.setHabitCompletion(
          habit: habit, date: date, isCompleted: false,
        );

        final logs = await mockLogRepo.getLogsForRange(date, date);
        expect(logs, isEmpty);
      });
    });
  });
}
