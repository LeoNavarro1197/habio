import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habio/features/habits/data/models/habit_model.dart';
import 'package:habio/features/habits/data/repositories/hive_habit_repository.dart';
import 'package:habio/features/habits/domain/entities/habit_entity.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  late Box<HabitModel> box;
  late HiveHabitRepository repo;

  setUpAll(() async {
    await HiveTestHelper.init();
    box = await Hive.openBox<HabitModel>('habit_repo_test');
    repo = HiveHabitRepository(box);
  });

  tearDownAll(() async {
    await box.close();
    await HiveTestHelper.cleanUp();
  });

  setUp(() async {
    await box.clear();
  });

  group('HiveHabitRepository', () {
    final baseDate = DateTime(2026, 7, 6);

    HabitEntity makeHabit(String id, List<int> weekdays, {bool active = true}) {
      return HabitEntity(
        id: id,
        name: 'Habit $id',
        categoryId: 'cat',
        selectedWeekdays: weekdays,
        isActive: active,
        createdAt: baseDate,
      );
    }

    test('save and getAll', () async {
      await repo.save(makeHabit('1', [1]));
      final all = await repo.getAll();
      expect(all.length, 1);
    });

    test('delete removes habit', () async {
      await repo.save(makeHabit('del', [1]));
      await repo.delete('del');
      final all = await repo.getAll();
      expect(all, isEmpty);
    });

    group('getHabitsForDate', () {
      test('returns only habits scheduled for that weekday', () async {
        await repo.save(makeHabit('mon_wed', [1, 3]));
        await repo.save(makeHabit('tue_thu', [2, 4]));

        final tuesday = DateTime(2026, 7, 7);
        final results = await repo.getHabitsForDate(tuesday);
        expect(results.length, 1);
        expect(results[0].id, 'tue_thu');
      });

      test('returns all habits for the weekday regardless of active status', () async {
        await repo.save(makeHabit('active', [1], active: true));
        await repo.save(makeHabit('inactive', [1], active: false));

        final monday = DateTime(2026, 7, 6);
        final results = await repo.getHabitsForDate(monday);
        expect(results.length, 2);
      });
    });
  });
}
