import 'package:flutter_test/flutter_test.dart';
import 'package:habio/features/history/domain/entities/habit_log_entity.dart';

void main() {
  group('HabitLogEntity', () {
    final today = DateTime(2026, 7, 8);

    final log = HabitLogEntity(
      id: 'log_1',
      habitId: 'habit_1',
      date: today,
      isCompleted: true,
      completedAt: today,
    );

    test('props are set correctly', () {
      expect(log.id, 'log_1');
      expect(log.habitId, 'habit_1');
      expect(log.isCompleted, isTrue);
    });

    test('copyWith overrides specified fields', () {
      final copy = log.copyWith(isCompleted: false);
      expect(copy.isCompleted, isFalse);
      expect(copy.habitId, 'habit_1');
    });

    test('completedCount and timesPerDay default to 0 and 1', () {
      expect(log.completedCount, 0);
      expect(log.timesPerDay, 1);
    });

    test('copyWith overrides completedCount and timesPerDay', () {
      final copy = log.copyWith(completedCount: 5, timesPerDay: 8);
      expect(copy.completedCount, 5);
      expect(copy.timesPerDay, 8);
    });

    test('isFullyCompleted is true when count reaches timesPerDay', () {
      HabitLogEntity buildLog({int count = 0, int times = 1}) => HabitLogEntity(
            id: 'log',
            habitId: 'habit',
            date: today,
            isCompleted: false,
            completedCount: count,
            timesPerDay: times,
          );
      expect(buildLog(count: 8, times: 8).isFullyCompleted, isTrue);
      expect(buildLog(count: 7, times: 8).isFullyCompleted, isFalse);
      expect(buildLog(count: 0, times: 1).isFullyCompleted, isFalse);
    });
  });
}
