import 'package:flutter/material.dart';

/// A styled button that takes up all of the available horizontal space.
class WideButton extends StatelessWidget {
  final Key buttonKey;
  final Widget child;
  final Color background;
  final Color shadowColor;
  final bool enabled;
  @required
  final VoidCallback onPressed;

  /// Use the padding tweak to allow negative adjustments to padding.
  final EdgeInsets paddingTweak;

  const WideButton({
    this.child,
    this.onPressed,
    this.background,
    this.paddingTweak = const EdgeInsets.all(0),
    this.buttonKey,
    this.shadowColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: double.infinity),
      decoration: shadowColor != null
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: shadowColor,
                    offset: const Offset(0, 10),
                    blurRadius: 10),
              ],
            )
          : null,
      child: FlatButton(
          key: buttonKey,
          padding: EdgeInsets.only(
              left: 20 + paddingTweak.left,
              right: 20 + paddingTweak.right,
              top: 11 + paddingTweak.top,
              bottom: 11 + paddingTweak.bottom),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          onPressed: enabled ? onPressed : null,
          color: background,
          child: child),
    );
  }
}
