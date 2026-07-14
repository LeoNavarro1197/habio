import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habio/features/history/data/models/habit_log_model.dart';
import 'package:habio/features/history/domain/entities/habit_log_entity.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  group('HabitLogModel', () {
    final today = DateTime(2026, 7, 8);

    final entity = HabitLogEntity(
      id: 'log1',
      habitId: 'h1',
      date: today,
      isCompleted: true,
      completedAt: today,
    );

    test('fromEntity creates correct model', () {
      final model = HabitLogModel.fromEntity(entity);
      expect(model.id, 'log1');
      expect(model.habitId, 'h1');
      expect(model.isCompleted, isTrue);
    });

    test('toEntity recreates original entity', () {
      final model = HabitLogModel.fromEntity(entity);
      final result = model.toEntity();
      expect(result.id, entity.id);
      expect(result.habitId, entity.habitId);
      expect(result.isCompleted, entity.isCompleted);
    });

    group('Hive adapter', () {
      setUpAll(() async {
        await HiveTestHelper.init();
      });

      tearDownAll(() async {
        await HiveTestHelper.cleanUp();
      });

      test('round-trip through Hive preserves data', () async {
        final box = await Hive.openBox<HabitLogModel>('log_test');
        final model = HabitLogModel.fromEntity(entity);
        await box.put('log1', model);

        final retrieved = box.get('log1')!;
        final result = retrieved.toEntity();
        expect(result.id, 'log1');
        expect(result.habitId, 'h1');
        expect(result.isCompleted, isTrue);

        await box.close();
      });
    });
  });
}
