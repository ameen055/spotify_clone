import 'package:bloc/bloc.dart';
import 'package:study_flutter/Controller/bloc/player/player_event.dart';
import 'package:study_flutter/Controller/bloc/player/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerInitial()) {
    on<PlayEvent>((event, emit) {
      emit(PlayerPlaying());
    });

    on<PauseEvent>((event, emit) {
      emit(PlayerPaused());
    });
  }
}
