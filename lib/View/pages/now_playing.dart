import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Data/model/audios_model.dart';

class NowPlayingScreen extends StatefulWidget {
  final Audios audio;
  const NowPlayingScreen({super.key, required this.audio});

  @override
  NowPlayingScreenState createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
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
                // Cover image the image of the currently playing
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(widget.audio.coverUrl),
                ),
                const SizedBox(height: 30),

                // Title & Artist
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.audio.title,
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.audio.artist,
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                // Slider & Time - which shows the progress of the song and the time
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
                          Text("0:00", style: TextStyle(color: Colors.grey)),
                          Text("3:45", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.repeat),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.backward),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff42c933),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: IconButton(
                        onPressed: () {},
                        icon: FaIcon(FontAwesomeIcons.play),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.forward),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.shuffle),
                    ),
                  ],
                ),
                SizedBox(height: 28),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.keyboard_arrow_up_outlined),
                    Text(
                      "Lyrics",
                      style: TextStyle(fontFamily: 'Satoshi', fontSize: 14),
                    ),
                  ],
                ),
              ]  ,
            ),
          ),
        ],
      ),
    );
  }
}
