import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_flutter/Controller/bloc/player/player_event.dart';
import 'package:study_flutter/Controller/bloc/player/player_state.dart';
import '../../../Data/services/audio_service.dart';
import '../../../Data/model/audios_model.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioService _audioService = AudioService();

  AudioBloc() : super(AudioInitial()) {
    // Set Playlist
    on<SetPlaylist>((event, emit) async {
      await _audioService.setPlaylist(event.songs, startIndex: event.startIndex);
      emit(AudioPlaying(event.songs[event.startIndex]));
    });

    // Play
    on<PlayAudio>((event, emit) async {
      await _audioService.playSong(event.song);
      emit(AudioPlaying(event.song));
    });

    // Pause
    on<PauseAudio>((event, emit) async {
      await _audioService.pause();
      if (state is AudioPlaying) {
        emit(AudioPaused((state as AudioPlaying).song));
      }
    });

    // Resume
    on<ResumeAudio>((event, emit) async {
      if (state is AudioPaused) {
        final song = (state as AudioPaused).song;
        await _audioService.playSong(song);
        emit(AudioPlaying(song));
      }
    });

    // Stop
    on<StopAudio>((event, emit) async {
      await _audioService.stop();
      emit(AudioStopped());
    });

    // Next
    on<NextAudio>((event, emit) async {
      final song = await _audioService.next();
      if (song != null) emit(AudioNext(song));
    });

    // Previous
    on<PreviousAudio>((event, emit) async {
      final song = await _audioService.previous();
      if (song != null) emit(AudioPrevious(song));
    });
  }
}
