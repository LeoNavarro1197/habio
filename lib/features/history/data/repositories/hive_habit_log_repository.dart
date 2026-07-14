import 'package:hive/hive.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/stream_extensions.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../../domain/repositories/habit_log_repository.dart';
import '../models/habit_log_model.dart';

class HiveHabitLogRepository implements HabitLogRepository {
  HiveHabitLogRepository(this._box);

  final Box<HabitLogModel> _box;

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> deleteByHabitId(String habitId) async {
    final keysToDelete = <dynamic>[];
    for (final entry in _box.toMap().entries) {
      if (entry.value.habitId == habitId) {
        keysToDelete.add(entry.key);
      }
    }
    await _box.deleteAll(keysToDelete);
  }

  @override
  Future<HabitLogEntity?> findByHabitAndDate(String habitId, DateTime date) async {
    final targetDate = HabioDateUtils.startOfDay(date);
    for (final log in _box.values) {
      if (log.habitId == habitId && HabioDateUtils.isSameDay(log.date, targetDate)) {
        return log.toEntity();
      }
    }
    return null;
  }

  @override
  Future<List<HabitLogEntity>> getLogsForRange(DateTime start, DateTime end) async {
    return _forRange(start, end).map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> save(HabitLogEntity log) async {
    await _box.put(log.id, HabitLogModel.fromEntity(log));
  }

  @override
  Stream<List<HabitLogEntity>> watchLogsForRange(DateTime start, DateTime end) {
    return _box.watch().map((_) {
      return _forRange(start, end).map((model) => model.toEntity()).toList();
    }).startWith(
      _forRange(start, end).map((model) => model.toEntity()).toList(),
    );
  }

  List<HabitLogModel> _forRange(DateTime start, DateTime end) {
    final normalizedStart = HabioDateUtils.startOfDay(start);
    final normalizedEnd = HabioDateUtils.startOfDay(end);
    final list = _box.values.where((item) {
      final day = HabioDateUtils.startOfDay(item.date);
      return !day.isBefore(normalizedStart) && !day.isAfter(normalizedEnd);
    }).toList();

    list.sort((left, right) => right.date.compareTo(left.date));
    return list;
  }
}
