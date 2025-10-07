import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rive/rive.dart';
import '../../../Data/model/audios_model.dart';
import '../../../Data/services/audio_service.dart';
import '../../pages/nowplaying_page.dart';
import '../loading_widget.dart';

class PlayListsWidget extends StatefulWidget {
  const PlayListsWidget({super.key});

  @override
  _PlayListsWidgetState createState() => _PlayListsWidgetState();
}

class _PlayListsWidgetState extends State<PlayListsWidget> {
  Set<String> _favouritedIds = {};
  final audioService = AudioService(); // shared service
  late Future<List<Audios>> _audiosFuture;

  Future<List<Audios>> fetchAudios() async {
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
    setState(() {}); // rebuild list
  }

  @override
  void initState() {
    super.initState();
    _audiosFuture = fetchAudios();

    // listen to service changes
    audioService.playerStateStream.listen((state) {
      setState(() {}); // refresh buttons when player state changes
    });
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
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff222222),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 400,
          width: 500,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: FutureBuilder<List<Audios>>(
              future: _audiosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return    PlayListShimmer();
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No songs found"));
                }

                final audios = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: audios.length,
                  itemBuilder: (context, index) {
                    final song = audios[index];
                    final isCurrent = audioService.currentSong?.id == song.id;
                    final isPlaying = audioService.isPlaying && isCurrent;

                    return Center(
                      child: InkWell(
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
                          height: 70,
                          width: 360,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
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
                              // cover + play button overlay
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(song.coverUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    onPressed: () => _togglePlayPause(song),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  song.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                song.duration,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 25),
                              IconButton(
                                icon: Icon(
                                  _favouritedIds.contains(song.id)
                                      ? Icons.favorite
                                      : Icons.favorite_outline_outlined,
                                  color: _favouritedIds.contains(song.id)
                                      ? Colors.red
                                      : Colors.grey,
                                  size: 30,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_favouritedIds.contains(song.id)) {
                                      _favouritedIds.remove(song.id);
                                    } else {
                                      _favouritedIds.add(song.id);
                                    }
                                  });
                                  FirebaseFirestore.instance
                                      .collection('audios')
                                      .doc(song.id)
                                      .update({
                                    'isFavourite':
                                    _favouritedIds.contains(song.id),
                                  });
                                },
                              ),
                            ],
                          ),
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