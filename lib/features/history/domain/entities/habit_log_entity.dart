class HabitLogEntity {
  const HabitLogEntity({
    required this.id,
    required this.habitId,
    required this.date,
    required this.isCompleted,
    this.completedAt,
    this.habitName,
    this.durationMinutes,
    this.completedCount = 0,
    this.timesPerDay = 1,
  });

  final String id;
  final String habitId;
  final DateTime date;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? habitName;
  final int? durationMinutes;
  final int completedCount;
  final int timesPerDay;

  bool get isFullyCompleted => isCompleted || completedCount >= timesPerDay;

  HabitLogEntity copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    bool? isCompleted,
    DateTime? completedAt,
    String? habitName,
    int? durationMinutes,
    int? completedCount,
    int? timesPerDay,
  }) {
    return HabitLogEntity(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      habitName: habitName ?? this.habitName,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completedCount: completedCount ?? this.completedCount,
      timesPerDay: timesPerDay ?? this.timesPerDay,
    );
  }
}
