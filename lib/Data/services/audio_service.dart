import 'dart:async';
import 'package:just_audio/just_audio.dart';
import '../model/audios_model.dart';
import '../../Controller/bloc/player/player_state.dart';

class AudioService {
  List<Audios> playlist = [];
  int currentIndex = 0;

  AudioService._internal();
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  Audios? _currentSong;

  final _audioStateController = StreamController<AudioState>.broadcast();
  Stream<AudioState> get audioStateStream => _audioStateController.stream;

  Audios? get currentSong => _currentSong;
  bool get isPlaying => _player.playing;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// Set playlist and optionally start from a specific index
  Future<void> setPlaylist(List<Audios> songs, {int startIndex = 0}) async {
    playlist = songs;
    currentIndex = startIndex;
    if (playlist.isNotEmpty) {
      await playSong(playlist[currentIndex]);
    }
  }

  Future<void> playSong(Audios song) async {
    currentIndex = playlist.indexWhere((s) => s.id == song.id);
    if (_currentSong?.id != song.id) {
      await _player.stop();
      await _player.setUrl(song.url);
      _currentSong = song;
    }
    _player.play();
    _audioStateController.add(AudioPlaying(song));
  }

  Future<void> pause() async {
    await _player.pause();
    if (_currentSong != null) {
      _audioStateController.add(AudioPaused(_currentSong!));
    }
  }

  Future<void> resume() async {
    await _player.play();
    if (_currentSong != null) {
      _audioStateController.add(AudioPlaying(_currentSong!));
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _currentSong = null;
    _audioStateController.add(AudioStopped());
  }

  Future<Audios?> next() async {
    if (currentIndex < playlist.length - 1) {
      currentIndex++;
      final nextSong = playlist[currentIndex];
      await playSong(nextSong);
      _audioStateController.add(AudioNext(nextSong));
      return nextSong;
    }
    print("No next song available");
    return null;
  }

  Future<Audios?> previous() async {
    if (currentIndex > 0) {
      currentIndex--;
      final prevSong = playlist[currentIndex];
      await playSong(prevSong);
      _audioStateController.add(AudioPrevious(prevSong));
      return prevSong;
    }
    print("No previous song available");
    return null;
  }
}
