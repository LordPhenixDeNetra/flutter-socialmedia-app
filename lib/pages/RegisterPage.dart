import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/widgets/NButton.dart';
import 'package:social_media/widgets/NTextField.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = new TextEditingController();
  final passwordTextController = new TextEditingController();
  final confirmPasswordTextController = new TextEditingController();

  void signUp() async {
    // Show loading circle
    showDialog(
        context: context,
        builder: (context) => CircularProgressIndicator(
              color: Colors.black,
    ));

    // Make sure password match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      // Pop loading circle
      Navigator.pop(context);
      // Show error to user
      displayMessage("Password don't match");
      return;
    }

    //Try creating the user
    try {
      // Create user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text,
          password: passwordTextController.text);

      // After create a user create a new document in the Firebase
      FirebaseFirestore.instance
        .collection("Users")
        .doc(userCredential.user!.email)
        .set({
          "username": emailTextController.text.split("@")[0],
          "bio": "Empty bio..." // initially empty bio
        });
      //Pop loading circle
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // Show error message to the user
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
    return SingleChildScrollView(
      child: Scaffold(
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
                  Text("Creez votre compte ici !"),
    
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
                    height: 20,
                  ),
                  //password TextField
                  NTextField(
                      controller: confirmPasswordTextController,
                      hintText: "Confirm Password",
                      obscureText: true),
    
                  SizedBox(
                    height: 30,
                  ),
    
                  //sign button
                  NButton(onTap: signUp, text: "Sign Up"),
                  //go to register page
    
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account ?",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Login Now",
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
      ),
    );
  }
}
