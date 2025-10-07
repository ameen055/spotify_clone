import '../Data/model/audios_model.dart';

class NowPlayingArgs {
  final Audios audio;
  final List<Audios> playlist;
  final int startIndex;

  NowPlayingArgs({
    required this.audio,
    required this.playlist,
    required this.startIndex,
  });
}
