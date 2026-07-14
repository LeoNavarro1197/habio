import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:habio/features/categories/data/models/category_model.dart';
import 'package:habio/features/categories/domain/entities/category_entity.dart';
import '../helpers/hive_test_helper.dart';

void main() {
  group('CategoryModel', () {
    const entity = CategoryEntity(
      id: 'work',
      name: 'Trabajo',
      iconCodePoint: 0xe332,
    );

    test('fromEntity creates correct model', () {
      final model = CategoryModel.fromEntity(entity);
      expect(model.id, 'work');
      expect(model.name, 'Trabajo');
      expect(model.iconCodePoint, 0xe332);
    });

    test('toEntity recreates original entity', () {
      final model = CategoryModel.fromEntity(entity);
      final result = model.toEntity();
      expect(result.id, entity.id);
      expect(result.name, entity.name);
      expect(result.iconCodePoint, entity.iconCodePoint);
    });

    group('Hive adapter', () {
      setUpAll(() async {
        await HiveTestHelper.init();
      });

      tearDownAll(() async {
        await HiveTestHelper.cleanUp();
      });

      test('round-trip through Hive preserves data', () async {
        final box = await Hive.openBox<CategoryModel>('cat_test');
        final model = CategoryModel.fromEntity(entity);
        await box.put('work', model);

        final retrieved = box.get('work')!;
        expect(retrieved.id, 'work');
        expect(retrieved.name, 'Trabajo');

        final result = retrieved.toEntity();
        expect(result.id, entity.id);
        expect(result.name, entity.name);

        await box.close();
      });
    });
  });
}
