import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xrisepvtz/helper/my_date.dart';

import 'package:xrisepvtz/main.dart';
import 'package:xrisepvtz/modals/chatuser.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 23, 32, 58),
        title: Text(
          widget.user.name,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center, // Text alignment within the Text widget
        ),
        centerTitle: true, // Center the title in the AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Change the back button color here
        ),
      ),
      // Let Flutter handle resizing when the keyboard appears

      backgroundColor: Colors.blueGrey[200],
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Joined On : ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            MydateUtil.getLastMessageTime(
                context: context, time: widget.user.createdAt, ShowYear: true),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: risesize.height * .1),
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: risesize.width * 0.3, // Set the width
                    height:
                        risesize.width * 0.3, // Ensure height is equal to width
                    imageUrl: widget.user.image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Icon(CupertinoIcons.person),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "RiseUser",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                widget.user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "About : ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.user.about,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
