import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import 'native_alarm_service.dart';

class NotificationServiceHolder {
  static final NotificationService instance = NotificationService();
}

class NotificationService {
  static const _timerChannelId = 'habio_timer';
  static const _timerChannelName = 'Temporizador';
  static const _timerNotificationId = 1001;

  static const _reminderChannelId = 'habio_reminders';
  static const _reminderChannelName = 'Recordatorios';
  static const _reminderIdOffset = 2000;
  static const _systemIdStep = 1000;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final Map<int, Timer> _activeTimers = {};

  bool _enabled = true;
  bool _initialized = false;

  bool get isEnabled => _enabled;

  void updateEnabledSetting(bool enabled) {
    _enabled = enabled;
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    const timerChannel = AndroidNotificationChannel(
      _timerChannelId,
      _timerChannelName,
      description: 'Notificaciones de sesiones del temporizador',
      importance: Importance.high,
    );

    const reminderChannel = AndroidNotificationChannel(
      _reminderChannelId,
      _reminderChannelName,
      description: 'Recordatorios de hábitos',
      importance: Importance.high,
    );

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(timerChannel);
    await android?.createNotificationChannel(reminderChannel);

    _initialized = true;
  }

  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    _cancelAllTimers();
    if (!enabled) {
      await _plugin.cancelAll();
    }
  }

  Future<void> requestPermissions() async {
    await _ensureInitialized();

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      await ios.requestPermissions(
        alert: true,
        sound: true,
      );
    }
  }

  Future<void> showTimerCompletedNotification({
    required String activityName,
  }) async {
    if (!_enabled) {
      return;
    }

    final normalizedName = activityName.trim();
    final title = 'Sesión completada';
    final body = normalizedName.isEmpty
        ? 'Tu sesión de enfoque ha terminado.'
        : 'Has completado: $normalizedName';

    const androidDetails = AndroidNotificationDetails(
      _timerChannelId,
      _timerChannelName,
      channelDescription: 'Notificaciones de sesiones del temporizador',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'notification_icon',
    );

    const iosDetails = DarwinNotificationDetails();

    await _plugin.show(
      _timerNotificationId,
      title,
      body,
      const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  void scheduleHabitReminder({
    required String habitId,
    required String name,
    required int reminderMinutes,
    required List<int> selectedWeekdays,
  }) {
    if (!_enabled) {
      return;
    }

    cancelHabitReminder(habitId);

    final id = _reminderId(habitId);
    final now = DateTime.now();
    final hour = reminderMinutes ~/ 60;
    final minute = reminderMinutes % 60;

    if (hour >= 24) {
      return;
    }

    final nextValid = _nextValidDate(
      from: now,
      hour: hour,
      minute: minute,
      weekdays: selectedWeekdays,
    );
    if (nextValid == null) {
      return;
    }

    final delay = nextValid.difference(now);

    if (delay.inSeconds <= 0) {
      return;
    }

    final timer = Timer(delay, () async {
      await showHabitReminderNotification(name: name, id: id);
    });
    _activeTimers[id] = timer;

    unawaited(_scheduleSystemReminder(
      id: id,
      name: name,
      hour: hour,
      minute: minute,
      weekdays: selectedWeekdays,
    ));
  }

  Future<void> _scheduleSystemReminder({
    required int id,
    required String name,
    required int hour,
    required int minute,
    required List<int> weekdays,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _reminderChannelId,
      _reminderChannelName,
      channelDescription: 'Recordatorios de hábitos',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'notification_icon',
    );

    const iosDetails = DarwinNotificationDetails();

    var scheduled = 0;
    var offset = 0;
    final start = DateTime.now();

    while (scheduled < 7 && offset < 31) {
      final day = start.add(Duration(days: offset));
      final alarmLocal = DateTime(day.year, day.month, day.day, hour, minute);
      offset++;

      if (alarmLocal.isBefore(DateTime.now())) {
        continue;
      }

      if (!weekdays.contains(day.weekday)) {
        continue;
      }

      final systemId = id + scheduled * _systemIdStep;

      unawaited(NativeAlarmService.schedule(
        id: systemId,
        habitName: name,
        triggerAt: alarmLocal,
      ));

      try {
        await _plugin.zonedSchedule(
          systemId,
          'Recordatorio: $name',
          'Es hora de tu hábito: $name',
          tz.TZDateTime.from(alarmLocal, tz.UTC),
          const NotificationDetails(
            android: androidDetails,
            iOS: iosDetails,
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (err) {
        debugPrint('[Habio] Error zonedSchedule (day $offset): $err');
      }

      scheduled++;
    }
  }

  Future<void> showHabitReminderNotification({
    required String name,
    required int id,
  }) async {
    if (!_enabled) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _reminderChannelId,
      _reminderChannelName,
      channelDescription: 'Recordatorios de hábitos',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'notification_icon',
    );

    const iosDetails = DarwinNotificationDetails();

    await _plugin.show(
      id,
      'Recordatorio: $name',
      'Es hora de tu hábito: $name',
      const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  void cancelHabitReminder(String habitId) {
    final id = _reminderId(habitId);
    final timer = _activeTimers.remove(id);
    timer?.cancel();
    for (int day = 0; day < 7; day++) {
      final systemId = id + day * _systemIdStep;
      try {
        _plugin.cancel(systemId);
      } catch (_) {}
      unawaited(NativeAlarmService.cancel(systemId));
    }
  }

  void _cancelAllTimers() {
    for (final timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();
  }

  int _reminderId(String habitId) {
    return _reminderIdOffset + habitId.hashCode.abs() % 1000;
  }

  DateTime? _nextValidDate({
    required DateTime from,
    required int hour,
    required int minute,
    required List<int> weekdays,
  }) {
    var candidate = DateTime(from.year, from.month, from.day, hour, minute);
    if (candidate.isBefore(from)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    for (var i = 0; i < 31; i++) {
      if (weekdays.contains(candidate.weekday)) {
        return candidate;
      }
      candidate = candidate.add(const Duration(days: 1));
    }
    return null;
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }
}
