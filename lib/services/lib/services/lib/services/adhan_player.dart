import 'package:audioplayers/audioplayers.dart';
import '../utils/constants.dart';

class AdhanPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playAdhan(String prayer) async {
    await _player.play(AssetSource('adhan/${prayer}_adhan.mp3'));  // Assets سے
  }

  void stop() => _player.stop();
}
