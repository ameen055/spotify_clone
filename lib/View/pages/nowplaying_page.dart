import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_flutter/Data/services/audio_service.dart';
import '../../Data/model/audios_model.dart';

class NowPlayingScreen extends StatefulWidget {
  final Audios audio;
  const NowPlayingScreen({super.key, required this.audio});

  @override
  NowPlayingScreenState createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
  final audioService = AudioService(); //  shared service

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
                //  Cover image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(widget.audio.coverUrl),
                ),
                const SizedBox(height: 30),

                //  Title & Artist
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.audio.title,
                        style: const TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.audio.artist,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                //  Slider & Duration (static for now)
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
                        children: [
                          const Text(
                            "0:00",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            widget.audio.duration, // from Firestore
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                //  Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.repeat),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.backward),
                    ),

                    //  Play / Pause Button
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xf0000000),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: StreamBuilder(
                        stream: audioService.playerStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          final playing = state?.playing ?? false;

                          return IconButton(
                            icon: FaIcon(
                              playing
                                  ? FontAwesomeIcons.pause
                                  : FontAwesomeIcons.play,
                              color: const Color(0xffffffff),
                            ),
                            onPressed: () {
                              if (playing) {
                                audioService.pause();
                              } else {
                                audioService.playSong(widget.audio);
                              }
                            },
                          );
                        },
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.forward),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const FaIcon(FontAwesomeIcons.shuffle),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                //  Lyrics section
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
