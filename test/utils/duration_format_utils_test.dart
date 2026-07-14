import 'package:flutter_test/flutter_test.dart';
import 'package:habio/core/utils/duration_format_utils.dart';

void main() {
  group('DurationFormatUtils', () {
    test('formatCountdown formats zero', () {
      expect(DurationFormatUtils.formatCountdown(0), '00:00');
    });

    test('formatCountdown formats seconds only', () {
      expect(DurationFormatUtils.formatCountdown(45), '00:45');
    });

    test('formatCountdown formats minutes and seconds', () {
      expect(DurationFormatUtils.formatCountdown(125), '02:05');
    });

    test('formatCountdown formats exact minute', () {
      expect(DurationFormatUtils.formatCountdown(300), '05:00');
    });

    test('formatCountdown formats large values', () {
      expect(DurationFormatUtils.formatCountdown(3661), '61:01');
    });

    test('formatCountdown pads single digits', () {
      expect(DurationFormatUtils.formatCountdown(7), '00:07');
      expect(DurationFormatUtils.formatCountdown(70), '01:10');
    });
  });
}
