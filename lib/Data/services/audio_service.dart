import 'package:just_audio/just_audio.dart';
import '../model/audios_model.dart';

class AudioService {
  // AudioService is a singleton class , below following 3 lines is the makes a singleton class
  // or copy paste the following three lines to convert a class to singleton class
  AudioService._internal();
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  Audios? _currentSong;

  Audios? get currentSong => _currentSong;
  bool get isPlaying => _player.playing;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> playSong(Audios song) async {
    if (_currentSong?.id != song.id) {
      await _player.stop();
      await _player.setUrl(song.url);
      _currentSong = song;
    }
    _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
    _currentSong = null;
  }
}
