import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_boxes.dart';
import '../../data/models/habit_log_model.dart';
import '../../data/repositories/hive_habit_log_repository.dart';
import '../../domain/entities/habit_log_entity.dart';
import '../../domain/repositories/habit_log_repository.dart';

final habitLogRepositoryProvider = Provider<HabitLogRepository>((ref) {
  return HiveHabitLogRepository(Hive.box<HabitLogModel>(HiveBoxes.habitLogs));
});

final lastMonthLogsProvider = StreamProvider<List<HabitLogEntity>>((ref) {
  final end = DateTime.now();
  final start = end.subtract(const Duration(days: 29));
  return ref.watch(habitLogRepositoryProvider).watchLogsForRange(start, end);
});
