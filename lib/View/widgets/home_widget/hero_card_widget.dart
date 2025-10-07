import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class HeroCardWidget extends StatefulWidget {
  const HeroCardWidget({super.key});

  @override
  State<HeroCardWidget> createState() => _HeroCardWidgetState();
}

class _HeroCardWidgetState extends State<HeroCardWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  String name = "";
  bool isLoading = true; // loading state

  void _fetchUser() async {
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          name = userDoc['name'] ?? "";
          isLoading = false; // stop loading
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
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
      child: isLoading
          ? Shimmer.fromColors(
        baseColor: Colors.grey.shade700,
        highlightColor: Colors.grey.shade500,
        child: Container(
          height: 130,
          width: 320,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // Optional shimmer placeholders for text
              Positioned(
                left: 16,
                top: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 20,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 180,
                      height: 16,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          : Container(
        height: 130,
        width: 320,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff000000), Color(0xff444444)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hey $name 👋",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(
                      begin: -0.2, end: 0, duration: 600.ms),
                  const SizedBox(height: 5),
                  const Text(
                    "What you want to hear \ntoday?",
                    style: TextStyle(
                        fontSize: 16, color: Colors.white70),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideY(
                      begin: 0.2, end: 0, duration: 800.ms),
                ],
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 500.ms)
          .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
    );
  }
}
