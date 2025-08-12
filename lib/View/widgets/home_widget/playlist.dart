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
    final snapshot = await FirebaseFirestore.instance.collection('audios').get();
    return snapshot.docs.map((doc) => Audios.fromFirestore(doc.data())).toList();
  }

  Future<void> _togglePlayPause(String url) async {
    if (_currentUrl == url && _player.playing) {
      // Stop fully to release resources and avoid mute spam
      await _player.stop();
      _currentUrl = null;
    } else {
      if (_currentUrl != url) {
        await _player.stop(); // Ensure previous audio is stopped
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
      if (state.processingState == ProcessingState.completed) {
        _player.stop();
        _currentUrl = null;
        setState(() {});
      }
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
        const Padding(
          padding: EdgeInsets.only(left: 32.0, top: 8.0),
          child: Text(
            "Playlist",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff222222)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 400,
          width: 500,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: FutureBuilder<List<Audios>>(
              future: fetchAudios(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No songs found"));
                }

                final audios = snapshot.data!;
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: audios.length,
                  itemBuilder: (context, index) {
                    final song = audios[index];

                    return Center(
                      child: Container(
                        height: 70,
                        width: 360,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(17),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(image: NetworkImage(song.coverUrl), fit: BoxFit.cover),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _currentUrl == song.url && _player.playing
                                      ? Icons.pause
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onPressed: () => _togglePlayPause(song.url),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                song.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(song.duration, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 25),
                            const Icon(Icons.favorite_outline_outlined, color: Color(0xffb4b4b4)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
