import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/ads_service.dart';
import '../services/notification_service.dart';
import '../services/sound_service.dart';
import '../../features/categories/data/default_categories.dart';
import '../../features/categories/data/models/category_model.dart';
import '../../features/habits/data/models/habit_model.dart';
import '../../features/history/data/models/habit_log_model.dart';
import '../../features/timer/data/models/timer_log_model.dart';
import 'hive_boxes.dart';

class AppBootstrap {
  const AppBootstrap._();

  static Future<void> initialize() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HabitModelAdapter().typeId)) {
      Hive.registerAdapter(HabitModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HabitLogModelAdapter().typeId)) {
      Hive.registerAdapter(HabitLogModelAdapter());
    }
    if (!Hive.isAdapterRegistered(TimerLogModelAdapter().typeId)) {
      Hive.registerAdapter(TimerLogModelAdapter());
    }

    await Future.wait([
      Hive.openBox<CategoryModel>(HiveBoxes.categories),
      Hive.openBox<HabitModel>(HiveBoxes.habits),
      Hive.openBox<HabitLogModel>(HiveBoxes.habitLogs),
      Hive.openBox<TimerLogModel>(HiveBoxes.timerLogs),
      Hive.openBox<dynamic>(HiveBoxes.settings),
    ]);

    await _seedDefaultCategories();
    await NotificationServiceHolder.instance.initialize();
    try {
      await AdsServiceHolder.instance.initialize();
    } catch (err) {
      debugPrint('[Habio] Error inicializando AdMob: $err');
    }

    SoundServiceHolder.instance;
  }

  static void rescheduleHabitReminders() {
    _rescheduleHabitReminders();
  }

  static Future<void> _seedDefaultCategories() async {
    final box = Hive.box<CategoryModel>(HiveBoxes.categories);
    if (box.isNotEmpty) {
      return;
    }

    final defaultCategories = buildDefaultCategories();
    await box.putAll({
      for (final category in defaultCategories) category.id: category,
    });
  }

  static void _rescheduleHabitReminders() {
    final habitsBox = Hive.box<HabitModel>(HiveBoxes.habits);
    final notificationService = NotificationServiceHolder.instance;

    for (final habit in habitsBox.values) {
      if (habit.isActive && habit.reminderMinutes != null) {
        notificationService.scheduleHabitReminder(
          habitId: habit.id,
          name: habit.name,
          reminderMinutes: habit.reminderMinutes!,
          reminderIntervalMinutes: habit.reminderIntervalMinutes,
          timesPerDay: habit.timesPerDay,
          selectedWeekdays: habit.selectedWeekdays,
        );
      }
    }
  }
}
