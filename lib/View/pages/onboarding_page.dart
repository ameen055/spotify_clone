import 'package:flutter/material.dart';

class StartedPage extends StatefulWidget {
  const StartedPage({super.key});

  @override
  StartedPageState createState() => StartedPageState();
}

class StartedPageState extends State<StartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.15)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset('assets/musify.png'),
                ),
                Spacer(),
                Text(
                  "Enjoy Listening to Music",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 21),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sagittis "
                  "enim purus sed phasellus. Cursus ornare id scelerisque aliquam.",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/startedPage');
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    minimumSize: Size(250, 70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
