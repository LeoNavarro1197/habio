import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habio/features/history/data/models/habit_log_model.dart';
import 'package:habio/features/history/data/repositories/hive_habit_log_repository.dart';
import 'package:habio/features/history/domain/entities/habit_log_entity.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  late Box<HabitLogModel> box;
  late HiveHabitLogRepository repo;

  setUpAll(() async {
    await HiveTestHelper.init();
    box = await Hive.openBox<HabitLogModel>('log_repo_test');
    repo = HiveHabitLogRepository(box);
  });

  tearDownAll(() async {
    await box.close();
    await HiveTestHelper.cleanUp();
  });

  setUp(() async {
    await box.clear();
  });

  group('HiveHabitLogRepository', () {
    final day1 = DateTime(2026, 7, 6);
    final day2 = DateTime(2026, 7, 7);

    HabitLogEntity makeLog(String id, String habitId, DateTime date) {
      return HabitLogEntity(
        id: id,
        habitId: habitId,
        date: date,
        isCompleted: true,
        completedAt: date,
      );
    }

    test('save and getLogsForRange', () async {
      await repo.save(makeLog('l1', 'h1', day1));
      await repo.save(makeLog('l2', 'h2', day1));

      final range = await repo.getLogsForRange(day1, day2);
      expect(range.length, 2);
    });

    test('getLogsForRange filters by date range', () async {
      await repo.save(makeLog('l_mid', 'h1', day1));

      final range = await repo.getLogsForRange(day1, day2);
      expect(range.length, 1);
    });

    test('delete removes log', () async {
      await repo.save(makeLog('del', 'h1', day1));
      await repo.delete('del');
      final range = await repo.getLogsForRange(day1, day1);
      expect(range, isEmpty);
    });

    test('deleteByHabitId removes all logs for a habit', () async {
      await repo.save(makeLog('a', 'h1', day1));
      await repo.save(makeLog('b', 'h2', day1));

      await repo.deleteByHabitId('h1');
      final remaining = await repo.getLogsForRange(day1, day2);
      expect(remaining.length, 1);
      expect(remaining[0].habitId, 'h2');
    });

    test('findByHabitAndDate returns correct log', () async {
      await repo.save(makeLog('target', 'h1', day1));
      await repo.save(makeLog('other', 'h1', day2));

      final result = await repo.findByHabitAndDate('h1', day1);
      expect(result, isNotNull);
      expect(result!.id, 'target');
    });

    test('findByHabitAndDate returns null when no match', () async {
      final result = await repo.findByHabitAndDate('nonexistent', day1);
      expect(result, isNull);
    });

    test('watchLogsForRange emits initial value', () async {
      await repo.save(makeLog('w1', 'h1', day1));
      final stream = repo.watchLogsForRange(day1, day1);
      final initial = await stream.first;
      expect(initial.length, 1);
    });
  });
}
