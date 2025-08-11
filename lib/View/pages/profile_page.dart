import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.network(
                  "https://cdn-icons-png.flaticon.com/512/10337/10337609.png",
                  fit: BoxFit.cover,
                  width: 110,
                  height: 110,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
