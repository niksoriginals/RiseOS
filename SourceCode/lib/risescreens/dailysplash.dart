import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:xrisepvtz/risescreens/home.dart';
import 'package:xrisepvtz/risescreens/risesplash.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class DailySplash extends StatefulWidget {
  const DailySplash({super.key});

  @override
  _DailySplashState createState() => _DailySplashState();
}

class _DailySplashState extends State<DailySplash> {
  @override
  void initState() {
    super.initState();

    // Schedule navigation after the current frame has finished building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Checking if the user is authenticated and navigating accordingly
      if (FirebaseAuth.instance.currentUser != null) {
        // Navigate to AnotherScreen if the user is already authenticated
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AnotherScreen()),
        );
      } else {
        // Navigate to SplashScreen if the user is not authenticated
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // Set background color to black
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white), // White progress indicator
          ),
        ),
      ),
    );
  }
}

class AnotherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(60)),
        height: 400.0,
        width: 400.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              60), // Set the border radius to match decoration
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      backgroundColor: const Color.fromARGB(
          255, 0, 0, 0), // Black background color for the splash screen
      duration: 3,
      splashIconSize: 250,
      nextScreen: HomeScreen(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
