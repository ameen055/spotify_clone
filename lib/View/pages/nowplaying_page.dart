import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_flutter/Data/services/audio_service.dart';
import '../../Controller/bloc/player/player_bloc.dart';
import '../../Controller/bloc/player/player_event.dart';
import '../../Controller/bloc/player/player_state.dart';
import '../../Data/model/audios_model.dart';

class NowPlayingScreen extends StatefulWidget {
  final List<Audios> playlist;
  final int startIndex;

  const NowPlayingScreen({
    super.key,
    required this.playlist,
    required this.startIndex, required Audios audio,
  });

  @override
  NowPlayingScreenState createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
  final audioService = AudioService(); // shared service

  @override
  void initState() {
    super.initState();
    // set playlist when opening Now Playing screen
    audioService.setPlaylist(widget.playlist, startIndex: widget.startIndex);
    context.read<AudioBloc>().add(PlayAudio(widget.playlist[widget.startIndex]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Now Playing",
          style: TextStyle(fontFamily: 'Satoshi', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cover image
                BlocBuilder<AudioBloc, AudioState>(
                  builder: (context, state) {
                    if (state is AudioPlaying) {
                      return Image.network(
                        state.song.coverUrl,
                        fit: BoxFit.cover,
                      );
                    } else if (state is AudioPaused) {
                      return Image.network(
                        state.song.coverUrl,
                        fit: BoxFit.cover,
                      );
                    } else {
                      final currentSong = audioService.currentSong;
                      if (currentSong != null) {
                        return Image.network(
                          currentSong.coverUrl,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const Icon(Icons.music_note, size: 100); // fallback if no song at all
                      }
                    }
                  },
                ),



                const SizedBox(height: 30),

                // Title & Artist
                BlocBuilder<AudioBloc, AudioState>(
                  builder: (context, state) {
                    if (state is AudioPlaying || state is AudioPaused) {
                      final song = (state is AudioPlaying)
                          ? state.song
                          : (state as AudioPaused).song;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              song.title,
                              style: const TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            song.artist,
                            style: const TextStyle(
                              fontFamily: 'Satoshi',
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 35),

                // Slider & Duration (static for now)
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Slider(
                        value: 30,
                        min: 0,
                        max: 100,
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "0:00",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            "3:45", // TODO: replace with real duration
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.repeat),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AudioBloc>().add(PreviousAudio());
                      },
                      icon: const FaIcon(FontAwesomeIcons.backward),
                    ),

                    // Play / Pause Button
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xf0000000),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: BlocBuilder<AudioBloc, AudioState>(
                        builder: (context, state) {
                          bool playing = false;
                          if (state is AudioPlaying) playing = true;

                          return IconButton(
                            icon: FaIcon(
                              playing
                                  ? FontAwesomeIcons.pause
                                  : FontAwesomeIcons.play,
                              color: const Color(0xffffffff),
                            ),
                            onPressed: () {
                              if (playing) {
                                context.read<AudioBloc>().add(PauseAudio());
                              } else if (state is AudioPaused) {
                                context.read<AudioBloc>().add(ResumeAudio());
                              } else if (state is AudioInitial ||
                                  state is AudioStopped) {
                                context.read<AudioBloc>().add(
                                    PlayAudio(widget.playlist[widget.startIndex]));
                              }
                            },
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AudioBloc>().add(NextAudio());
                      },
                      icon: const FaIcon(FontAwesomeIcons.forward),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.shuffle),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Lyrics section
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.keyboard_arrow_up_outlined),
                    Text(
                      "Lyrics",
                      style: TextStyle(fontFamily: 'Satoshi', fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
