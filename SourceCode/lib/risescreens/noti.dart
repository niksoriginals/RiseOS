import 'package:flutter/material.dart';

class NotiScreen extends StatelessWidget {
  const NotiScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: const Color.fromARGB(255, 17, 9, 105),
            ), // Background container for future content
          ],
        ),
      ),
    );
  }
}
