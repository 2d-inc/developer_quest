import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Determines whether the indicator should point left or right
enum TextBubbleDirection { left, right }

/// Place content inside a Text Bubble
class TextBubble extends StatelessWidget {
  final Widget child;
  final TextBubbleDirection direction;
  final Radius radius;
  final Size indicatorSize;
  final double shadowOffset;
  final EdgeInsets padding;

  const TextBubble({
    @required this.child,
    Key key,
    this.padding = const EdgeInsets.all(16),
    this.direction = TextBubbleDirection.left,
    this.radius = const Radius.circular(10),
    this.indicatorSize = const Size(35, 20),
    this.shadowOffset = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _TextBubbleBackgroundPainter(
              direction: direction,
              radius: radius,
              indicatorSize: indicatorSize,
              shadowOffset: shadowOffset,
            ),
          ),
        ),
        // Text
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: padding.left,
                right: padding.right,
                top: padding.top,
                bottom: padding.bottom + indicatorSize.height + shadowOffset,
              ),
              child: DefaultTextStyle(
                child: child,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'MontserratMedium',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Create a "Text Bubble" using a CustomPainter.
class _TextBubbleBackgroundPainter extends CustomPainter {
  final TextBubbleDirection direction;
  final Radius radius;
  final Size indicatorSize;
  final double shadowOffset;

  _TextBubbleBackgroundPainter({
    @required this.direction,
    @required this.radius,
    @required this.indicatorSize,
    @required this.shadowOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bubbleBottom = size.height - indicatorSize.height - shadowOffset;

    // Start the path and create the first two rounded corners
    final path = Path()
      ..moveTo(
        radius.x,
        0,
      )
      ..lineTo(size.width - radius.x, 0)
      ..arcToPoint(
        Offset(size.width, radius.x),
        radius: radius,
      )
      ..lineTo(size.width, bubbleBottom - radius.y)
      ..arcToPoint(
        Offset(size.width - radius.x, bubbleBottom),
        radius: radius,
      );

    // After drawing the top and bottom-right corner, use the direction to
    // determine which indicator to draw: Facing left or right.
    if (direction == TextBubbleDirection.left) {
      final startX = size.width - radius.x - size.width / 6;
      final endX = startX - indicatorSize.width;

      path
        ..lineTo(startX, bubbleBottom)
        ..lineTo(endX, bubbleBottom + indicatorSize.height)
        ..lineTo(endX, bubbleBottom);
    } else {
      final startX = radius.x + indicatorSize.width + size.width / 6;
      final endX = startX - indicatorSize.width;

      path
        ..lineTo(startX, bubbleBottom)
        ..lineTo(startX, bubbleBottom + indicatorSize.height)
        ..lineTo(endX, bubbleBottom);
    }

    // Complete the path by creating the last two rounded corners
    path
      ..lineTo(radius.x, bubbleBottom)
      ..arcToPoint(
        Offset(0, bubbleBottom - radius.y),
        radius: radius,
      )
      ..lineTo(0, radius.y)
      ..arcToPoint(
        Offset(radius.x, 0),
        radius: radius,
      );

    // Paint the shadow
    canvas.save();
    canvas.translate(0, shadowOffset);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color.fromRGBO(85, 34, 34, 0.29)
        ..style = PaintingStyle.fill,
    );

    // Then, paint the white background
    canvas.restore();
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_TextBubbleBackgroundPainter old) {
    return direction != old.direction;
  }
}
