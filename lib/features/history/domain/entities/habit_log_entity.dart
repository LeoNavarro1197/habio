class HabitLogEntity {
  const HabitLogEntity({
    required this.id,
    required this.habitId,
    required this.date,
    required this.isCompleted,
    this.completedAt,
    this.habitName,
  });

  final String id;
  final String habitId;
  final DateTime date;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? habitName;

  HabitLogEntity copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    bool? isCompleted,
    DateTime? completedAt,
    String? habitName,
  }) {
    return HabitLogEntity(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      habitName: habitName ?? this.habitName,
    );
  }
}
