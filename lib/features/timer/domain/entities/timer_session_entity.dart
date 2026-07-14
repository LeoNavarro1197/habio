enum TimerStatus {
  idle,
  running,
  paused,
  completed,
}

class TimerSessionState {
  const TimerSessionState({
    this.activityName = 'Sesión de enfoque',
    this.durationMinutes = 25,
    this.remainingSeconds = 25 * 60,
    this.status = TimerStatus.idle,
  });

  static const defaultDurationMinutes = 25;
  static const durationPresets = [5, 15, 25, 45];

  final String activityName;
  final int durationMinutes;
  final int remainingSeconds;
  final TimerStatus status;

  int get totalSeconds => durationMinutes * 60;

  double get progress {
    if (totalSeconds == 0) {
      return 0;
    }
    return 1 - (remainingSeconds / totalSeconds);
  }

  bool get canEditDuration =>
      status == TimerStatus.idle || status == TimerStatus.completed;

  bool get isRunning => status == TimerStatus.running;

  bool get isPaused => status == TimerStatus.paused;

  bool get isCompleted => status == TimerStatus.completed;

  TimerSessionState copyWith({
    String? activityName,
    int? durationMinutes,
    int? remainingSeconds,
    TimerStatus? status,
  }) {
    return TimerSessionState(
      activityName: activityName ?? this.activityName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
    );
  }
}
