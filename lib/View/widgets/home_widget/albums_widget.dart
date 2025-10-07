import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;

import '../../../Data/model/audios_model.dart';
import '../../../Data/services/audio_service.dart';
import '../../pages/nowplaying_page.dart';
import '../loading_widget.dart';

class AlbumWidget extends StatefulWidget {
  const AlbumWidget({super.key});

  @override
  State<AlbumWidget> createState() => _AlbumWidgetState();
}

class _AlbumWidgetState extends State<AlbumWidget> {
  final audioService = AudioService(); // shared audio service
  late Future<List<Audios>> _audiosFuture;

  @override
  void initState() {
    super.initState();
    _audiosFuture = _fetchAudios();

    // listen for play/pause state changes
    audioService.playerStateStream.listen((state) {
      setState(() {}); // rebuild buttons
    });
  }

  Future<List<Audios>> _fetchAudios() async {
    final snapshot = await FirebaseFirestore.instance.collection('audios').get();
    return snapshot.docs
        .map((doc) => Audios.fromFirestore(doc.data(), docId: doc.id))
        .toList();
  }

  Future<void> _togglePlayPause(Audios song) async {
    if (audioService.currentSong?.id == song.id && audioService.isPlaying) {
      await audioService.pause();
    } else {
      await audioService.playSong(song);
    }
    setState(() {}); // refresh play/pause icon
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
                fontFamily: "Satoshi",
                fontWeight: FontWeight.w700,
                color: Color(0xff222222),
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 170,
            child: FutureBuilder<List<Audios>>(
              future: _audiosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AlbumShimmer();
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
                    final isCurrent = audioService.currentSong?.id == song.id;
                    final isPlaying = audioService.isPlaying && isCurrent;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NowPlayingScreen(
                                  audio: song,
                                  playlist: audios,   // pass the current list from snapshot
                                  startIndex: index,
                                ),
                              ),
                            );

                          },
                        child: Container(
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
                                  onTap: () => _togglePlayPause(song),
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
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
