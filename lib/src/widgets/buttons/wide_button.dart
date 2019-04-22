import 'package:flutter/material.dart';

/// A styled button that takes up all of the available horizontal space.
class WideButton extends StatelessWidget {
  final Key buttonKey;
  final Widget child;
  final Color background;
  @required
  final VoidCallback onPressed;

  /// Use the padding tweak to allow negative adjustments to padding.
  final EdgeInsets paddingTweak;

  const WideButton(
      {this.child,
      this.onPressed,
      this.background,
      this.paddingTweak = const EdgeInsets.all(0.0),
      this.buttonKey});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: FlatButton(
          key: buttonKey,
          padding: EdgeInsets.only(
              left: 20 + paddingTweak.left,
              right: 20 + paddingTweak.right,
              top: 11 + paddingTweak.top,
              bottom: 11 + paddingTweak.bottom),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0),
          ),
          onPressed: onPressed,
          color: background,
          child: child),
    );
  }
}
