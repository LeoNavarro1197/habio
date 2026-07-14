import 'package:flutter_test/flutter_test.dart';
import 'package:habio/core/utils/id_generator.dart';

void main() {
  group('IdGenerator', () {
    test('next returns a non-empty string', () {
      final id = IdGenerator.next();
      expect(id, isA<String>());
      expect(id.isNotEmpty, isTrue);
    });

    test('next returns unique values on consecutive calls', () {
      final ids = List.generate(100, (_) => IdGenerator.next());
      final unique = ids.toSet();
      expect(unique.length, 100);
    });

    test('id contains underscore separator', () {
      final id = IdGenerator.next();
      expect(id.contains('_'), isTrue);
    });
  });
}
