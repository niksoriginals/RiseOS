import 'package:flutter/material.dart';

class BackgroundColorNotifier extends ValueNotifier<Color> {
  BackgroundColorNotifier(Color value) : super(value);
}

final backgroundColorNotifier = BackgroundColorNotifier(Colors.white);
