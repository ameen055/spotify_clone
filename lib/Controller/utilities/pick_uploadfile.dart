import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../Data/model/audios_model.dart';


class UploadService {
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> uploadSong(Audios newAudio) async {
    final db = FirebaseFirestore.instance;

    final audiosColRef = db.collection('audios');

    audiosColRef.add(newAudio.toMap());
  }

// Upload audio file to Firebase
  Future<void> pickAndUploadFile(BuildContext context) async {
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
}