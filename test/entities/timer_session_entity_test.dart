import 'package:flutter_test/flutter_test.dart';
import 'package:habio/features/timer/domain/entities/timer_session_entity.dart';

void main() {
  group('TimerSessionState', () {
    test('default state has correct values', () {
      const state = TimerSessionState();
      expect(state.activityName, 'Sesión de enfoque');
      expect(state.durationMinutes, 25);
      expect(state.remainingSeconds, 1500);
      expect(state.status, TimerStatus.idle);
    });

    test('totalSeconds is derived from durationMinutes', () {
      const state = TimerSessionState(durationMinutes: 5);
      expect(state.totalSeconds, 300);
    });

    test('progress returns 0 when totalSeconds is 0', () {
      const state = TimerSessionState(durationMinutes: 0, remainingSeconds: 0);
      expect(state.progress, 0);
    });

    test('progress increases as remaining decreases', () {
      const idle = TimerSessionState(durationMinutes: 10, remainingSeconds: 600);
      expect(idle.progress, 0);

      const half = TimerSessionState(durationMinutes: 10, remainingSeconds: 300);
      expect(half.progress, 0.5);

      const done = TimerSessionState(durationMinutes: 10, remainingSeconds: 0);
      expect(done.progress, 1.0);
    });

    test('canEditDuration returns true when idle or completed', () {
      const idle = TimerSessionState(status: TimerStatus.idle);
      expect(idle.canEditDuration, isTrue);

      const completed = TimerSessionState(status: TimerStatus.completed);
      expect(completed.canEditDuration, isTrue);
    });

    test('canEditDuration returns false when running or paused', () {
      const running = TimerSessionState(status: TimerStatus.running);
      expect(running.canEditDuration, isFalse);

      const paused = TimerSessionState(status: TimerStatus.paused);
      expect(paused.canEditDuration, isFalse);
    });

    test('isRunning, isPaused, isCompleted helpers', () {
      expect(const TimerSessionState(status: TimerStatus.running).isRunning, isTrue);
      expect(const TimerSessionState(status: TimerStatus.paused).isPaused, isTrue);
      expect(const TimerSessionState(status: TimerStatus.completed).isCompleted, isTrue);
    });

    test('copyWith overrides specified fields', () {
      const state = TimerSessionState();
      final copy = state.copyWith(activityName: 'Meditar', status: TimerStatus.running);
      expect(copy.activityName, 'Meditar');
      expect(copy.status, TimerStatus.running);
      expect(copy.durationMinutes, 25);
    });

    test('static presets are defined', () {
      expect(TimerSessionState.durationPresets, [5, 15, 25, 45]);
      expect(TimerSessionState.defaultDurationMinutes, 25);
    });
  });
}
