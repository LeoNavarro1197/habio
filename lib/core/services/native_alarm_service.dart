import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeAlarmService {
  static const _channel = MethodChannel('com.habio.miapp/alarm');

  static Future<void> schedule({
    required int id,
    required String habitName,
    required DateTime triggerAt,
  }) async {
    debugPrint('[Habio] NativeAlarm schedule id=$id name=$habitName at=${triggerAt.toIso8601String()} epoch=${triggerAt.millisecondsSinceEpoch}');
    try {
      await _channel.invokeMethod('scheduleAlarm', {
        'id': id,
        'habitName': habitName,
        'triggerAtMillis': triggerAt.millisecondsSinceEpoch,
      });
      debugPrint('[Habio] NativeAlarm schedule SUCCESS id=$id');
    } catch (err) {
      debugPrint('[Habio] NativeAlarm schedule error: $err');
    }
  }

  static Future<void> cancel(int id) async {
    try {
      await _channel.invokeMethod('cancelAlarm', {'id': id});
    } catch (err) {
      debugPrint('[Habio] NativeAlarm cancel error: $err');
    }
  }
}
