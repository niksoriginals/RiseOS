import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart'; // Import the services package for hiding status bar
import 'package:xrisepvtz/api/apis.dart';
import 'package:xrisepvtz/main.dart';
import 'package:xrisepvtz/risescreens/home.dart';

import 'package:xrisepvtz/risescreens/riseauth/risein.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Hide the status bar to make the app fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = VideoPlayerController.asset('assets/Backgrounds/bg.mp4')
      ..initialize().then((_) {
        // Ensure the video starts playing automatically when initialized
        _controller.play();
        _controller.setLooping(false);

        setState(() {});

        // Navigate to HomeScreen after video ends or delay
        if (FirebaseAuth.instance.currentUser != null) {
        } else {}
        Future.delayed(const Duration(seconds: 18), () {
          if (Apis.auth.currentUser != null) {
            log('\nUser:${Apis.auth.currentUser}');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RiseInPage()),
            );
          }
        });
      });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Don't forget to dispose the video player controller
    // Restore the status bar when leaving the screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    risesize = MediaQuery.of(context).size;
    return Scaffold(
        body: _controller.value.isInitialized
            ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : Container(
                color: Colors.black,
                height: risesize.height,
                width: risesize.width,
              ));
  }
}
