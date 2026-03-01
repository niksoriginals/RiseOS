import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui'; // Import for ImageFilter
import 'package:rive/rive.dart' hide Image;
import 'package:xrisepvtz/api/apis.dart';
import 'package:xrisepvtz/helper/dialogs.dart';
import 'package:xrisepvtz/main.dart';
import 'package:xrisepvtz/risescreens/home.dart';


class RiseInPage extends StatefulWidget {
  const RiseInPage({super.key});

  @override
  _RiseInPageState createState() => _RiseInPageState();
}

class _RiseInPageState extends State<RiseInPage> {
  bool phone = false;

  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((User) async {
      Navigator.pop(context);
      if (User != null) {
        log('\nUser:${User.user}');
        log('\nUserAdditional:${User.additionalUserInfo}');
        if (await (Apis.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          await Apis.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Apis.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, "Look for Internet Please :)");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Positioned(
            width: screenWidth * 1.7,
            left: screenWidth * 0.1,
            bottom: screenHeight * 0.1,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),

          // Your new container above the animations
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(), // Adjust the position as needed
                  child: Container(
                    width: screenWidth, // Adjust width as needed
                    height: screenHeight * 0.2, // Adjust height as needed
                    decoration: BoxDecoration(
                      color:
                          Colors.blueGrey.withOpacity(0.9), // Background color
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(
                          screenWidth,
                          120,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the texts vertically
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Center the texts horizontally
                      children: [
                        Center(
                          child: Text(
                            'RiseIn',
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.15),
            child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                color: const Color.fromARGB(110, 0, 0, 0),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.09),
                  child: Container(
                    height: screenHeight * 0.31,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blueGrey.withOpacity(0.6)),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: Stack(children: [
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Welcome Back to Rise !",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                'Login to continue enjoying uninterrupted ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 1,
                            ),
                            Center(
                              child: Text(
                                'music and personalised experience.',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Container(
                              width: screenWidth * 0.7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1.0,
                                    color: Colors.black,
                                  )),
                              child: TextField(
                                onChanged: (text) {
                                  
                                  setState(() {
                                    phone = text
                                        .isNotEmpty; // Set phone to true if text is not empty, false otherwise
                                  });
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: phone
                                        ? Icon(Icons.edit)
                                        : Icon(Icons.phone_android_rounded),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 15.0)),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "or",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: risesize.height * 0.05,
                            width: risesize.width * .4,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(4),
                              color: const Color.fromARGB(81, 250, 250, 250),
                              elevation: 15,
                              onPressed: () {
                                phone
                                    ? Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()))
                                    : _handleGoogleBtnClick();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (phone)
                                    SizedBox(
                                      width: 10,
                                    ),
                                  phone
                                      ? Icon(
                                          Icons.phone_android,
                                          size: 25,
                                        )
                                      : Image.asset(
                                          "assets/images/google.png",
                                          scale: 40,
                                        ),
                                  if (phone)
                                    SizedBox(
                                      width: 10,
                                    ),
                                  phone
                                      ? Text(
                                          "Get OTP",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "Lets Goo",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
