import 'package:flutter_test/flutter_test.dart';
import 'package:habio/features/timer/domain/entities/timer_log_entity.dart';

void main() {
  group('TimerLogEntity', () {
    final now = DateTime(2026, 7, 8);

    final log = TimerLogEntity(
      id: 'timer_1',
      activityName: 'Sesión de enfoque',
      durationMinutes: 25,
      completedAt: now,
    );

    test('props are set correctly', () {
      expect(log.id, 'timer_1');
      expect(log.activityName, 'Sesión de enfoque');
      expect(log.durationMinutes, 25);
    });

    test('copyWith overrides specified fields', () {
      final copy = log.copyWith(durationMinutes: 15);
      expect(copy.durationMinutes, 15);
      expect(copy.activityName, 'Sesión de enfoque');
    });
  });
}
