import 'package:flutter_test/flutter_test.dart';
import 'package:habio/core/utils/date_time_extensions.dart';

void main() {
  group('HabioDateTimeX', () {
    group('spanishLongDate', () {
      test('formats correctly', () {
        final date = DateTime(2026, 7, 8);
        expect(date.spanishLongDate, 'miércoles, 8 de julio');
      });

      test('returns correct weekday for Monday', () {
        final date = DateTime(2026, 7, 6);
        expect(date.spanishLongDate, 'lunes, 6 de julio');
      });

      test('uses correct month name', () {
        final date = DateTime(2026, 1, 1);
        expect(date.spanishLongDate, 'jueves, 1 de enero');
      });
    });

    group('greeting', () {
      test('returns Buenos días before noon', () {
        final morning = DateTime(2026, 7, 8, 9, 0);
        expect(morning.greeting, 'Buenos días');
      });

      test('returns Buenas tardes in afternoon', () {
        final afternoon = DateTime(2026, 7, 8, 15, 0);
        expect(afternoon.greeting, 'Buenas tardes');
      });

      test('returns Buenas noches after 19', () {
        final night = DateTime(2026, 7, 8, 22, 0);
        expect(night.greeting, 'Buenas noches');
      });

      test('boundary at 12', () {
        final noon = DateTime(2026, 7, 8, 12, 0);
        expect(noon.greeting, 'Buenas tardes');
      });

      test('boundary at 19', () {
        final evening = DateTime(2026, 7, 8, 19, 0);
        expect(evening.greeting, 'Buenas noches');
      });
    });
  });
}
