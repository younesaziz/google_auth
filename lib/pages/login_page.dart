import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google/components/my_button.dart';
import 'package:google/components/my_textfield.dart';
import 'package:google/components/square_tile.dart';
import 'package:google/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true; // For password visibility

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController and Animations
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * 3.14).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.blue,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Sign user in method
  void signUserIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context);

      print('Error code: ${e.code}');

      if (e.code == 'user-not-found') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      } else {
        showErrorMessage(e.message);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      showErrorMessage(e.toString());
    }
  }

  // Send password reset email
  void resetPassword() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showErrorMessage('Please enter your email address');
      return;
    }
    AuthServices().sendPasswordResetEmail(email, context);
  }

  // Wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  // Generic error message popup
  void showErrorMessage(String? message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: const Center(
            child: Text(
              'Error',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: Text(
            message ?? 'An unknown error occurred',
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _colorAnimation.value!,
                  Colors.green,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated image at the top
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: Image.asset(
                                'lib/images/klaxon.png', // Ensure the image is in the assets folder and path is correct
                                height: 150,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                      // Welcome back
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 24, 23, 23),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Email textfield
                      MyTextField(
                        controller: emailController,
                        hintText: 'Email',
                      ),
                      const SizedBox(height: 10),
                      // Password textfield with eye icon
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Forgot password?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: resetPassword,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 17, 17, 17)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Sign in button
                      MyButton(
                        onTap: signUserIn,
                      ),
                      const SizedBox(height: 50),
                      // Or continue with
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      // Google sign-in button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SquareTile(
                              onTap: () =>
                                  AuthServices().signInwithGoogle(context),
                              imagePath: 'lib/images/google.png'),
                          SizedBox(width: 25),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
