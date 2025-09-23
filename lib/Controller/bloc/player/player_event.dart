import '../../../Data/model/audios_model.dart';

abstract class AudioEvent {}

class PlayAudio extends AudioEvent {
  final Audios song;
  PlayAudio(this.song);
}

class PauseAudio extends AudioEvent {}

class ResumeAudio extends AudioEvent {}

class StopAudio extends AudioEvent {}
