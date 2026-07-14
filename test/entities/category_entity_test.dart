import 'package:flutter_test/flutter_test.dart';
import 'package:habio/features/categories/domain/entities/category_entity.dart';

void main() {
  group('CategoryEntity', () {
    const category = CategoryEntity(
      id: 'study',
      name: 'Estudio',
      iconCodePoint: 0xe80c,
    );

    test('props are set correctly', () {
      expect(category.id, 'study');
      expect(category.name, 'Estudio');
      expect(category.iconCodePoint, 0xe80c);
    });

    test('copyWith preserves unchanged fields', () {
      final copy = category.copyWith();
      expect(copy.id, category.id);
      expect(copy.name, category.name);
      expect(copy.iconCodePoint, category.iconCodePoint);
    });

    test('copyWith overrides specified fields', () {
      final copy = category.copyWith(name: 'Trabajo');
      expect(copy.id, 'study');
      expect(copy.name, 'Trabajo');
      expect(copy.iconCodePoint, 0xe80c);
    });
  });
}
