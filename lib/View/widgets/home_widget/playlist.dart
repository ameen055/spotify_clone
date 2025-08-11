import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../Data/model/audios_model.dart';

class PlayListsWidget extends StatefulWidget {
  const PlayListsWidget({super.key});

  @override
  _PlayListsWidgetState createState() => _PlayListsWidgetState();
}

class _PlayListsWidgetState extends State<PlayListsWidget> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;

  Future<List<Audios>> fetchAudios() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('audios')
        .get();

    print('doc fetched');
    return snapshot.docs.map((doc) {
      return Audios.fromFirestore(doc.data());
    }).toList();
  }

  Future<void> _tooglePlayPause(String url) async {
    if (_currentUrl == url && _player.playing) {
      await _player.pause();
    } else {
      if (_currentUrl != url) {
        await _player.setUrl(url);
        _currentUrl = url;
      }
      await _player.play();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _player.playerStateStream.listen((state) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 32.0, top: 8.0),
          child: Text(
            "Playlist",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff222222),
            ),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 400,
          width: 500,
          child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: FutureBuilder(
              future: fetchAudios(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("no songs found"));
                }
                final audios = snapshot.data!;
                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 0),
                    itemCount: audios.length,
                    itemBuilder: (context, index) {
                      final song = audios[index];

                      // This code safely extracts and cleans up the actual file name from the long Firebase download URL.
                      // It allows you to display just the song name in your UI instead of showing a long link.
                      final audiosTitle = audios[index].title;
                      final audiosDuration = audios[index].duration;
                      final audiosCoverUrl = audios[index].coverUrl;

                      return Center(
                        child: Container(
                          height: 70,
                          width: 360,
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 6, right: 6),
                                width: 50, // control circle size
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(audiosCoverUrl),
                                  ),
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      color: Color(0xffffffff),
                                      size: 25,
                                      _currentUrl == song.url && _player.playing
                                          ? Icons.pause
                                          : Icons.play_arrow_rounded,
                                    ),
                                    onPressed: () {
                                      _tooglePlayPause(audios[index].url);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  audiosTitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                audiosDuration,
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(width: 25),
                              Icon(
                                Icons.favorite_outline_outlined,
                                color: Color(0xffb4b4b4),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
