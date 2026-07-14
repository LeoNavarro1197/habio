import 'package:flutter_test/flutter_test.dart';
import 'package:habio/core/services/notification_service.dart';
import 'package:habio/features/timer/domain/entities/timer_session_entity.dart';
import 'package:habio/features/timer/domain/repositories/timer_log_repository.dart';
import 'package:habio/features/timer/presentation/providers/timer_providers.dart';
import 'package:habio/features/timer/domain/entities/timer_log_entity.dart';

class _MockNotificationService extends NotificationService {
  bool permissionsRequested = false;

  @override
  Future<void> requestPermissions() async {
    permissionsRequested = true;
  }

  @override
  Future<void> showTimerCompletedNotification({required String activityName}) async {}
}

class _MockTimerLogRepository implements TimerLogRepository {
  final logs = <TimerLogEntity>[];

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<TimerLogEntity>> getLogsForRange(DateTime start, DateTime end) async {
    return logs.toList();
  }

  @override
  Future<void> save(TimerLogEntity log) async {
    logs.add(log);
  }

  @override
  Stream<List<TimerLogEntity>> watchLogsForRange(DateTime start, DateTime end) {
    return Stream.value(logs.toList());
  }
}

void main() {
  group('TimerController', () {
    late _MockNotificationService mockNotification;
    late _MockTimerLogRepository mockLogRepo;
    late TimerController controller;

    setUp(() {
      mockNotification = _MockNotificationService();
      mockLogRepo = _MockTimerLogRepository();
      controller = TimerController(
        notificationService: mockNotification,
        notificationsEnabled: () => true,
        timerLogRepository: mockLogRepo,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state is idle with default values', () {
      expect(controller.state.status, TimerStatus.idle);
      expect(controller.state.durationMinutes, 25);
      expect(controller.state.remainingSeconds, 1500);
      expect(controller.state.activityName, 'Sesión de enfoque');
    });

    test('setActivityName updates name', () {
      controller.setActivityName('Meditar');
      expect(controller.state.activityName, 'Meditar');
    });

    test('setDurationMinutes updates duration when idle', () {
      controller.setDurationMinutes(15);
      expect(controller.state.durationMinutes, 15);
      expect(controller.state.remainingSeconds, 900);
      expect(controller.state.status, TimerStatus.idle);
    });

    test('setDurationMinutes is ignored when running', () async {
      controller.setDurationMinutes(45);
      await controller.start();
      controller.setDurationMinutes(5);
      expect(controller.state.durationMinutes, 45);
    });

    test('start transitions to running', () async {
      await controller.start();
      expect(controller.state.status, TimerStatus.running);
    });

    test('start requests permissions', () async {
      await controller.start();
      expect(mockNotification.permissionsRequested, isTrue);
    });

    test('pause transitions to paused', () async {
      await controller.start();
      controller.pause();
      expect(controller.state.status, TimerStatus.paused);
    });

    test('pause is ignored when not running', () {
      controller.pause();
      expect(controller.state.status, TimerStatus.idle);
    });

    test('reset returns to idle with full seconds', () async {
      controller.setDurationMinutes(5);
      await controller.start();
      controller.reset();
      expect(controller.state.status, TimerStatus.idle);
      expect(controller.state.remainingSeconds, 300);
    });

    test('canEditDuration is true before start', () {
      expect(controller.state.canEditDuration, isTrue);
    });

    test('canEditDuration is false while running', () async {
      await controller.start();
      expect(controller.state.canEditDuration, isFalse);
    });

    test('canEditDuration is true after reset', () async {
      await controller.start();
      controller.reset();
      expect(controller.state.canEditDuration, isTrue);
    });
  });
}
