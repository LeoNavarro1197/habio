import '../entities/habit_entity.dart';

abstract class HabitRepository {
  Future<List<HabitEntity>> getAll();
  Stream<List<HabitEntity>> watchAll();
  Future<List<HabitEntity>> getHabitsForDate(DateTime date);
  Stream<List<HabitEntity>> watchHabitsForDate(DateTime date);
  Future<void> save(HabitEntity habit);
  Future<void> delete(String id);
}
