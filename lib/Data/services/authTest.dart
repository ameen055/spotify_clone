import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../View/pages/get_startedpage.dart';
import '../../View/pages/home_page.dart';

class AuthTest extends StatelessWidget {
  const AuthTest({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return HomePage(); // Already logged in
        }
        return StartedPage(); // Not logged in
      },
    );
  }
}