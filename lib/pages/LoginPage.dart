import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/widgets/NButton.dart';
import 'package:social_media/widgets/NTextField.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = new TextEditingController();
  final passwordTextController = new TextEditingController();

  // Sign user in
  void signIn() async {
    //Show loading dialog
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);
      // Pop loding circle
      if (context.mounted) Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      // Pop loading circle
      Navigator.pop(context);
      // Display error message
      displayMessage(e.code);
    }
  }

  // Display a dialog message to the user
  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                ),
                //logo

                Icon(
                  Icons.lock,
                  size: 100,
                ),

                SizedBox(
                  height: 50,
                ),
                //welcome back message
                Text("Soyez le bienvenue !"),

                SizedBox(height: 25),
                //email TextField
                NTextField(
                    controller: emailTextController,
                    hintText: "Email",
                    obscureText: false),

                SizedBox(
                  height: 20,
                ),
                //password TextField
                NTextField(
                    controller: passwordTextController,
                    hintText: "Password",
                    obscureText: true),

                SizedBox(
                  height: 30,
                ),

                //sign button
                NButton(onTap: signIn, text: "Sign In"),
                //go to register page

                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member ?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
