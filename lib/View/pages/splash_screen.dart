import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'get_startedpage.dart';
import 'home_page.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
  Timer(Duration(seconds: 2), _checkLogin);
  }
  void _checkLogin(){
    final user = FirebaseAuth.instance.currentUser;

    if (user != null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StartedPage()));
    }
  }

//   @override
//   void initState(){
//     super.initState();
//     Future.delayed(
//         Duration(seconds: 3),
//             (){
// Navigator.pushAndRemoveUntil(context,
//     MaterialPageRoute(builder: (context)=> StartedPage()),
//     (Route<dynamic> route) => false,
// );
//     },
//     );
//             }
//
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/Vector.jpg',
        height: 230,
        width: 230,
        )
            .animate()
            .fadeIn(duration: Duration(seconds: 3),),

      ),
    );
  }
  }