// overlay_loading.dart
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class OverlayLoading extends StatelessWidget {
  final bool isLoading;

  const OverlayLoading({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/loading.riv",
                  stateMachines: const ["LoadingAnimation"],
                  onInit: _onRiveIconInit,
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  void _onRiveIconInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      "LoadingAnimation",
    );
    if (controller != null) {
      artboard.addController(controller);
    } else {
      print('Failed to initialize the StateMachineController');
    }
  }
}
