import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter/View/pages/profile_page.dart';
import 'package:study_flutter/View/widgets/home_widget/custom_appbar_widget.dart';
import '../../Data/model/audios_model.dart';
import '../widgets/home_widget/albums_widget.dart';
import '../widgets/home_widget/hero_card_widget.dart';
import '../widgets/home_widget/nav_bar_widget.dart';
import '../widgets/home_widget/playlist_widget.dart';
import 'favourites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    homeBodyWidget(),
    Container(), // Search will use showSearch, so placeholder
    Container(), // Add will be handled separately
    FavouritePage(),
    ProfilePage(),
  ];
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> uploadSong(Audios newAudio) async {
    final db = FirebaseFirestore.instance;

    final audiosColRef = db.collection('audios');

    audiosColRef.add(newAudio.toMap());
  }

  // Upload audio file to Firebase
  Future<void> pickAndUploadFile() async {
    print("pick audio");

    // Pick audio using the File picker
    final filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    // file picking using same just change the file type
    final imagePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    // Validate both files are picked using Snackbar
    if (filePickerResult == null || imagePickerResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select both audio and cover image")),
      );
      return;
    }

    // Create File objects
    final audioFile = File(filePickerResult.files.single.path!);
    final coverImageFile = File(imagePickerResult.files.single.path!);

    // Unique filenames
    final fileName = filePickerResult.files.single.name;
    final coverFileName = imagePickerResult.files.single.name;

    // Firebase storage references - reference for audio
    final ref = FirebaseStorage.instance.ref().child("audios/$fileName");
    // reference for the cover image
    final coverRef = FirebaseStorage.instance.ref().child(
      "covers/$coverFileName",
    );

    try {
      // Upload audio
      await ref.putFile(audioFile);
      final audioFileDownloadUrl = await ref.getDownloadURL();

      // Upload cover
      await coverRef.putFile(coverImageFile);
      final coverImageFileDownloadUrl = await coverRef.getDownloadURL();

      // Create audio object
      final newFiles = Audios(
        // 2 urls and 2 text to store in the firestore
        url: audioFileDownloadUrl,
        coverUrl: coverImageFileDownloadUrl,
        // 2 text
        title: '',
        artist: '',
        duration: '',
        id: '',
      );

      // Save to Firestore
      await uploadSong(newFiles);
      // Showing the upload successfully Snack bar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload successful!")));
    } catch (e) {
      print("Error uploading: $e");
    }
  }

  // Open file picker and let the user choose an audio file.
  //  also added the cover image to pick
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
  //   late TabController _tabController;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/musify.png', fit: BoxFit.cover,height: 140,),
        centerTitle: true,
      ),
      backgroundColor: Color(0xffffffff),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavWidget(
        selectedIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget homeBodyWidget() {
    return SingleChildScrollView(
      // physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 20),
          HeroCardWidget(),
          SizedBox(height: 15),
          AlbumWidget(),
          SizedBox(height: 15),
          PlayListsWidget(),
        ],
      ),
    );
  }
}
