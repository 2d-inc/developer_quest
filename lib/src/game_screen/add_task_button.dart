import 'package:dev_rpg/src/style.dart';
import 'package:flutter/material.dart';

// A stylized button meant to be used for adding tasks to the task pool.
class AddTaskButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int count;
  final VoidCallback onPressed;
  final double scale;

  const AddTaskButton(
    this.label, {
    Key key,
    this.count = 0,
    this.icon,
    this.color,
    this.onPressed,
    this.scale = 1.0,
  }) : super(key: key);

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
    if (widget.onPressed != null) {
      widget.onPressed();
    }
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
        height: 40 * widget.scale,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      offset: const Offset(0, 10),
                      blurRadius: _isPressed ? 10 : 15,
                      spreadRadius: 0),
                ],
          borderRadius: BorderRadius.all(Radius.circular(20 * widget.scale)),
          color: isDisabled
              ? disabledTaskColor.withOpacity(0.10)
              : _isPressed ? widget.color.withOpacity(0.8) : widget.color,
        ),
        child: Row(
          children: [
            Icon(widget.icon,
                color: isDisabled ? disabledTaskColor : Colors.white),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                widget.label,
                style: buttonTextStyle.apply(
                    fontSizeDelta: -2,
                    fontSizeFactor: widget.scale,
                    color: isDisabled ? disabledTaskColor : Colors.white),
              ),
            ),
            isDisabled
                ? Container()
                : Container(
                    constraints: BoxConstraints(
                      minWidth: 26 * widget.scale,
                      minHeight: 26 * widget.scale,
                      maxHeight: 26 * widget.scale,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(widget.count.toString(),
                          style: buttonTextStyle.apply(
                              fontSizeDelta: -2,
                              fontSizeFactor: widget.scale,
                              color: widget.color)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
