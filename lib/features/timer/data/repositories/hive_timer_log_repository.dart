import 'package:hive/hive.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/stream_extensions.dart';
import '../../domain/entities/timer_log_entity.dart';
import '../../domain/repositories/timer_log_repository.dart';
import '../models/timer_log_model.dart';

class HiveTimerLogRepository implements TimerLogRepository {
  HiveTimerLogRepository(this._box);

  final Box<TimerLogModel> _box;

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<TimerLogEntity>> getLogsForRange(
      DateTime start, DateTime end) async {
    return _forRange(start, end).map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> save(TimerLogEntity log) async {
    await _box.put(log.id, TimerLogModel.fromEntity(log));
  }

  @override
  Stream<List<TimerLogEntity>> watchLogsForRange(
      DateTime start, DateTime end) {
    return _box.watch().map((_) {
      return _forRange(start, end).map((model) => model.toEntity()).toList();
    }).startWith(
      _forRange(start, end).map((model) => model.toEntity()).toList(),
    );
  }

  List<TimerLogModel> _forRange(DateTime start, DateTime end) {
    final normalizedStart = HabioDateUtils.startOfDay(start);
    final normalizedEnd = HabioDateUtils.startOfDay(end);
    final list = _box.values.where((item) {
      final day = HabioDateUtils.startOfDay(item.completedAt);
      return !day.isBefore(normalizedStart) && !day.isAfter(normalizedEnd);
    }).toList();

    list.sort((left, right) => right.completedAt.compareTo(left.completedAt));
    return list;
  }
}
