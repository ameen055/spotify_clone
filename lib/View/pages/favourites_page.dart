import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Data/model/audios_model.dart';
import '../../Data/services/favourite_service.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FavoritesService.favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No favorites yet"));
          }

          final songs = snapshot.data!.docs.map((doc) {
            return Audios.fromFirestore(
              doc.data() as Map<String, dynamic>,
              docId: doc.id,
            );
          }).toList();

          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    song.coverUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[200],
                      child: const Icon(Icons.music_note),
                    ),
                  ),
                ),
                title: Text(
                  song.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(song.artist ?? 'Unknown artist'),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () async {
                    await FavoritesService.toggleFavorite(song.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}