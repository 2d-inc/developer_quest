import 'package:dev_rpg/src/style.dart';
import 'package:flutter/material.dart';

// A stylized button meant to be used for adding tasks to the task pool.
class LaunchButton extends StatefulWidget {
  final VoidCallback onPressed;

  const LaunchButton({Key key, this.onPressed}) : super(key: key);

  @override
  _LaunchButtonState createState() => _LaunchButtonState();
}

class _LaunchButtonState extends State<LaunchButton> {
  bool _isPressed;
  @override
  void initState() {
    _isPressed = false;
    super.initState();
  }

  void onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void onTap() {
    if (widget.onPressed != null) {
      widget.onPressed();
    }
  }

  static const _color = Color.fromRGBO(84, 114, 239, 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: _color.withOpacity(0.25),
                offset: const Offset(0.0, 10.0),
                blurRadius: _isPressed ? 10.0 : 15.0,
                spreadRadius: 0.0),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(9.0)),
          color: _color,
        ),
        child:
            Text("LAUNCH", style: buttonTextStyle.apply(color: Colors.white)),
      ),
    );
  }
}
