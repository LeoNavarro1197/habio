import 'package:hive/hive.dart';

import '../../../../core/utils/stream_extensions.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';

class HiveCategoryRepository implements CategoryRepository {
  HiveCategoryRepository(this._box);

  final Box<CategoryModel> _box;

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<CategoryEntity?> findById(String id) async {
    return _box.get(id)?.toEntity();
  }

  @override
  Future<List<CategoryEntity>> getAll() async {
    return _sorted(_box.values).map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> save(CategoryEntity category) async {
    await _box.put(category.id, CategoryModel.fromEntity(category));
  }

  @override
  Stream<List<CategoryEntity>> watchAll() {
    return _box.watch().map((_) {
      return _sorted(_box.values).map((model) => model.toEntity()).toList();
    }).startWith(_sorted(_box.values).map((model) => model.toEntity()).toList());
  }

  List<CategoryModel> _sorted(Iterable<CategoryModel> items) {
    final list = items.toList();
    list.sort((left, right) => left.name.compareTo(right.name));
    return list;
  }
}
