import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../Data/model/audios_model.dart';

class AlbumWidget extends StatefulWidget {
  const AlbumWidget({super.key});

  @override
  State<AlbumWidget> createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  final Map<String, AudioPlayer> _players = {};
  String? _currentUrl;
  String? _toPlayUrl;

  // Static cache so it persists even if widget is rebuilt
  static List<Audios> _cachedAudios = [];
  static bool _hasLoaded = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (!_hasLoaded) {
      _isLoading = true;
      _fetchAndPreloadAudios();
    }
  }

  Future<void> _fetchAndPreloadAudios() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('audios').get();

      final audios = snapshot.docs
          .map((doc) => Audios.fromFirestore(doc.data(), docId: ''))
          .toList();

      for (var song in audios) {
        if (!_players.containsKey(song.url)) {
          final player = AudioPlayer();
          try {
            await player.setUrl(song.url);
            _players[song.url] = player;
          } catch (e) {
            print("Failed to preload ${song.url}: $e");
          }
        }
      }

      setState(() {
        _cachedAudios = audios;
        _hasLoaded = true;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching audios: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _togglePlayPause(String url) async {
    final player = _players[url];
    if (player == null) return;

    if (_currentUrl == url && player.playing) {
      await player.pause();
      setState(() => _toPlayUrl = null);
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

      try {
        if (player.processingState == ProcessingState.idle) {
          await player.setUrl(url);
        }
        await player.play();
      } catch (e) {
        print("Play error: $e");
        setState(() => _toPlayUrl = null);
      }
    }
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _cachedAudios.isEmpty
              ? const Center(child: Text("No songs found"))
              : ListView.separated(
            padding: const EdgeInsets.only(left: 32.0),
            scrollDirection: Axis.horizontal,
            itemCount: _cachedAudios.length,
            separatorBuilder: (context, index) =>
            const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final song = _cachedAudios[index];
              final isPlaying = _toPlayUrl == song.url;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return Container(
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                      Icons.broken_image),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: InkWell(
                              onTap: () =>
                                  _togglePlayPause(song.url),
                              child: Container(
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
                                  color: const Color(0xff000000),
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
          ),
        ),
      ],
    );
  }
}
