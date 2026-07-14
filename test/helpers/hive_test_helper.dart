import 'dart:io';
import 'package:hive/hive.dart';
import 'package:habio/features/categories/data/models/category_model.dart';
import 'package:habio/features/habits/data/models/habit_model.dart';
import 'package:habio/features/history/data/models/habit_log_model.dart';
import 'package:habio/features/timer/data/models/timer_log_model.dart';

class HiveTestHelper {
  static late Directory _tempDir;

  static Future<void> init() async {
    _tempDir = Directory.systemTemp.createTempSync('hive_test_');
    Hive.init(_tempDir.path);
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(HabitModelAdapter());
    Hive.registerAdapter(HabitLogModelAdapter());
    Hive.registerAdapter(TimerLogModelAdapter());
  }

  static Future<void> cleanUp() async {
    await Hive.close();
    if (_tempDir.existsSync()) {
      _tempDir.deleteSync(recursive: true);
    }
  }
}
