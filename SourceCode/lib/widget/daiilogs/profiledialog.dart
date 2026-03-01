import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xrisepvtz/modals/chatuser.dart';
import 'package:xrisepvtz/risescreens/viewprofile.dart';

class Profiledialog extends StatelessWidget {
  const Profiledialog({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    final risesize = MediaQuery.of(context).size; // Get screen size

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: const Color.fromARGB(200, 255, 255, 255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: risesize.width * 0.6,
        height: risesize.height * .35,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: risesize.width * 0.5, // Fixed size for width
                height: risesize.width * 0.5, // Ensure height equals width
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // Enforce circular shape
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.image,
                    fit: BoxFit.cover, // Properly fit and crop the image
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(CupertinoIcons.person, size: 50),
                  ),
                ),
              ),
            ),
            Positioned(
              left: risesize.width * .04,
              top: risesize.height * .02,
              width: risesize.width * .55,
              child: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 6,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewProfileScreen(user: user),
                    ),
                  );
                },
                minWidth: 0,
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
 