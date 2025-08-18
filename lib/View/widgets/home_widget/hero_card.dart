import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HeroCardWidget extends StatefulWidget {
  const HeroCardWidget({super.key});

  @override
  State<HeroCardWidget> createState() => _HeroCardWidgetState();
}

class _HeroCardWidgetState extends State<HeroCardWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  String name = "";

  void _fetchUser() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'] ?? "";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 130,
        width: 320,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff0478ef), Color(0xff4cc5fe)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Left Text Section
            Positioned(
              left: 16,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   "Hi,",
                  //   style: TextStyle(fontSize: 19, color: Colors.white70),
                  // ),
                  const SizedBox(height: 5),
                  Text(
                    "Hey $name 👋",

                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "What you want to here \ntoday?",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
