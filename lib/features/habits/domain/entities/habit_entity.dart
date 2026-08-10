class HabitEntity {
  const HabitEntity({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.selectedWeekdays,
    required this.isActive,
    required this.createdAt,
    this.reminderMinutes,
    this.reminderIntervalMinutes,
    this.durationMinutes,
    this.timesPerDay = 1,
    this.deletedAt,
    this.deactivatedAt,
  });

  final String id;
  final String name;
  final String categoryId;
  final List<int> selectedWeekdays;
  final int? reminderMinutes;
  final int? reminderIntervalMinutes;
  final int? durationMinutes;
  final int timesPerDay;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final DateTime? deactivatedAt;

  HabitEntity copyWith({
    String? id,
    String? name,
    String? categoryId,
    List<int>? selectedWeekdays,
    int? reminderMinutes,
    int? reminderIntervalMinutes,
    int? durationMinutes,
    int? timesPerDay,
    bool? isActive,
    DateTime? createdAt,
    DateTime? deletedAt,
    DateTime? deactivatedAt,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      selectedWeekdays: selectedWeekdays ?? this.selectedWeekdays,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      reminderIntervalMinutes:
          reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deactivatedAt: deactivatedAt ?? this.deactivatedAt,
    );
  }

  bool isScheduledFor(DateTime date) {
    return selectedWeekdays.contains(date.weekday);
  }
}
