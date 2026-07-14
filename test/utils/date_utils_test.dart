import 'package:flutter_test/flutter_test.dart';
import 'package:habio/core/utils/date_utils.dart';

void main() {
  group('HabioDateUtils', () {
    group('startOfDay', () {
      test('returns date at midnight', () {
        final date = DateTime(2026, 7, 8, 15, 30, 45);
        final result = HabioDateUtils.startOfDay(date);
        expect(result.year, 2026);
        expect(result.month, 7);
        expect(result.day, 8);
        expect(result.hour, 0);
        expect(result.minute, 0);
        expect(result.second, 0);
      });

      test('idempotent on already-normalized date', () {
        final date = DateTime(2026, 7, 8);
        final result = HabioDateUtils.startOfDay(date);
        expect(result, date);
      });
    });

    group('isSameDay', () {
      test('returns true for same date', () {
        expect(
          HabioDateUtils.isSameDay(
            DateTime(2026, 7, 8),
            DateTime(2026, 7, 8),
          ),
          isTrue,
        );
      });

      test('returns true regardless of time', () {
        expect(
          HabioDateUtils.isSameDay(
            DateTime(2026, 7, 8, 8, 0),
            DateTime(2026, 7, 8, 22, 30),
          ),
          isTrue,
        );
      });

      test('returns false for different dates', () {
        expect(
          HabioDateUtils.isSameDay(
            DateTime(2026, 7, 8),
            DateTime(2026, 7, 9),
          ),
          isFalse,
        );
      });
    });
  });
}
