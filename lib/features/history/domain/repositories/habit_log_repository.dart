import '../entities/habit_log_entity.dart';

abstract class HabitLogRepository {
  Future<List<HabitLogEntity>> getLogsForRange(DateTime start, DateTime end);
  Stream<List<HabitLogEntity>> watchLogsForRange(DateTime start, DateTime end);
  Future<HabitLogEntity?> findByHabitAndDate(String habitId, DateTime date);
  Future<void> save(HabitLogEntity log);
  Future<void> delete(String id);
  Future<void> deleteByHabitId(String habitId);
}
