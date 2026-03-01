import 'package:flutter/material.dart';

class NeuBox extends StatefulWidget {
  final Widget child;
  final Color? color; // Optional color parameter

  const NeuBox({Key? key, required this.child, this.color}) : super(key: key);

  @override
  _NeuBoxState createState() => _NeuBoxState();
}

class _NeuBoxState extends State<NeuBox> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 10),
        decoration: BoxDecoration(
          color: widget.color ??
              Colors.grey[300], // Use the optional color parameter
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                  BoxShadow(
                    color: const Color.fromARGB(116, 255, 255, 255),
                    blurRadius: 5,
                    offset: Offset(-3, -3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.shade900,
                    blurRadius: 10,
                    offset: const Offset(5, 5),
                  ),
                  const BoxShadow(
                    color: Color.fromARGB(138, 255, 255, 255),
                    blurRadius: 10,
                    offset: Offset(-3, -2),
                  ),
                ],
        ),
        child: Center(child: widget.child),
      ),
    );
  }
}

class NeuSimple extends StatelessWidget {
  final Widget child;
  final Color? color; // Optional color parameter

  const NeuSimple({super.key, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.grey[300], // Use the optional color parameter
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade900,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
          const BoxShadow(
            color: Colors.white,
            blurRadius: 15,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
