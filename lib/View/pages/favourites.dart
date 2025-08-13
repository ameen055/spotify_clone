import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Data/model/audios_model.dart';

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('audios')
            .where('isFavourite', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(!snapshot.hasData|| snapshot.data!.docs.isEmpty){
            return const Center(child: Text("No Favourites yet"),);
          }
          final songs = snapshot.data!.docs.map((doc) => Audios.fromFirestore(doc.data()
          as Map<String, dynamic>, docId: '')).toList();

          return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index){
                final song = songs[index];
                return ListTile(
                  leading: Image.network(song.coverUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title:  Text(song.title),
                  subtitle: Text(song.artist),
                );
              });
        },
      ),
    );
  }
}
