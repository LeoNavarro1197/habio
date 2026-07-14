import 'dart:math';

class IdGenerator {
  IdGenerator._();

  static final Random _random = Random();

  static String next() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final suffix = _random.nextInt(1 << 32).toRadixString(16);
    return '${timestamp}_$suffix';
  }
}
