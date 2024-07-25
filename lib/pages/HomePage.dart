import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Sign user out method
  void signUserOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      // Optionally navigate to a different screen or show a message
      // For example, navigate back to the login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error signing out: $e');
      // Handle the error, e.g., show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => signUserOut(context),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text(
          "Logged in as ${user.email!}",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
