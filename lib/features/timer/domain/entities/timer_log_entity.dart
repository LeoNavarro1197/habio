class TimerLogEntity {
  const TimerLogEntity({
    required this.id,
    required this.activityName,
    required this.durationMinutes,
    required this.completedAt,
  });

  final String id;
  final String activityName;
  final int durationMinutes;
  final DateTime completedAt;

  TimerLogEntity copyWith({
    String? id,
    String? activityName,
    int? durationMinutes,
    DateTime? completedAt,
  }) {
    return TimerLogEntity(
      id: id ?? this.id,
      activityName: activityName ?? this.activityName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
