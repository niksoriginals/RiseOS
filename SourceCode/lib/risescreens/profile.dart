import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xrisepvtz/helper/dialogs.dart';
import 'package:xrisepvtz/main.dart';
import 'package:xrisepvtz/modals/chatuser.dart';
import 'package:xrisepvtz/risescreens/riseauth/risein.dart';
import '../api/apis.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool update = false;
  String? _image;
  final _formKey = GlobalKey<FormState>();

  // Create FocusNodes to control TextFormField focus
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _aboutFocusNode = FocusNode();

  @override
  void dispose() {
    // Clean up the focus nodes when the widget is disposed
    _nameFocusNode.dispose();
    _aboutFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Let Flutter handle resizing when the keyboard appears
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blueGrey[200],
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: GestureDetector(
            // Dismiss the keyboard when tapping outside the text fields
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              // Ensure scrolling if needed when keyboard appears
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: risesize.height * .1),
                    child: Stack(
                      children: [
                        _image != null
                            ? ClipOval(
                                child: Image.file(
                                  File(_image!),
                                  width: risesize.width * 0.3, // Set the width
                                  height: risesize.width *
                                      0.3, // Ensure height is equal to width

                                  fit: BoxFit.cover,
                                ),
                              )
                            : ClipOval(
                                child: CachedNetworkImage(
                                  width: risesize.width * 0.3, // Set the width
                                  height: risesize.width *
                                      0.3, // Ensure height is equal to width
                                  imageUrl: widget.user.image,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(CupertinoIcons.person),
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            minWidth: 15,
                            onPressed: () {
                              showpicbottom();
                            },
                            shape: CircleBorder(),
                            color: Colors.amber,
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              size: 20, // Set the icon size to make it smaller
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "RiseUser",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: risesize.width * 0.7,
                    child: TextFormField(
                      onChanged: (Text1) {
                        setState(() {
                          update = Text1
                              .isNotEmpty; // Set phone to true if text is not empty, false otherwise
                        });
                      },
                      focusNode: _nameFocusNode,
                      initialValue: widget.user.name,
                      onSaved: (val) => Apis.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(CupertinoIcons.person),
                        contentPadding: EdgeInsets.all(16.0),
                        hintText: widget.user.name,
                        labelText: "Name",
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: risesize.width * 0.7,
                    child: TextFormField(
                      onChanged: (Text) {
                        setState(() {
                          update = Text
                              .isNotEmpty; // Set phone to true if text is not empty, false otherwise
                        });
                      },
                      focusNode: _aboutFocusNode,
                      initialValue: widget.user.about,
                      onSaved: (val) => Apis.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(CupertinoIcons.info),
                        contentPadding: EdgeInsets.all(16.0),
                        hintText: "I am a RiseUser",
                        labelText: "About",
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          update
                              ? SizedBox(
                                  height: risesize.width * 0.12,
                                  child: MaterialButton(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    color: const Color.fromARGB(135, 0, 94, 71),
                                    onPressed: () {
                                      update = false;
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        Apis.updatedata().then((value) {
                                          Dialogs.showSnackbar(context,
                                              "Profile RisenUP Succesfully!");
                                        });
                                        // Perform update
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          child: Icon(Icons.update),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Update",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: risesize.width * 0.12,
                                  child: MaterialButton(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onPressed: () async {
                                      Dialogs.showProgressBar(context);
                                      await Apis.updateActiveStatus(false);
                                      await Apis.auth.signOut();
                                      await GoogleSignIn()
                                          .signOut()
                                          .then((value) {
                                        Navigator.pop(context);
                                        Apis.auth = FirebaseAuth.instance;
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => RiseInPage()),
                                        );
                                      });
                                    },
                                    color:
                                        const Color.fromARGB(128, 250, 117, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          child: Icon(Icons.logout_outlined),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Rise Out",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showpicbottom() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: risesize.height * .03, bottom: risesize.height * .05),
            children: [
              Text(
                "Lets Paints New",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: risesize.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          fixedSize:
                              Size(risesize.width * .25, risesize.height * .1)),
                      child: Image.asset("assets/images/addpic.png"),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path : ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          Apis.updatepic(File(_image!));
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          fixedSize:
                              Size(risesize.width * .25, risesize.height * .1)),
                      child: Image.asset("assets/images/camera.png"),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          log('Image Path : ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          Apis.updatepic(File(_image!));
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      })
                ],
              )
            ],
          );
        });
  }
}
