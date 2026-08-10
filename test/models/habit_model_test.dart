import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habio/features/habits/data/models/habit_model.dart';
import 'package:habio/features/habits/domain/entities/habit_entity.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  group('HabitModel', () {
    final now = DateTime(2026, 7, 8);

    final entity = HabitEntity(
      id: 'h1',
      name: 'Correr',
      categoryId: 'health',
      selectedWeekdays: [1, 3, 5],
      isActive: true,
      createdAt: now,
      reminderMinutes: 420,
      durationMinutes: 30,
      timesPerDay: 8,
      reminderIntervalMinutes: 120,
    );

    test('fromEntity creates correct model', () {
      final model = HabitModel.fromEntity(entity);
      expect(model.id, 'h1');
      expect(model.name, 'Correr');
      expect(model.selectedWeekdays, [1, 3, 5]);
      expect(model.reminderMinutes, 420);
      expect(model.timesPerDay, 8);
      expect(model.reminderIntervalMinutes, 120);
    });

    test('toEntity recreates original entity', () {
      final model = HabitModel.fromEntity(entity);
      final result = model.toEntity();
      expect(result.id, entity.id);
      expect(result.name, entity.name);
      expect(result.selectedWeekdays, entity.selectedWeekdays);
      expect(result.reminderMinutes, entity.reminderMinutes);
      expect(result.durationMinutes, entity.durationMinutes);
      expect(result.isActive, entity.isActive);
      expect(result.timesPerDay, entity.timesPerDay);
      expect(result.reminderIntervalMinutes, entity.reminderIntervalMinutes);
    });

    test('selectedWeekdays list is independent copy', () {
      final model = HabitModel.fromEntity(entity);
      final result = model.toEntity();
      result.selectedWeekdays.add(7);
      expect(model.selectedWeekdays, [1, 3, 5]);
    });

    group('Hive adapter', () {
      setUpAll(() async {
        await HiveTestHelper.init();
      });

      tearDownAll(() async {
        await HiveTestHelper.cleanUp();
      });

      test('round-trip through Hive preserves data', () async {
        final box = await Hive.openBox<HabitModel>('habit_test');
        final model = HabitModel.fromEntity(entity);
        await box.put('h1', model);

        final retrieved = box.get('h1')!;
        final result = retrieved.toEntity();
        expect(result.id, 'h1');
        expect(result.name, 'Correr');
        expect(result.selectedWeekdays, [1, 3, 5]);
        expect(result.reminderMinutes, 420);
        expect(result.durationMinutes, 30);
        expect(result.isActive, isTrue);
        expect(result.timesPerDay, 8);
        expect(result.reminderIntervalMinutes, 120);

        await box.close();
      });
    });
  });
}
