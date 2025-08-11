import 'package:flutter/material.dart';
import 'package:study_flutter/View/pages/signUp.dart';
import '../widgets/basic_appbar.dart';
import 'login_page.dart';


class SignUpOrSIgnIn extends StatelessWidget {
  const SignUpOrSIgnIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BasicAppBar(imagePath: 'assets/Vector.jpg',
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset("assets/Union_asset.png"),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset("assets/Union2_asset.png"),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset("assets/billieelishsignup.png"),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/Vector.jpg",
                  height: 230,
                  width: 230,
                  ),
                  SizedBox(height: 55),
                  Text(
                    "Enjoy Listening To Music",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(height: 21),
                  Text(
                    "Spotify is a proprietary Swedish audio streaming and media services provider",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                       ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                          },
                         style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.green,
                           minimumSize: Size(130, 70),
                         ),
                          child: Text("Register",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: Colors.white),),
                        ),
                      SizedBox(width: 20,),
                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                      },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          minimumSize: Size(130, 70),
                        ),
                          child: Text("Sign In",style: TextStyle(
                              fontSize: 17,fontWeight: FontWeight.bold,),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
