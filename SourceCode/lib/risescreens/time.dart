import 'package:flutter/material.dart';


class TimeScreen extends StatelessWidget {
  const TimeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.amber,
            ), // Background container for future content

          ],
        ),
      ),
    );
  }
}
