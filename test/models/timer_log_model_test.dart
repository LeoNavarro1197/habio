import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habio/features/timer/data/models/timer_log_model.dart';
import 'package:habio/features/timer/domain/entities/timer_log_entity.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  group('TimerLogModel', () {
    final now = DateTime(2026, 7, 8);

    final entity = TimerLogEntity(
      id: 't1',
      activityName: 'Enfoque',
      durationMinutes: 25,
      completedAt: now,
    );

    test('fromEntity creates correct model', () {
      final model = TimerLogModel.fromEntity(entity);
      expect(model.id, 't1');
      expect(model.activityName, 'Enfoque');
      expect(model.durationMinutes, 25);
    });

    test('toEntity recreates original entity', () {
      final model = TimerLogModel.fromEntity(entity);
      final result = model.toEntity();
      expect(result.id, entity.id);
      expect(result.activityName, entity.activityName);
      expect(result.durationMinutes, entity.durationMinutes);
    });

    group('Hive adapter', () {
      setUpAll(() async {
        await HiveTestHelper.init();
      });

      tearDownAll(() async {
        await HiveTestHelper.cleanUp();
      });

      test('round-trip through Hive preserves data', () async {
        final box = await Hive.openBox<TimerLogModel>('timer_test');
        final model = TimerLogModel.fromEntity(entity);
        await box.put('t1', model);

        final retrieved = box.get('t1')!;
        final result = retrieved.toEntity();
        expect(result.id, 't1');
        expect(result.activityName, 'Enfoque');
        expect(result.durationMinutes, 25);

        await box.close();
      });
    });
  });
}
