//flutter visuals
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatelessWidget {
  //constructor
  const Login({super.key});

  //product the widget
  Widget build(BuildContext context) {
    //needed directionality
    return MaterialApp(
      title: "Login Page",
      home: LoginPage()
    );
  }
  
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState()=>LoginForm();
}

class LoginForm extends State<LoginPage> {
  //text controllers to get text from input fields to use
  final TextEditingController emailCtrlr=TextEditingController();
  final TextEditingController passwordCtrlr=TextEditingController();
String? name;
  
  //constructor
  LoginForm() {
name="Welcome, please login";
  }

  void authenticate() async {
    setState(() async {
      try {
          //authenticate credentials given
          final auth=await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailCtrlr.text,
            password: passwordCtrlr.text,
          );
name=FirebaseAuth.instance.currentUser?.uid;
          print('User logged in: ${auth.user!.uid}');
          //TODO
          //go to main page with listing of user's url's
        } on FirebaseAuthException catch (e) {
          if (e.code=='user-not-found') {
            //TODO
name="NO USER";
            //give notice on page
            //allow login again
            print('No user found for that email.');
          } else if (e.code=='wrong-password') {
            //TODO:
            //give notice on page
name="BAD PW";
            //allow login again
            print('Wrong password provided for that user.');
          } else {
            print('Error: $e');
          }
      }
    });
  }

  void logout() async {
    setState(() async {
      final auth=await FirebaseAuth.instance.signOut();
name="Welcome, please login";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
Text('$name'),
          //email input
          TextField(
            controller: emailCtrlr,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          //password input
          TextField(
            controller: passwordCtrlr,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true, //password dots
          ),
          SizedBox(height: 16),
          //login button
          ElevatedButton(
            onPressed: authenticate,
            child: Text('Login')
          ),
          //sign up page button
          ElevatedButton(
            onPressed: () async {
              //TODO
              //go to signup page
            },
            child: Text('Sign Up')
          ),
          //just used to logout right away
          ElevatedButton(
            onPressed: logout,
            child: Text('Logout')
          )
        ],
      ),
    );
  }
}