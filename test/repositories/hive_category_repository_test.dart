import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habio/features/categories/data/models/category_model.dart';
import 'package:habio/features/categories/data/repositories/hive_category_repository.dart';
import 'package:habio/features/categories/domain/entities/category_entity.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  late Box<CategoryModel> box;
  late HiveCategoryRepository repo;

  setUpAll(() async {
    await HiveTestHelper.init();
    box = await Hive.openBox<CategoryModel>('cat_repo_test');
    repo = HiveCategoryRepository(box);
  });

  tearDownAll(() async {
    await box.close();
    await HiveTestHelper.cleanUp();
  });

  setUp(() async {
    await box.clear();
  });

  group('HiveCategoryRepository', () {
    test('save and getAll', () async {
      await repo.save(const CategoryEntity(id: 'a', name: 'A', iconCodePoint: 1));
      await repo.save(const CategoryEntity(id: 'b', name: 'B', iconCodePoint: 2));

      final all = await repo.getAll();
      expect(all.length, 2);
    });

    test('getAll returns sorted by name', () async {
      await repo.save(const CategoryEntity(id: 'z', name: 'Zeta', iconCodePoint: 3));
      await repo.save(const CategoryEntity(id: 'a', name: 'Alpha', iconCodePoint: 4));

      final all = await repo.getAll();
      expect(all[0].name, 'Alpha');
      expect(all[1].name, 'Zeta');
    });

    test('findById returns null for missing id', () async {
      final result = await repo.findById('nonexistent');
      expect(result, isNull);
    });

    test('findById returns category after save', () async {
      await repo.save(const CategoryEntity(id: 'x', name: 'X', iconCodePoint: 5));
      final result = await repo.findById('x');
      expect(result, isNotNull);
      expect(result!.name, 'X');
    });

    test('delete removes category', () async {
      await repo.save(const CategoryEntity(id: 'd', name: 'D', iconCodePoint: 6));
      await repo.delete('d');
      final result = await repo.findById('d');
      expect(result, isNull);
    });

    test('watchAll emits initial value', () async {
      final initial = await repo.watchAll().first;
      expect(initial, isEmpty);
    });

    test('watchAll emits after save', () async {
      await repo.save(const CategoryEntity(id: 'c', name: 'C', iconCodePoint: 7));
      final result = await repo.watchAll().first;
      expect(result.length, 1);
      expect(result[0].name, 'C');
    });
  });
}
