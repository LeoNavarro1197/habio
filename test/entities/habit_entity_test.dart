import 'package:flutter_test/flutter_test.dart';
import 'package:habio/features/habits/domain/entities/habit_entity.dart';

void main() {
  group('HabitEntity', () {
    final baseDate = DateTime(2026, 7, 8);

    final habit = HabitEntity(
      id: 'habit_1',
      name: 'Leer',
      categoryId: 'study',
      selectedWeekdays: [1, 2, 3, 4, 5],
      isActive: true,
      createdAt: baseDate,
      reminderMinutes: 480,
      durationMinutes: 25,
    );

    group('isScheduledFor', () {
      test('returns true for weekdays in selectedWeekdays', () {
        expect(habit.isScheduledFor(DateTime(2026, 7, 6)), isTrue);
        expect(habit.isScheduledFor(DateTime(2026, 7, 7)), isTrue);
        expect(habit.isScheduledFor(DateTime(2026, 7, 8)), isTrue);
        expect(habit.isScheduledFor(DateTime(2026, 7, 9)), isTrue);
        expect(habit.isScheduledFor(DateTime(2026, 7, 10)), isTrue);
      });

      test('returns false for weekend days', () {
        expect(habit.isScheduledFor(DateTime(2026, 7, 11)), isFalse);
        expect(habit.isScheduledFor(DateTime(2026, 7, 12)), isFalse);
      });
    });

    test('copyWith overrides specified fields', () {
      final copy = habit.copyWith(name: 'Estudiar', isActive: false);
      expect(copy.name, 'Estudiar');
      expect(copy.isActive, false);
      expect(copy.categoryId, 'study');
    });

    test('timesPerDay defaults to 1', () {
      expect(habit.timesPerDay, 1);
    });

    test('copyWith overrides timesPerDay', () {
      final copy = habit.copyWith(timesPerDay: 8);
      expect(copy.timesPerDay, 8);
      expect(copy.timesPerDay, isNot(habit.timesPerDay));
    });

    test('reminderIntervalMinutes defaults to null', () {
      expect(habit.reminderIntervalMinutes, isNull);
    });

    test('copyWith overrides reminderIntervalMinutes', () {
      final copy = habit.copyWith(reminderIntervalMinutes: 120);
      expect(copy.reminderIntervalMinutes, 120);
    });
  });
}
