import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/signUp.dart';


// FULL NAME
Widget fullNameField({required TextEditingController controller}) {
  return Center(
    child: SizedBox(
      width: 334,
      height: 80,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Full Name',
          hintStyle: TextStyle(color: Color(0xffA7A7A7)),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.all(25),
          border: OutlineInputBorder(
            gapPadding: BorderSide.strokeAlignCenter,
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    ),
  );
}

// ENTER EMAIL
Widget enterEmail({required TextEditingController controller}) {
  return Center(
    child: SizedBox(
      width: 334,
      height: 80,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter Email',
          hintStyle: TextStyle(color: Color(0xffA7A7A7)),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.all(25),
          border: OutlineInputBorder(
            gapPadding: BorderSide.strokeAlignCenter,
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    ),
  );
}

// PASSWORD
Widget passwordFields({required TextEditingController controller}) {
  return Center(
    child: SizedBox(
      width: 334,
      height: 80,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Password',
          suffixIcon: Icon(Icons.visibility),
          hintStyle: TextStyle(color: Color(0xffA7A7A7)),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.all(25),
          border: OutlineInputBorder(
            gapPadding: BorderSide.strokeAlignCenter,
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    ),
  );
}

// DO YOU HAVE AN ACCOUNT TEXT ON BOTTOM NAV
Widget loginText(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Do you have an account ?',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignIn()),
            );
          },
          child: Text('Sign In '),
        ),
      ],
    ),
  );
}

//--------------------------------------------------------------------------------------//
// USED IN LOGIN THE APP

// ENTER USERNAME OR EMAIL
Widget loginName({required TextEditingController controller}) {
  return Center(
    child: SizedBox(
      width: 334,
      height: 80,
      child: TextField(
       controller: controller,
        decoration: InputDecoration(
          hintText: 'Enter Username Or Email',
          hintStyle: TextStyle(color: Color(0xffA7A7A7)),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.all(25),
          border: OutlineInputBorder(
            gapPadding: BorderSide.strokeAlignCenter,
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    ),
  );
}

// ENTER PASSWORD
Widget passwordField({required TextEditingController controller}) {
  return Center(
    child: SizedBox(
      width: 334,
      height: 80,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Password',
          suffixIcon: Icon(Icons.visibility),
          hintStyle: TextStyle(color: Color(0xffA7A7A7)),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.all(25),
          border: OutlineInputBorder(
            gapPadding: BorderSide.strokeAlignCenter,
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    ),
  );
}

// NOT A MEMBER ON BOTTOM NAV
Widget signInText(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not A Member?',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp()),
            );
          },
          child: Text('Register Now '),
        ),
      ],
    ),
  );
}


