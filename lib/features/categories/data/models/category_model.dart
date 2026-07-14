import 'package:hive/hive.dart';

import '../../domain/entities/category_entity.dart';
class CategoryModel extends HiveObject {
  CategoryModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
  });

  final String id;

  final String name;

  final int iconCodePoint;

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      iconCodePoint: entity.iconCodePoint,
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      iconCodePoint: iconCodePoint,
    );
  }
}

class CategoryModelAdapter extends TypeAdapter<CategoryModel> {
  @override
  final int typeId = 0;

  @override
  CategoryModel read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var index = 0; index < fieldCount; index++) {
      fields[reader.readByte()] = reader.read();
    }

    return CategoryModel(
      id: fields[0] as String,
      name: fields[1] as String,
      iconCodePoint: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconCodePoint);
  }
}
