import 'package:flutter/material.dart';

class SphinxButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const SphinxButton({
    @required this.onPressed,
    @required this.child,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);

    return Material(
      shape: RoundedRectangleBorder(borderRadius: radius),
      color: const Color.fromRGBO(242, 124, 78, 1),
      child: InkWell(
        borderRadius: radius,
        splashColor: const Color.fromRGBO(242, 124, 78, 1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
          child: DefaultTextStyle(
            child: child,
            style: TextStyle(
                fontFamily: 'MontserratRegular',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(85, 34, 34, 1)),
          ),
        ),
        onTap: onPressed,
      ),
    );
  }
}
