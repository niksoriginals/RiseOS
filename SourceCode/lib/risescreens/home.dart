import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:xrisepvtz/Spotify/presentation/intro/pages/get_started.dart';

import 'package:xrisepvtz/api/apis.dart';

import 'package:xrisepvtz/main.dart';
import 'package:xrisepvtz/modals/chatuser.dart';
import 'package:xrisepvtz/risescreens/profile.dart';
import 'package:xrisepvtz/risescreens/searchscreen.dart';

import 'package:xrisepvtz/risescreens/time.dart';
import 'package:xrisepvtz/spotify/presentation/intro/pages/get_started.dart';
import 'package:xrisepvtz/ui/bottomnav.dart';
import 'package:xrisepvtz/widget/homechat.dart';

import '../ui/Pageview.dart';
import '../ui/neu.dart';
import 'noti.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool search = false;

  String userName = "";
  RiveAsset selectedBottomNav = bottomNavs.first;
  final PageController _pageController = PageController();
  bool _isLoading = false; // Loading state variable

  @override
  void initState() {
    super.initState();
    Apis.getselfinfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (Apis.auth.currentUser != null) {
        if (message.toString().contains("pause"))
          Apis.updateActiveStatus(false);
        if (message.toString().contains("resume"))
          Apis.updateActiveStatus(true);
      }

      return Future.value(message);
    });
  }

  void _showLoadingOverlay(int index) {
    // Show loading overlay only if the tapped index is 2 or 3
    if (index == 1) {
      setState(() {
        _isLoading = true; // Show loading overlay for indices 2 and 3
      });
    } else {
      setState(() {
        _isLoading = true; // You can add any other actions here for index 1
      });
    }
  }

  void _hideLoadingOverlay() {
    setState(() {
      _isLoading = false;
    });
  }

  void _onBottomNavTap(int index) {
    if (selectedBottomNav == bottomNavs[index]) {
      return; // Do nothing if the same index is tapped
    }
    _showLoadingOverlay(index);

    setState(() {
      selectedBottomNav = bottomNavs[index];
      for (var nav in bottomNavs) {
        nav.input?.value = false;
      }
      bottomNavs[index].input?.value = true;
    });

    _pageController.jumpToPage(index);
    Future.delayed(const Duration(seconds: 1), () {
      _hideLoadingOverlay();
    });
  }

  List<ChatUser> list = [];
  final List<ChatUser> searchlist = [];
  @override
  Widget build(BuildContext context) {
    risesize = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (search) {
            setState(() {
              search = !search;
            });
            return Future.value(false);
          } else {
            return Future.value(false);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            NonSwipeablePageView(
              controller: _pageController,
              children: [
                Container(
                  color: const Color.fromARGB(133, 33, 149, 243),
                  child: SafeArea(
                      child: _buildHomePage(screenWidth, screenHeight)),
                ),
                Container(
                  color: Colors.blueGrey,
                  child: SafeArea(
                      child: _buildSpotifyPage(screenWidth, screenHeight)),
                ),
                Container(
                  color: Colors.blueGrey,
                  child: const SafeArea(child: TimeScreen()),
                ),
                Container(
                  color: Colors.blueGrey,
                  child: const SafeArea(child: NotiScreen()),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.blueGrey,
                  child: SafeArea(
                      child: _buildProfilePage(screenWidth, screenHeight)),
                )
              ],
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.blueGrey,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Align the BottomNavBar in the middle
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                  child: BottomNavBar(
                    onTap: _onBottomNavTap,
                    selectedBottomNav: selectedBottomNav,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.02),
                      child: SizedBox(
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        child: NeuBox(
                          color: Color.fromARGB(255, 23, 32, 58),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GetStartedPage()));
                            },
                            child: Center(
                                child: ClipRRect(
                                    child: Image.asset(
                                        "assets/images/spotify-removebg-preview.png"))),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.02),
                      child: SizedBox(
                        width: screenWidth * 0.45,
                        height: screenHeight * 0.048,
                        child: const NeuBox(
                          color: Color.fromARGB(255, 23, 32, 58),
                          child: Text(
                            'R I S E P V T',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.02),
                      child: SizedBox(
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        child: NeuBox(
                          color: Color.fromARGB(255, 23, 32, 58),
                          child: InkWell(
                            onTap: () {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                // Delay of 1 second
                                setState(() {
                                  search =
                                      true; // Assuming this should control the visibility
                                });
                              });
                            },
                            child: Center(
                                child: Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (search)
              Column(
                children: [
                  // Upper Container
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(139, 255, 255, 255),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade900,
                          blurRadius: 20,
                          offset: const Offset(-3, -3),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search User",
                                    contentPadding: EdgeInsets.all(10),
                                  ),
                                  onChanged: (value) {
                                    searchlist.clear();
                                    for (var i in list) {
                                      if (i.name
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          i.email
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                        searchlist.add(i);
                                      }
                                      setState(() {
                                        searchlist;
                                      });
                                      ;
                                    }
                                  },
                                ),
                              ),
                              Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 206, 64, 231),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: search
                                      ? GestureDetector(
                                          onTap: () {
                                            search = false;
                                            setState(() {});
                                          },
                                          child: Icon(Icons.close))
                                      : Icon(Icons.search_rounded)),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ]),
        ),
      ),
    );
  }

  Widget _buildHomePage(double screenWidth, double screenHeight) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05, top: screenHeight * 0.12),
              child: const Text(
                'Hi There,',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth * 0.05, top: screenHeight * 0.000001),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite_outline_outlined,
                    color: Colors.pink,
                  )
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            width: screenWidth,
            height: screenHeight * 0.74,
            decoration: BoxDecoration(
              color: const Color.fromARGB(133, 9, 156, 189),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade900,
                  blurRadius: 20,
                  offset: Offset(-3, -3),
                ),
              ],
            ),
            child: StreamBuilder(
              stream: Apis.getallusers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('An error occurred!')); // Handle errors
                    }

                    if (snapshot.hasData) {
                      final data = snapshot.data?.docs;
                      list = data
                              ?.map((e) => ChatUser.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (list.isEmpty) {
                        return Center(
                            child: Text('No users found')); // Handle empty data
                      }

                      return ListView.builder(
                          itemCount: search ? searchlist.length : list.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return HomeCard(
                              user: search ? searchlist[index] : list[index],
                            );
                          });
                    }

                    // If no data is present
                    return Center(child: Text('No data available.'));
                }
              },
            ),
          ),
        )
      ],
    );
  }

//profilepage

  Widget _buildProfilePage(double screenWidth, double screenHeight) {
    if (list.isEmpty) {
      return Center(
          child: CircularProgressIndicator()); // Loading state if list is empty
    } else {
      return Container(
        color: Colors.blueGrey,
        child: SafeArea(child: ProfileScreen(user: Apis.me)),
      );
    }
  }

//Spotify

  Widget _buildSpotifyPage(double screenWidth, double screenHeight) {
    if (list.isEmpty) {
      return Center(
          child: CircularProgressIndicator()); // Loading state if list is empty
    } else {
      return Container(
        color: Colors.blueGrey,
        child: SafeArea(child: SearchScreen()),
      );
    }
  }
}
