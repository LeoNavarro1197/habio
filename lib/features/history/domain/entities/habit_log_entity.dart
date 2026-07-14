class HabitLogEntity {
  const HabitLogEntity({
    required this.id,
    required this.habitId,
    required this.date,
    required this.isCompleted,
    this.completedAt,
  });

  final String id;
  final String habitId;
  final DateTime date;
  final bool isCompleted;
  final DateTime? completedAt;

  HabitLogEntity copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return HabitLogEntity(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
