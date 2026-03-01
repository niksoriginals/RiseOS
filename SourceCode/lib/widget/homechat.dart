import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xrisepvtz/api/apis.dart';
import 'package:xrisepvtz/helper/my_date.dart';
import 'package:xrisepvtz/main.dart';
import 'package:xrisepvtz/modals/chatuser.dart';
import 'package:xrisepvtz/modals/message.dart';
import 'package:xrisepvtz/risescreens/chatmessage.dart';
import 'package:xrisepvtz/widget/daiilogs/profiledialog.dart';

class HomeCard extends StatefulWidget {
  final ChatUser user;

  const HomeCard({super.key, required this.user});

  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: const Color.fromARGB(255, 180, 217, 234),
      margin:
          EdgeInsets.symmetric(horizontal: risesize.width * 0.04, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatPage(user: widget.user)));
        },
        child: StreamBuilder(
          stream: Apis.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) {
              _message = list[0];
            }

            return ListTile(
              leading: Container(
                width: risesize.width * 0.1,
                height:
                    risesize.width * 0.1, // Ensure width and height are equal
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Ensures circular shape
                ),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => Profiledialog(user: widget.user),
                    );
                  },
                  child: ClipOval(
                    child: CachedNetworkImage(
                      width: double.infinity, // Ensure it fills the container
                      height: double.infinity,
                      fit: BoxFit
                          .cover, // Ensures the image covers the entire area
                      imageUrl: widget.user.image,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (context, url, error) => Icon(
                          CupertinoIcons.person,
                          size: risesize.width * 0.05),
                    ),
                  ),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(
                _message != null
                    ? _message!.type == Type.image
                        ? "Image"
                        : _message!.msg
                    : widget.user.about,
                maxLines: 1,
              ),
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty && _message!.fromId != Apis.ppl.uid
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 2, 92, 2),
                          ),
                        )
                      : Text(
                          MydateUtil.getLastMessageTime(
                            context: context,
                            time: _message!.sent,
                          ),
                          style: TextStyle(color: Colors.black54),
                        ),
            );
          },
        ),
      ),
    );
  }
}
