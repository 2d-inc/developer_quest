import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final Widget child;
  final Color background;
  @required
  final VoidCallback onPressed;
  const WideButton({this.child, this.onPressed, this.background});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: FlatButton(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 11, bottom: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0),
          ),
          onPressed: onPressed,
          color: background,
          child: child),
    );
  }
}
