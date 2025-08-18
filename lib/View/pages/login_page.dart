import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Data/services/firebase_auth_services.dart';
import '../widgets/home_widget/basic_appbar.dart';
import '../widgets/signin_up_wideget.dart';
import 'home_page.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: signInText(context),
      appBar: BasicAppBar(imagePath: 'assets/Vector.jpg',
      ),
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Image.asset('assets/Vector.jpg', fit: BoxFit.cover, height: 35),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          _signIntext(),
          SizedBox(height: 25),
          loginName(controller: _emailController),
          SizedBox(height: 10),
          passwordField(controller: _passwordController),
          SizedBox(height: 15),
          ElevatedButton(onPressed:_signIn ,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(25),
              backgroundColor: Color(0xff42C83C),
              minimumSize: Size(332, 80),
            ),
            child: Text(
              "Sign In",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signIntext() {
    return const Text(
      'Sign In',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    );
  }
  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Welcome Back!!",
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
     );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
