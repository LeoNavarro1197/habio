import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/notification_service.dart';
import 'core/storage/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.initialize();
  runApp(const ProviderScope(child: HabioApp()));

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    AppBootstrap.rescheduleHabitReminders();
    await NotificationServiceHolder.instance.requestPermissions();
  });
}
