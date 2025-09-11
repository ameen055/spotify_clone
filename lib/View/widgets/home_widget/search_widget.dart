import 'package:flutter/material.dart';
import '../../../Data/model/audios_model.dart';

class SearchWidget extends SearchDelegate {
  final List<Audios> songs;
  SearchWidget(this.songs);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = songs
        .where(
          (song) =>
              song.title.toLowerCase().contains(query.toLowerCase()) ||
              song.artist.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return _buildSongList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = songs
        .where(
          (song) =>
              song.title.toLowerCase().contains(query.toLowerCase()) ||
              song.artist.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return _buildSongList(suggestions);
  }

  Widget _buildSongList(List<Audios> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final song = list[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(song.coverUrl)),
          title: Text(song.title),
          subtitle: Text(song.artist),
          onTap: () {
            close(context, song); // later you can handle play or detail view
          },
        );
      },
    );
  }
}
