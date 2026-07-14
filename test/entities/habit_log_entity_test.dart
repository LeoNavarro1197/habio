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
  });
}
