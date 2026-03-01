import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../utils/rive_utils.dart';


class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,
      {required this.artboard,
      required this.stateMachineName,
      required this.title,
      this.input});

  set setInput(SMIBool status) {
    input = status;
  }
}

List<RiveAsset> bottomNavs = [
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "CHAT", stateMachineName: "CHAT_Interactivity", title: "Chat"),
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
      title: "Search"),
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "TIMER",
      stateMachineName: "TIMER_Interactivity",
      title: "Chat"),
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "BELL",
      stateMachineName: "BELL_Interactivity",
      title: "Notifications"),
  RiveAsset("assets/RiveAssets/icons.riv",
      artboard: "USER",
      stateMachineName: "USER_Interactivity",
      title: "Profile"),
];

class BottomNavBar extends StatefulWidget {
  final Function(int) onTap;
  final RiveAsset selectedBottomNav;
  

  const BottomNavBar({
    Key? key,
    required this.onTap,
    required this.selectedBottomNav,
  }) : super(key: key);
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
          color: const Color.fromARGB(
              255, 8, 10, 18), // Replace with your background color
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.99),
              offset: const Offset(0, 2),
              blurRadius: 2,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...List.generate(
            bottomNavs.length,
            (index) => GestureDetector(
              onTap: () {
                widget.onTap(index);
                bottomNavs[index].input!.change(true);
                Future.delayed(const Duration(seconds: 1), () {
                  bottomNavs[index].input!.change(false);
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 2),
                    height: 4,
                    width:
                        widget.selectedBottomNav == bottomNavs[index] ? 20 : 0,
                    decoration: const BoxDecoration(
                        color: Color(0xff81b4ff),
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                  ),
                  SizedBox(
                    height: 36,
                    width: 36,
                    child: Opacity(
                      opacity: widget.selectedBottomNav == bottomNavs[index]
                          ? 1.0
                          : 0.5,
                      child: RiveAnimation.asset(
                        bottomNavs[index].src,
                        artboard: bottomNavs[index].artboard,
                        onInit: (artboard) {
                          StateMachineController controller =
                              RiveUtils.getRiveController(artboard,
                                  stateMachineName:
                                      bottomNavs[index].stateMachineName);

                          bottomNavs[index].input =
                              controller.findSMI("active") as SMIBool;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
