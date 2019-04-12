import 'package:dev_rpg/src/style.dart';
import 'package:flutter/material.dart';

// A stylized button meant to be used for adding tasks to the task pool.
class AddTaskButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int count;
  final VoidCallback onPressed;

  const AddTaskButton(this.label,
      {Key key, this.count = 0, this.icon, this.color, this.onPressed})
      : super(key: key);

  @override
  _AddTaskButtonState createState() => _AddTaskButtonState();
}

class _AddTaskButtonState extends State<AddTaskButton> {
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
    widget.onPressed?.call();
  }

  bool get isDisabled => widget.count == 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: isDisabled ? null : onTapDown,
      onTapUp: isDisabled ? null : onTapUp,
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 40,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        decoration: BoxDecoration(
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      offset: const Offset(0.0, 10.0),
                      blurRadius: _isPressed ? 10.0 : 15.0,
                      spreadRadius: 0.0),
                ],
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          color: isDisabled
              ? const Color.fromRGBO(38, 38, 47, 0.10)
              : _isPressed ? widget.color.withOpacity(0.8) : widget.color,
        ),
        child: Row(
          children: [
            Icon(widget.icon,
                color: isDisabled
                    ? const Color.fromRGBO(38, 38, 47, 0.25)
                    : Colors.white),
            const SizedBox(width: 4.0),
            Expanded(
              child: Text(
                widget.label,
                style: buttonTextStyle.apply(
                    fontSizeDelta: -2, color: isDisabled
                    ? const Color.fromRGBO(38, 38, 47, 0.25)
                    : Colors.white),
              ),
            ),
            isDisabled
                ? Container()
                : Container(
                    constraints: const BoxConstraints(
                      minWidth: 26.0,
                      minHeight: 26.0,
                      maxHeight: 26.0,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(widget.count.toString(),
                          style: buttonTextStyle.apply(
                              fontSizeDelta: -2, color: widget.color)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
