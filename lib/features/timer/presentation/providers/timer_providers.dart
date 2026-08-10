import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/storage/hive_boxes.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/models/timer_log_model.dart';
import '../../data/repositories/hive_timer_log_repository.dart';
import '../../domain/entities/timer_log_entity.dart';
import '../../domain/entities/timer_session_entity.dart';
import '../../domain/repositories/timer_log_repository.dart';

final timerControllerProvider =
    StateNotifierProvider<TimerController, TimerSessionState>((ref) {
  return TimerController(
    notificationService: ref.watch(notificationServiceProvider),
    notificationsEnabled: () =>
        ref.read(settingsControllerProvider).notificationsEnabled,
    timerLogRepository:
        HiveTimerLogRepository(Hive.box<TimerLogModel>(HiveBoxes.timerLogs)),
  );
});

class TimerController extends StateNotifier<TimerSessionState> {
  TimerController({
    required NotificationService notificationService,
    required bool Function() notificationsEnabled,
    required TimerLogRepository timerLogRepository,
  })  : _notificationService = notificationService,
        _notificationsEnabled = notificationsEnabled,
        _timerLogRepository = timerLogRepository,
        super(const TimerSessionState());

  final NotificationService _notificationService;
  final bool Function() _notificationsEnabled;
  final TimerLogRepository _timerLogRepository;

  Timer? _ticker;

  void setActivityName(String name) {
    state = state.copyWith(activityName: name);
  }

  void setDurationMinutes(int minutes) {
    if (!state.canEditDuration) {
      return;
    }

    state = state.copyWith(
      durationMinutes: minutes,
      totalSeconds: minutes * 60,
      remainingSeconds: minutes * 60,
      status: TimerStatus.idle,
    );
  }

  void setCustomDuration(int totalSeconds) {
    if (!state.canEditDuration) return;
    state = state.copyWith(
      durationMinutes: (totalSeconds / 60).ceil(),
      totalSeconds: totalSeconds,
      remainingSeconds: totalSeconds,
      status: TimerStatus.idle,
    );
  }

  Future<void> start() async {
    if (state.isRunning) {
      return;
    }

    if (state.remainingSeconds <= 0) {
      state = state.copyWith(
        remainingSeconds: state.totalSeconds,
        status: TimerStatus.idle,
      );
    }

    if (_notificationsEnabled()) {
      await _notificationService.requestPermissions();
    }

    _startTicker();
    state = state.copyWith(status: TimerStatus.running);
  }

  void pause() {
    if (!state.isRunning) {
      return;
    }

    _cancelTicker();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void reset() {
    _cancelTicker();
    state = state.copyWith(
      remainingSeconds: state.totalSeconds,
      status: TimerStatus.idle,
    );
  }

  void _startTicker() {
    _cancelTicker();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (state.remainingSeconds <= 1) {
      _cancelTicker();
      state = state.copyWith(
        remainingSeconds: 0,
        status: TimerStatus.completed,
      );
      unawaited(_handleCompletion());
      return;
    }

    state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
  }

  Future<void> _handleCompletion() async {
    final log = TimerLogEntity(
      id: IdGenerator.next(),
      activityName: state.activityName,
      durationMinutes: state.durationMinutes,
      completedAt: DateTime.now(),
    );
    await _timerLogRepository.save(log);

    if (!_notificationsEnabled()) {
      return;
    }

    await _notificationService.showTimerCompletedNotification(
      activityName: state.activityName,
    );
  }

  void _cancelTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _cancelTicker();
    super.dispose();
  }
}
