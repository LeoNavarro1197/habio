import 'package:hive/hive.dart';

import '../../../../core/utils/date_utils.dart';
import '../../domain/entities/timer_log_entity.dart';

class TimerLogModel extends HiveObject {
  TimerLogModel({
    required this.id,
    required this.activityName,
    required this.durationMinutes,
    required this.completedAt,
  });

  final String id;
  final String activityName;
  final int durationMinutes;
  final DateTime completedAt;

  factory TimerLogModel.fromEntity(TimerLogEntity entity) {
    return TimerLogModel(
      id: entity.id,
      activityName: entity.activityName,
      durationMinutes: entity.durationMinutes,
      completedAt: entity.completedAt,
    );
  }

  TimerLogEntity toEntity() {
    return TimerLogEntity(
      id: id,
      activityName: activityName,
      durationMinutes: durationMinutes,
      completedAt: completedAt,
    );
  }
}

class TimerLogModelAdapter extends TypeAdapter<TimerLogModel> {
  @override
  final int typeId = 3;

  @override
  TimerLogModel read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var index = 0; index < fieldCount; index++) {
      fields[reader.readByte()] = reader.read();
    }

    return TimerLogModel(
      id: fields[0] as String,
      activityName: fields[1] as String,
      durationMinutes: fields[2] as int,
      completedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TimerLogModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.activityName)
      ..writeByte(2)
      ..write(obj.durationMinutes)
      ..writeByte(3)
      ..write(obj.completedAt);
  }
}
