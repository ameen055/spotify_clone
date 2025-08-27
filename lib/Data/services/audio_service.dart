import 'package:just_audio/just_audio.dart';
import '../model/audios_model.dart';

class AudioService {
  // Singleton: same instance everywhere
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  Audios? _currentSong;
  List<Audios> _playlist = [];
  int _currentIndex = -1;

  // Getters so UI can read state
  AudioPlayer get player => _player;
  Audios? get currentSong => _currentSong;
  bool get isPlaying => _player.playing;
  List<Audios> get playlist => _playlist;
  int get currentIndex => _currentIndex;

  // Initialize playlist
  void setPlaylist(List<Audios> playlist, {int startIndex = 0}) {
    _playlist = playlist;
    _currentIndex = startIndex;
    if (_playlist.isNotEmpty && startIndex < _playlist.length) {
      playSong(_playlist[startIndex]);
    }
  }

  // Play a song
  Future<void> playSong(Audios audio) async {
    if (_currentSong?.id == audio.id && _player.playing) {
      return; // already playing same song
    }
    _currentSong = audio;
    _currentIndex = _playlist.indexWhere((song) => song.id == audio.id);
    await _player.setUrl(audio.url);
    await _player.play();
  }

  // Play next song
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;

    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await playSong(_playlist[_currentIndex]);
  }

  // Play previous song
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;

    _currentIndex = (_currentIndex - 1) % _playlist.length;
    if (_currentIndex < 0) _currentIndex = _playlist.length - 1;
    await playSong(_playlist[_currentIndex]);
  }

  // --- Pause
  Future<void> pause() async {
    await _player.pause();
  }

  // --- Resume
  Future<void> resume() async {
    if (_currentSong != null) {
      await _player.play();
    }
  }

  // --- Stop
  Future<void> stop() async {
    await _player.stop();
    _currentSong = null;
    _currentIndex = -1;
  }

  // Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await pause();
    } else {
      if (_currentSong != null) {
        await resume();
      }
    }
  }

  // Dispose
  void dispose() {
    _player.dispose();
  }
}