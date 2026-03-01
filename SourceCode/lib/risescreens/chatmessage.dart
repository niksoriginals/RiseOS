import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xrisepvtz/helper/my_date.dart';
import 'package:xrisepvtz/main.dart';
import 'package:xrisepvtz/modals/chatuser.dart';
import 'package:xrisepvtz/modals/message.dart';
import 'package:xrisepvtz/risescreens/home.dart';
import 'package:xrisepvtz/risescreens/viewprofile.dart';
import 'package:xrisepvtz/widget/messagecard.dart';

import '../api/apis.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  final ChatUser user;

  ChatPage({required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late AnimationController _titleController;
  late Animation<Offset> _titleAnimation;
  late DraggableScrollableController _draggableController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _titleAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeInOut,
    ));

    _draggableController = DraggableScrollableController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      _titleController.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _draggableController.dispose();
    super.dispose();
  }

  void _handleHomeButtonPressed() {
    _controller.reverse();
    _titleController.reverse();
    Future.delayed(
      const Duration(milliseconds: 750),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return true; // Handle any additional logic if necessary
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blueGrey,
        body: Stack(children: [
          SlideTransition(
            position: _titleAnimation,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.zero,
                child: Material(
                  elevation: 10,
                  shadowColor: Colors.deepPurple,
                  color: const Color.fromARGB(255, 23, 32, 58),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30)),
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 35,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ViewProfileScreen(user: widget.user)));
                          },
                          child: StreamBuilder(
                              stream: Apis.getUserInfo(widget.user),
                              builder: (context, snapshot) {
                                final data = snapshot.data?.docs;
                                final list = data
                                        ?.map(
                                            (e) => ChatUser.fromJson(e.data()))
                                        .toList() ??
                                    [];

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: risesize.width * 0.1,
                                      height: risesize.width *
                                          0.1, // Ensure it's a square
                                      decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle, // Ensures the circular shape
                                        color: Colors.grey
                                            .shade200, // Optional background color
                                      ),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: list.isNotEmpty
                                              ? list[0].image
                                              : widget.user.image,
                                          fit: BoxFit
                                              .cover, // Ensures the image fills the circle
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(
                                                  strokeWidth: 2),
                                          errorWidget: (context, url, error) =>
                                              Icon(CupertinoIcons.person,
                                                  size: risesize.width * 0.05),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            list.isNotEmpty
                                                ? list[0].name
                                                : widget.user.name,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.06,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            list.isNotEmpty
                                                ? (list[0].isOnline
                                                    ? 'Online'
                                                    : MydateUtil
                                                        .getLastActiveTime(
                                                            context: context,
                                                            lastActive: list[0]
                                                                .lastActive))
                                                : MydateUtil.getLastActiveTime(
                                                    context: context,
                                                    lastActive:
                                                        widget.user.lastActive),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 189, 2, 2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 50),
                                  ],
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SlideTransition(
            position: _animation,
            child: DraggableScrollableSheet(
              controller: _draggableController,
              initialChildSize: 0.84,
              minChildSize: 0.5,
              maxChildSize:
                  0.84, // Limit to prevent dragging above original position
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Column(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        width: screenWidth,
                        height: 50,
                        child: GestureDetector(
                          onTap: _handleHomeButtonPressed,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25)),
                              color: const Color.fromARGB(129, 158, 158, 158),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade900,
                                  blurRadius: 20,
                                  offset: Offset(-3, -3),
                                ),
                              ],
                            ),
                            height: 50,
                            width: 100,
                            child: Center(
                              child: Text(
                                'Home',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ChatContainer(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,

                      user: widget.user,
                      // Pass user to ChatContainer
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message",
                        hintStyle: TextStyle(color: Colors.black45),
                        suffixIcon: GestureDetector(
                            onTap: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 70);
                              if (image != null) {
                                log('Image Path : ${image.path}');

                                Apis.sendChatImage(
                                    widget.user, File(image.path));
                              }
                            },
                            child: Icon(
                              Icons.image_rounded,
                              color: Colors.lightBlue,
                              size: 30,
                            )),
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_textController.text.isNotEmpty) {
                        Apis.sendMessage(
                            widget.user, _textController.text, Type.text);
                        _textController.text = "";
                      }
                    },
                    child: Icon(
                      Icons.send_rounded,
                      size: 30,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class ChatContainer extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final ChatUser user;

  const ChatContainer({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.user,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ChatContainerState createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  List<Message> _list = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: Container(
        width: widget.screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          color: const Color.fromARGB(129, 158, 158, 158),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Container(
                  color: const Color.fromARGB(134, 160, 154, 156),
                  child: StreamBuilder(
                    stream: Apis.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Center(child: Text('An error occurred!'));
                          }

                          if (snapshot.hasData) {
                            final data = snapshot.data?.docs;
                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            // Sort messages by timestamp
                            // _list.sort((a, b) =>
                            //     int.parse(a.sent).compareTo(int.parse(b.sent)));

                            if (_list.isEmpty) {
                              return Center(child: Text('No messages found'));
                            }

                            // Scroll to the bottom when new data is loaded
                            // WidgetsBinding.instance.addPostFrameCallback((_) {
                            //   _scrollController.jumpTo(
                            //       _scrollController.position.maxScrollExtent);
                            // });

                            return ListView.builder(
                              reverse: true,
                              // controller: _scrollController,
                              itemCount: _list.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0), // Space between messages
                                  child: MessageCard(
                                    message: _list[index],
                                  ),
                                );
                              },
                            );
                          }

                          return Center(child: Text('No data available.'));
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom +
                  risesize.height * .1,
            ),
          ],
        ),
      ),
    );
  }
}
