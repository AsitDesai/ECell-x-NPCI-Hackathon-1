import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'login_page.dart'; // Ensure you have this import

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Navigate to home page after splash screen
    Future.delayed(const Duration(seconds: 2), () {
      // Check if user is already logged in
      User? currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser != null) {
        // User is logged in, go to home page
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const HomePage())
        );
      } else {
        // User is not logged in, go to login page
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => LoginPage())
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/sp.jpeg', // Your splash screen logo
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}