import 'package:flutter/material.dart';

class HeroCardWidget extends StatelessWidget{
  const HeroCardWidget({super.key});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        height: 130,
        width: 320,
        decoration: BoxDecoration(
          color: Color(0xff42C83C), // Spotify green
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
                children: const [
                  Text(
                    "New Album",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Happier Than\nEver",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Billie Eilish",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Right Image
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset("assets/home_topbillie.png"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}