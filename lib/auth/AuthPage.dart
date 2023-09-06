import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/auth/LoginOrRegister.dart';
import 'package:social_media/pages/HomePage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // User is logged in
            if (snapshot.hasData) {
              return HomePage();
            } else {
              // User is not logged in
              return LoginOrRegister();
            }
          }),
    );
  }
}
