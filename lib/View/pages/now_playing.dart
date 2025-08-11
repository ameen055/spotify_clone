import 'package:flutter/material.dart';
import 'package:study_flutter/Data/model/now_playing_model.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});


  // final NowPlaying  nowPlaying;
  // const NowPlayingScreen({super.key, required this.nowPlaying});

  @override
  NowPlayingScreenState createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Now Playing"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
      ),

      body: Padding(
        padding: EdgeInsets.only(left: 50,right: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Cover image for the container now playing screen
            ClipRRect(

              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                "https://firebasestorage.googleapis.com/v0/b/firestoreday16-app.firebasestorage.app/o/covers%2FBillie%20Eilish%20%2C%20Khalid%20-%"
                "20lovely.jpg?alt=media&token=6c93c487-c0b3-485e-8322-c09c2bd59412",
              ),
            ),
            // Give Title and Artist name  for the Current Song
            Column(
              children: [
                Text("",style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold)),
                SizedBox(height: 4,),
                Text("",style: TextStyle(color: Colors.grey,fontSize: 16),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
