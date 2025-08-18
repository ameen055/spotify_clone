import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_flutter/View/pages/home_page.dart';
import 'package:study_flutter/View/pages/upload_screen.dart';

import '../../Data/services/firebase_auth_services.dart';
import '../widgets/signin_up_wideget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthService _auth = FirebaseAuthService();

   final TextEditingController _nameController = TextEditingController();
   final TextEditingController _emailController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();

   @override
   void dispose(){
     _nameController.dispose();
     _emailController.dispose();
     _passwordController.dispose();
     super.dispose();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: loginText(context),
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/Vector.jpg', fit: BoxFit.cover, height: 35),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _registerText(),
            SizedBox(height: 25),
            //NAME
            fullNameField(controller:  _nameController ),
            SizedBox(height: 10),
            //EMAIL
            enterEmail(controller: _emailController),
            SizedBox(height: 10),
            //PASSWORD
            passwordFields(controller: _passwordController),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(25),
                backgroundColor: Color(0xff42C83C),
                minimumSize: Size(332, 80),
              ),
              child: Text(
                "Create Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerText() {
    return const Text(
      'Register',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    );


  }
  Future<void> _signUp() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    User? user = await _auth.registerUser(name, email, password);

    if (user != null) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text("Created Account Successfully")
       ),
     );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Ocurred"),
      )
      );
    }
  }

}

