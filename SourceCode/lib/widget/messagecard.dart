import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xrisepvtz/api/apis.dart';
import 'package:xrisepvtz/helper/dialogs.dart';
import 'package:xrisepvtz/helper/my_date.dart';
import 'package:xrisepvtz/main.dart';
import 'package:xrisepvtz/modals/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({super.key, required this.message});
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isme = Apis.ppl.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          showchatbottom(isme);
        },
        child: isme ? _greenMessage() : _blueMessage());
  }

  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      Apis.updateMessageReadStatus(widget.message);
    }
    return Column(
      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align the row's children to the top
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: risesize.width * 0.04,
                vertical: risesize.height * .001,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                color: const Color.fromARGB(115, 0, 196, 131),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(widget.message.type == Type.image
                  ? risesize.width * 0.01
                  : risesize.width * 0.04),
              child: ConstrainedBox(
                // Constrain the width to make text wrap and expand vertically
                constraints: BoxConstraints(
                  maxWidth: risesize.width *
                      0.6, // Limit the width to 60% of the screen
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.message.type == Type.text
                        ? Text(
                            widget.message.msg,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            softWrap:
                                true, // Ensure the text wraps within the container
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              // Ensuring the image has equal width and height
                              imageUrl: widget.message.msg,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image,
                                size: 70,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.start, // Ensure icon stays to the right
          children: [
            SizedBox(
              width: risesize.width * 0.04,
            ), // The ico
            Text(
              MydateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(
                fontSize: 10,
                color: const Color.fromARGB(221, 165, 29, 29),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.end, // Align the children to the right
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Align the message to the right
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align the row's children to the top
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: risesize.width * 0.04,
                vertical: risesize.height * .001,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                color: const Color.fromARGB(109, 100, 4, 164),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.all(widget.message.type == Type.image
                  ? risesize.width * 0.01
                  : risesize.width * 0.04),
              child: ConstrainedBox(
                // Constrain the width to make text wrap and expand vertically
                constraints: BoxConstraints(
                  maxWidth: risesize.width *
                      0.6, // Limit the width to 60% of the screen
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.message.type == Type.text
                        ? Text(
                            widget.message.msg,
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(221, 255, 255, 255),
                            ),
                            softWrap:
                                true, // Ensure the text wraps within the container
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              // Ensuring the image has equal width and height
                              imageUrl: widget.message.msg,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image,
                                size: 70,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5), // Add some space between the message and the icon
        Row(
          mainAxisAlignment:
              MainAxisAlignment.end, // Ensure icon stays to the right
          children: [
            Text(
              MydateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(
                fontSize: 10,
                color: const Color.fromARGB(221, 165, 29, 29),
              ),
            ),

            if (widget.message.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: const Color.fromARGB(255, 20, 255, 224),
                size: 15,
              ),

            SizedBox(
              width: risesize.width * 0.04,
            ) // The icon is aligned to the right
          ],
        ),
      ],
    );
  }

  void showchatbottom(bool isme) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: risesize.height * .015,
                    horizontal: risesize.width * 0.4),
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
              widget.message.type == Type.text
                  ? Optionitem(
                      icon: Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: "Copy Text",
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: widget.message.msg));
                        Navigator.pop(context);
                        Dialogs.showSnackbar(context, "Text Copied!");
                      },
                    )
                  : Optionitem(
                      icon: Icon(
                        CupertinoIcons.download_circle,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: "Save Image",
                      onTap: () async {
                        // try {
                        //   await ImageGallerySaver.saveFile(
                        //     widget.message.msg,
                        //   ).then((success) {
                        //     Navigator.pop(context);
                        //     if (success != null && success) {
                        //       Dialogs.showSnackbar(
                        //           context, "Image Saved Sucessfully!");
                        //     }
                        //   });
                        // } catch (e) {
                        //   Dialogs.showSnackbar(context, "Failed Saving!");
                        // }
                      },
                    ),
              Divider(
                  color: Colors.black54,
                  endIndent: risesize.width * 0.04,
                  indent: risesize.width * .04),
              if (widget.message.type == Type.text && isme)
                Optionitem(
                  icon: Icon(
                    CupertinoIcons.pen,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name: "Edit Message",
                  onTap: () {},
                ),
              if (isme)
                Optionitem(
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: const Color.fromARGB(255, 239, 0, 0),
                    size: 26,
                  ),
                  name: "Delete Message",
                  onTap: () async {
                    await Apis.deleteMessage(widget.message).then((value) => {
                          Navigator.pop(context),
                          Dialogs.showSnackbar(context, "Message Deleted")
                        });
                  },
                ),
              if (isme)
                Divider(
                    color: Colors.black54,
                    endIndent: risesize.width * 0.04,
                    indent: risesize.width * .04),
              Optionitem(
                icon: Icon(
                  Icons.send_time_extension_outlined,
                  color: Colors.blue,
                  size: 26,
                ),
                name:
                    "Sent At : ${MydateUtil.getMessageTime(context: context, time: widget.message.sent)}",
                onTap: () {},
              ),
              if (isme)
                Optionitem(
                  icon: Icon(
                    CupertinoIcons.book,
                    color: const Color.fromARGB(144, 0, 250, 237),
                    size: 26,
                  ),
                  name: widget.message.read.isEmpty
                      ? "Read At : Not Seen Yet"
                      : "Read At :${MydateUtil.getMessageTime(context: context, time: widget.message.read)}",
                  onTap: () {},
                )
            ],
          );
        });
  }
}

class Optionitem extends StatelessWidget {
  const Optionitem(
      {super.key, required this.icon, required this.name, required this.onTap});
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: risesize.width * .05,
            top: risesize.height * .015,
            bottom: risesize.height * .015),
        child: Row(
          children: [
            icon,
            Flexible(
                child: Text(
              "      $name",
              style: TextStyle(
                  fontSize: 15, color: Colors.black54, letterSpacing: .5),
            ))
          ],
        ),
      ),
    );
  }
}
