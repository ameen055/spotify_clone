import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../Data/model/audios_model.dart';
import '../../Data/model/song_model.dart';
import 'login_page.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // Declare variables and consts
  final storageRef = FirebaseStorage.instance.ref();

  final AudioPlayer player = AudioPlayer();

  List<Song> songs = [];
  int currentIndex = 1;
  bool isPlaying = false;

  // Functions
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    ); // Adjust route as needed
  }

  Future<void> loadSongs() async {
    print("song load");
    final snapshot = await FirebaseFirestore.instance
        .collection('audios')
        // Sort based on your Firestore field
        .get();

    setState(() {
      print("set state");
      songs = snapshot.docs.map((doc) {
        return Song.fromFirestore(doc.data());
      }).toList();
    });

    if (songs.isNotEmpty) {
      await setAudio(songs[currentIndex].url);
    }
  }

  Future<void> setAudio(String url) async {
    await player.setUrl(url);
    player.pause();
    setState(() {
      isPlaying = true;
    });
  }

  void togglePlayPause() {
    if (isPlaying) {
      player.pause();
    } else {
      player.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void playNext() {
    print("play next");
    if (songs.isNotEmpty) {
      currentIndex = (currentIndex + 1) % songs.length;
      setAudio(songs[currentIndex].url);
    }
  }

  Future<void> uploadSong(Audios newAudio) async {
    final db = FirebaseFirestore.instance;

    final audiosColRef = db.collection('audios');

    audiosColRef.add(newAudio.toMap());
  }

  // Upload audio file to Firebase
  Future<void> pickAndUploadFile() async {
    print("pick audio");
    // Prompt the user to select an file (especially audio files) from the device.
    final filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    // Check if the file is not null and not empty
    if (filePickerResult != null &&
        filePickerResult.files.single.path != null) {
      // Construct file object and extract file name from the path
      final audioFile = File(filePickerResult.files.single.path!);
      final fileName = filePickerResult.files.single.name;

      // Create an firebase-storage reference for file to be uploaded
      final ref = FirebaseStorage.instance.ref().child("audios/$fileName");

      try {
        // Upload the file to storage and wait for completion
        await ref.putFile(audioFile);

        // Get the download url from the reference, so we can use them to store in the database
        final audioFileDownloadUrl = await ref.getDownloadURL();

        // Create a new Audio model with the 'audioFileDownloadUrl'
        final newAudio = Audios(
          url: audioFileDownloadUrl,
          title: '',
          coverUrl: '',
          artist: '',
          duration: '',
        );

        // upload the audio model to firestore
        await uploadSong(newAudio);

        // Inform the user about the upload of audio status
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload successful!")));
      } catch (e) {
        print("Error uploading: $e");
      }
    }
  }
  // Open file picker and let the user choose an audio file.
  //
  // Get the file and its name.
  //
  // Create a path in Firebase Storage (audios/filename.mp3).
  //
  // Upload the file to that path.
  //
  // Get the download URL from Firebase Storage.
  //
  // Save that URL into Firestore as a document in the audios collection.
  //
  // Show a success message.
  //
  // If anything goes wrong, print the error.

  // Overriding methods

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final currentSong = songs.isNotEmpty ? songs[currentIndex] : null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Music App', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // List of song containers
          ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];

              // This code safely extracts and cleans up the actual file name from the long Firebase download URL.
              // It allows you to display just the song name in your UI instead of showing a long link.
              final songTitle = Uri.decodeFull(
                song.url.split('%2F').last.split('?').first,
              );

              return Center(
                child: Container(
                  height: 80,
                  width: 270,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
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
                      Icon(Icons.music_note_rounded),
                      Expanded(
                        child: Text(
                          songTitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          currentIndex == index && isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () async {
                          if (currentIndex == index && isPlaying) {
                            togglePlayPause();
                          } else {
                            currentIndex = index;
                            await setAudio(song.url);
                            player.play();
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Bottom play/pause controls
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: Colors.black),
                ),
                height: 80,
                width: 280,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      color: Colors.black,
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 40,
                      onPressed: togglePlayPause,
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.skip_next),
                      iconSize: 40,
                      onPressed: playNext,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade400,
        onPressed: pickAndUploadFile,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
