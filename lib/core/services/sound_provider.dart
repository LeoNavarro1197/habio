import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sound_service.dart';

final soundServiceProvider = Provider<SoundService>((ref) {
  final service = SoundServiceHolder.instance;
  ref.onDispose(() => service.dispose());
  return service;
});
