import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthServices {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Google Sign-In
  Future<UserCredential?> signInwithGoogle(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Begin interactive Sign-In
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      if (gUser == null) {
        // The user canceled the sign-in process
        Navigator.of(context).pop(); // Remove the loading indicator
        return null;
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for the user
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Finally Sign-In!
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Remove the loading indicator
      Navigator.of(context).pop();
      return userCredential;
    } catch (e) {
      // Handle error
      print('Error during Google Sign-In: $e');
      // Remove the loading indicator
      Navigator.of(context).pop();
      return null;
    }
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(
      String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent to $email'),
        ),
      );
    } catch (e) {
      print('Error sending password reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending password reset email'),
        ),
      );
    }
  }
}
