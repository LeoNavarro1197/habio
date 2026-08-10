import 'package:audioplayers/audioplayers.dart';

class SoundServiceHolder {
  static final SoundService instance = SoundService._();
}

class SoundService {
  SoundService._();

  final _click = AudioPlayer();
  final _complete = AudioPlayer();

  Future<void> playClick() async {
    await _click.stop();
    await _click.play(AssetSource('sounds/click.wav'));
  }

  Future<void> playComplete() async {
    await _complete.stop();
    await _complete.play(AssetSource('sounds/complete.wav'));
  }

  void dispose() {
    _click.dispose();
    _complete.dispose();
  }
}
