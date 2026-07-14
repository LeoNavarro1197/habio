import 'package:hive/hive.dart';

import '../../../../core/utils/stream_extensions.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../models/habit_model.dart';

class HiveHabitRepository implements HabitRepository {
  HiveHabitRepository(this._box);

  final Box<HabitModel> _box;

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<HabitEntity>> getAll() async {
    return _sorted(_box.values).map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<HabitEntity>> getHabitsForDate(DateTime date) async {
    return _forDate(date, _box.values).map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> save(HabitEntity habit) async {
    await _box.put(habit.id, HabitModel.fromEntity(habit));
  }

  @override
  Stream<List<HabitEntity>> watchAll() {
    return _box.watch().map((_) {
      return _sorted(_box.values).map((model) => model.toEntity()).toList();
    }).startWith(_sorted(_box.values).map((model) => model.toEntity()).toList());
  }

  @override
  Stream<List<HabitEntity>> watchHabitsForDate(DateTime date) {
    return _box.watch().map((_) {
      return _forDate(date, _box.values).map((model) => model.toEntity()).toList();
    }).startWith(
      _forDate(date, _box.values).map((model) => model.toEntity()).toList(),
    );
  }

  List<HabitModel> _forDate(DateTime date, Iterable<HabitModel> items) {
    return _sorted(
      items.where(
        (item) => item.selectedWeekdays.contains(date.weekday),
      ),
    );
  }

  List<HabitModel> _sorted(Iterable<HabitModel> items) {
    final list = items.toList();
    list.sort((left, right) => left.createdAt.compareTo(right.createdAt));
    return list;
  }
}
