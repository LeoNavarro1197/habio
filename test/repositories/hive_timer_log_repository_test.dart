import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habio/features/timer/data/models/timer_log_model.dart';
import 'package:habio/features/timer/data/repositories/hive_timer_log_repository.dart';
import 'package:habio/features/timer/domain/entities/timer_log_entity.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  late Box<TimerLogModel> box;
  late HiveTimerLogRepository repo;

  setUpAll(() async {
    await HiveTestHelper.init();
    box = await Hive.openBox<TimerLogModel>('timer_repo_test');
    repo = HiveTimerLogRepository(box);
  });

  tearDownAll(() async {
    await box.close();
    await HiveTestHelper.cleanUp();
  });

  setUp(() async {
    await box.clear();
  });

  group('HiveTimerLogRepository', () {
    final day1 = DateTime(2026, 7, 6);
    final day2 = DateTime(2026, 7, 7);

    TimerLogEntity makeLog(String id, DateTime completedAt) {
      return TimerLogEntity(
        id: id,
        activityName: 'Session $id',
        durationMinutes: 25,
        completedAt: completedAt,
      );
    }

    test('save and getLogsForRange', () async {
      await repo.save(makeLog('t1', day1));
      await repo.save(makeLog('t2', day2));

      final range = await repo.getLogsForRange(day1, day2);
      expect(range.length, 2);
    });

    test('getLogsForRange returns sorted by completedAt descending', () async {
      final logs = [
        makeLog('first', day1),
        makeLog('second', day2),
      ];
      // Insert out of order
      await repo.save(logs[1]);
      await repo.save(logs[0]);

      final range = await repo.getLogsForRange(day1, day2);
      expect(range[0].id, 'second');
      expect(range[1].id, 'first');
    });

    test('delete removes log', () async {
      await repo.save(makeLog('del', day1));
      await repo.delete('del');
      final range = await repo.getLogsForRange(day1, day1);
      expect(range, isEmpty);
    });

    test('watchLogsForRange emits initial value', () async {
      await repo.save(makeLog('w1', day1));
      final stream = repo.watchLogsForRange(day1, day1);
      final initial = await stream.first;
      expect(initial.length, 1);
    });
  });
}
