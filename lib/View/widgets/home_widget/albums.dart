import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../Data/model/audios_model.dart';

class AlbumWidget extends StatefulWidget {
  const AlbumWidget({super.key});

  @override
  _AlbumWidgetState createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  // map to hold AudioPlayer instances for each audio url
  final Map<String, AudioPlayer> _players = {};

  // it will store URL od the audio currently displayed
  String? _currentUrl;

  //it store the URL of the next audio tht should play
  String? _toPlayUrl;

  // a Future that will fetch and preload the list of audios form firestore
  late Future<List<Audios>> _futureAudios;

  //it fetch audio data form firestore and preloads them using just_audio
  Future<List<Audios>> fetchAndPreloadAudios() async {
    // Get all documents from "audios" collection in firestore
    final snapshot = await FirebaseFirestore.instance
        .collection('audios')
        .get();
    // convert each doc to an audios object using firestore
    final audios = snapshot.docs
        .map((doc) => Audios.fromFirestore(doc.data()))
        .toList();

    // for preloading the audio
    for (var song in audios) {
      if (!_players.containsKey(song.url)) {
        final player = AudioPlayer();
        try {
          await player.setUrl(song.url);
          _players[song.url] = player;
        } catch (e) {
          // if loading fails , print error
          print("Failed to preload ${song.url}: $e");
        }
      }
    }
    return audios;
  }

  Future<void> _togglePlayPause(String url) async {
    final player = _players[url];
    if (player == null) return;

    if (_currentUrl == url && player.playing) {
      await player.pause();
      setState(() {
        _toPlayUrl = null;
      });
    } else {
      for (var entry in _players.entries) {
        if (entry.key != url) {
          await entry.value.pause();
        }
      }

      setState(() {
        _currentUrl = url;
        _toPlayUrl = url;
      });

      await player.play();
    }
  }

  @override
  void initState() {
    super.initState();
    _futureAudios = fetchAndPreloadAudios();
  }

  @override
  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 32.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Albums",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff222222),
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 160,
          child: FutureBuilder<List<Audios>>(
            future: _futureAudios,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No songs found"));
              }
              final audios = snapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.only(left: 32.0),
                scrollDirection: Axis.horizontal,
                itemCount: audios.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final song = audios[index];
                  final isPlaying = _toPlayUrl == song.url;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Container
                        Container(
                          height: 120,
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 6,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  song.coverUrl,
                                  height: 120,
                                  width: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 120,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 6,
                                right: 6,
                                child: InkWell(
                                  onTap: () => _togglePlayPause(song.url),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                      bottom: 2,
                                      right: 2,
                                    ),
                                    width: 35,
                                    height: 35,
                                    decoration: const BoxDecoration(
                                      color: Color(0xff808080),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow_rounded,
                                      size: 20,
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 160,
                          child: Text(
                            song.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: Text(
                            song.artist,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
