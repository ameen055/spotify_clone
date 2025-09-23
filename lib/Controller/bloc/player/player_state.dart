import '../../../Data/model/audios_model.dart';

abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioPlaying extends AudioState {
  final Audios song;
  AudioPlaying(this.song);
}

class AudioPaused extends AudioState {
  final Audios song;
  AudioPaused(this.song);
}

class AudioStopped extends AudioState {}
