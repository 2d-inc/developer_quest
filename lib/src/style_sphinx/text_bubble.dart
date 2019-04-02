import 'dart:math' as math;

import 'package:flutter_web/material.dart';
import 'package:flutter_web/widgets.dart';

class TextBubble extends StatelessWidget {
  final Widget child;
  final double bottomPadding;

  const TextBubble({Key key, this.child, this.bottomPadding = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final corner = Image.asset('assets/style_sphinx/chat_bubble_corner.png');

    return Stack(
      children: [
        // Top and Bottom Borders
        Positioned.fill(
          top: 0,
          left: 40,
          right: 40,
          bottom: 33,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 7.0,
                ),
                bottom: BorderSide(
                  color: Colors.black,
                  width: 7.0,
                ),
              ),
            ),
          ),
        ),

        // Left and Right borders
        Positioned.fill(
          top: 40,
          bottom: 73,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(
                  color: Colors.black,
                  width: 7.0,
                ),
                right: BorderSide(
                  color: Colors.black,
                  width: 7.0,
                ),
              ),
            ),
          ),
        ),

        // Corners
        Positioned(
          top: 0,
          left: 0,
          child: SizedBox(
            width: 40,
            height: 40,
            child: corner,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Transform.rotate(angle: math.pi / 2, child: corner),
          ),
        ),
        Positioned(
          bottom: 33,
          right: 0,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Transform.rotate(angle: math.pi, child: corner),
          ),
        ),
        Positioned(
          bottom: 33,
          left: 0,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Transform.rotate(angle: math.pi * 1.5, child: corner),
          ),
        ),
        // Indicator
        Positioned(
          bottom: 0,
          left: 100,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Image.asset('assets/style_sphinx/chat_bubble_indicator.png'),
          ),
        ),

        // Text
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: child,
            ),
            SizedBox(height: bottomPadding),
          ],
        ),
      ],
    );
  }
}
