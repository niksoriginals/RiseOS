import 'package:flutter/material.dart';

class NonSwipeablePageView extends StatelessWidget {
  final PageController controller;
  final List<Widget> children;

  const NonSwipeablePageView({
    Key? key,
    required this.controller,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      
      controller: controller,
      physics: const NeverScrollableScrollPhysics(), // Disable swipe
      children: children,
    );
  }
}