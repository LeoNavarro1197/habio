enum TimerStatus {
  idle,
  running,
  paused,
  completed,
}

class TimerSessionState {
  const TimerSessionState({
     this.activityName = '',
    this.durationMinutes = 25,
    this.totalSeconds = 25 * 60,
    this.remainingSeconds = 25 * 60,
    this.status = TimerStatus.idle,
  });

  static const defaultDurationMinutes = 25;
  static const durationPresets = [5, 15, 25, 45, 60];

  final String activityName;
  final int durationMinutes;
  final int totalSeconds;
  final int remainingSeconds;
  final TimerStatus status;

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
    int? totalSeconds,
    int? remainingSeconds,
    TimerStatus? status,
  }) {
    return TimerSessionState(
      activityName: activityName ?? this.activityName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
    );
  }
}
