import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google/pages/login_page.dart';
import 'package:google/pages/HomePage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // User logged in
              if (snapshot.hasData) {
                return HomePage();
              }
              // User is not logged in
              else {
                return LoginPage();
              }
            }));
  }
}
