import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_boxes.dart';
import '../../data/models/timer_log_model.dart';
import '../../data/repositories/hive_timer_log_repository.dart';
import '../../domain/entities/timer_log_entity.dart';
import '../../domain/repositories/timer_log_repository.dart';

final timerLogRepositoryProvider = Provider<TimerLogRepository>((ref) {
  return HiveTimerLogRepository(Hive.box<TimerLogModel>(HiveBoxes.timerLogs));
});

final lastMonthTimerLogsProvider =
    StreamProvider<List<TimerLogEntity>>((ref) {
  final end = DateTime.now();
  final start = end.subtract(const Duration(days: 29));
  return ref
      .watch(timerLogRepositoryProvider)
      .watchLogsForRange(start, end);
});
