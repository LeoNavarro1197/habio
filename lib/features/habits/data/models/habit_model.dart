import 'package:hive/hive.dart';

import '../../domain/entities/habit_entity.dart';
class HabitModel extends HiveObject {
  HabitModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.selectedWeekdays,
    required this.isActive,
    required this.createdAt,
    this.reminderMinutes,
    this.durationMinutes,
    this.deletedAt,
    this.deactivatedAt,
  });

  final String id;

  final String name;

  final String categoryId;

  final List<int> selectedWeekdays;

  final int? reminderMinutes;

  final int? durationMinutes;

  final bool isActive;

  final DateTime createdAt;

  final DateTime? deletedAt;

  final DateTime? deactivatedAt;

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      name: entity.name,
      categoryId: entity.categoryId,
      selectedWeekdays: List<int>.from(entity.selectedWeekdays),
      reminderMinutes: entity.reminderMinutes,
      durationMinutes: entity.durationMinutes,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      deletedAt: entity.deletedAt,
      deactivatedAt: entity.deactivatedAt,
    );
  }

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      name: name,
      categoryId: categoryId,
      selectedWeekdays: List<int>.from(selectedWeekdays),
      reminderMinutes: reminderMinutes,
      durationMinutes: durationMinutes,
      isActive: isActive,
      createdAt: createdAt,
      deletedAt: deletedAt,
      deactivatedAt: deactivatedAt,
    );
  }
}

class HabitModelAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 1;

  @override
  HabitModel read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var index = 0; index < fieldCount; index++) {
      fields[reader.readByte()] = reader.read();
    }

    return HabitModel(
      id: fields[0] as String,
      name: fields[1] as String,
      categoryId: fields[2] as String,
      selectedWeekdays: (fields[3] as List).cast<int>(),
      reminderMinutes: fields[4] as int?,
      durationMinutes: fields[5] as int?,
      isActive: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      deletedAt: fields[8] as DateTime?,
      deactivatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.selectedWeekdays)
      ..writeByte(4)
      ..write(obj.reminderMinutes)
      ..writeByte(5)
      ..write(obj.durationMinutes)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.deletedAt)
      ..writeByte(9)
      ..write(obj.deactivatedAt);
  }
}
