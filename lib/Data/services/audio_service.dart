import 'package:just_audio/just_audio.dart';
import '../model/audios_model.dart';

class AudioService {
  // Singleton: same instance everywhere
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  Audios? _currentSong;

  // Getters so UI can read state
  AudioPlayer get player => _player;
  Audios? get currentSong => _currentSong;
  bool get isPlaying => _player.playing;

  // Play a song
  Future<void> playSong(Audios audio) async {
    if (_currentSong?.id == audio.id && _player.playing) {
      return; // already playing same song
    }
    _currentSong = audio;
    await _player.setUrl(audio.url); // your model must have audioUrl
    await _player.play();
  }

  // --- Pause
  Future<void> pause() async {
    await _player.pause();
  }

  // --- Stop
  Future<void> stop() async {
    await _player.stop();
    _currentSong = null;
  }
}
