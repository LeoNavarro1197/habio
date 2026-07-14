import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getAll();
  Stream<List<CategoryEntity>> watchAll();
  Future<CategoryEntity?> findById(String id);
  Future<void> save(CategoryEntity category);
  Future<void> delete(String id);
}
