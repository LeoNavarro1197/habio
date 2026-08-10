import 'package:hive/hive.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/habit_log_entity.dart';
class HabitLogModel extends HiveObject {
  HabitLogModel({
    required this.id,
    required this.habitId,
    required this.date,
    required this.isCompleted,
    this.completedAt,
    this.habitName,
    this.durationMinutes,
    this.completedCount = 0,
    this.timesPerDay = 1,
  });

  final String id;

  final String habitId;

  final DateTime date;

  final bool isCompleted;

  final DateTime? completedAt;

  final String? habitName;

  final int? durationMinutes;

  final int completedCount;

  final int timesPerDay;

  factory HabitLogModel.fromEntity(HabitLogEntity entity) {
    return HabitLogModel(
      id: entity.id,
      habitId: entity.habitId,
      date: HabioDateUtils.startOfDay(entity.date),
      isCompleted: entity.isCompleted,
      completedAt: entity.completedAt,
      habitName: entity.habitName,
      durationMinutes: entity.durationMinutes,
      completedCount: entity.completedCount,
      timesPerDay: entity.timesPerDay,
    );
  }

  HabitLogEntity toEntity() {
    return HabitLogEntity(
      id: id,
      habitId: habitId,
      date: date,
      isCompleted: isCompleted,
      completedAt: completedAt,
      habitName: habitName,
      durationMinutes: durationMinutes,
      completedCount: completedCount,
      timesPerDay: timesPerDay,
    );
  }
}

class HabitLogModelAdapter extends TypeAdapter<HabitLogModel> {
  @override
  final int typeId = 2;

  @override
  HabitLogModel read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var index = 0; index < fieldCount; index++) {
      fields[reader.readByte()] = reader.read();
    }

    return HabitLogModel(
      id: fields[0] as String,
      habitId: fields[1] as String,
      date: fields[2] as DateTime,
      isCompleted: fields[3] as bool,
      completedAt: fields[4] as DateTime?,
      habitName: fields[5] as String?,
      durationMinutes: fields[6] as int?,
      completedCount: fields[7] as int? ?? 0,
      timesPerDay: fields[8] as int? ?? 1,
    );
  }

  @override
  void write(BinaryWriter writer, HabitLogModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.habitId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.completedAt)
      ..writeByte(5)
      ..write(obj.habitName)
      ..writeByte(6)
      ..write(obj.durationMinutes)
      ..writeByte(7)
      ..write(obj.completedCount)
      ..writeByte(8)
      ..write(obj.timesPerDay);
  }
}
