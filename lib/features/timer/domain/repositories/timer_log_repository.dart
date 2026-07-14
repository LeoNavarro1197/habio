import '../entities/timer_log_entity.dart';

abstract class TimerLogRepository {
  Future<List<TimerLogEntity>> getLogsForRange(DateTime start, DateTime end);
  Stream<List<TimerLogEntity>> watchLogsForRange(DateTime start, DateTime end);
  Future<void> save(TimerLogEntity log);
  Future<void> delete(String id);
}
