import 'dart:math';
import "dart:ui" as ui;

import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import "package:flutter/scheduler.dart";

/// A widget that displays animated visual indicators for npc speed boost.
class BoostIndicator extends LeafRenderObjectWidget {
  final BoostController controller;

  const BoostIndicator(this.controller);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return BoostIndicatorRenderObject()..controller = controller;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant BoostIndicatorRenderObject renderObject) {
    renderObject.controller = controller;
  }

  @override
  void didUnmountRenderObject(
      covariant BoostIndicatorRenderObject renderObject) {
    renderObject.dispose();
  }
}

/// A helper to martial events between the BoostIndicator widget and any other
/// widget that wants to trigger displaying the indicator.
class BoostController extends ChangeNotifier {
  void showIndicator() {
    notifyListeners();
  }
}

/// RenderBox that draws the multiple animated text indicators of boost.
class BoostIndicatorRenderObject extends RenderBox {
  BoostController _controller;
  int _frameCallbackID;
  double _lastFrameTime = 0.0;
  final List<BoostParagraph> _boosts = [];
  final Random _random = Random();

  BoostController get controller {
    return _controller;
  }

  void showBoost() {
    _boosts.add(BoostParagraph("+10")
      ..center = Offset(
          size.width * _random.nextDouble(), size.height * _random.nextDouble())
      ..velocity = Offset(0.0, _random.nextDouble() * -50.0 - 50.0));
    updatePlayState();
  }

  set controller(BoostController value) {
    if (_controller == value) {
      return;
    }
    _controller?.removeListener(showBoost);
    _controller = value;
    _controller?.addListener(showBoost);
    updatePlayState();
  }

  void _beginFrame(Duration timeStamp) {
    final double t =
        timeStamp.inMicroseconds / Duration.microsecondsPerMillisecond / 1000.0;

    if (_lastFrameTime == 0) {
      _lastFrameTime = t;
      SchedulerBinding.instance.scheduleFrameCallback(_beginFrame);
      return;
    }

    double elapsed = (t - _lastFrameTime).clamp(0.0, 1.0).toDouble();
    _lastFrameTime = t;

    List<BoostParagraph> toRemove = [];
    for (final BoostParagraph score in _boosts) {
      if (score.advance(elapsed)) {
        toRemove.add(score);
      }
    }

    toRemove.forEach(_boosts.remove);

    markNeedsPaint();
  }

  @override
  void detach() {
    super.detach();
    dispose();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    updatePlayState();
  }

  void dispose() {
    updatePlayState();
  }

  bool get isPlaying => attached && _boosts.isNotEmpty;

  void updatePlayState() {
    if (isPlaying) {
      markNeedsPaint();
    } else {
      _lastFrameTime = 0;
      if (_frameCallbackID != null) {
        SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackID);
      }
    }
  }

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset screenOffset) => false;

  @override
  void performResize() {
    size = Size(constraints.constrainWidth(), constraints.constrainHeight());
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (isPlaying) {
      // Paint again
      if (_frameCallbackID != null) {
        SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackID);
      }
      _frameCallbackID =
          SchedulerBinding.instance.scheduleFrameCallback(_beginFrame);
    } else {
      _lastFrameTime = 0;
    }

    final Canvas canvas = context.canvas;
    for (final BoostParagraph score in _boosts) {
      canvas.drawParagraph(
          score.paragraph,
          Offset(score.center.dx - BoostParagraph.maxWidth / 2.0,
              score.center.dy - score.size.height / 2.0));
    }
  }
}

/// [BoostParagraph] encompasses the properties necessary to draw the
/// [Paragraph] that the [BoostIndicatorRenderObject] users to draw boost
/// indications.
class BoostParagraph {
  static const double maxWidth = 4096.0;
  ui.Paragraph paragraph;
  Size size;
  Offset center;
  double secondsElapsed = 0.0;
  final String label;
  Offset velocity;

  BoostParagraph(this.label) {
    advanceSeconds(0.0);
  }

  bool advance(double seconds) {
    center += velocity * seconds;
    return advanceSeconds(secondsElapsed + seconds * 1.5);
  }

  bool advanceSeconds(double v) {
    secondsElapsed = v.clamp(0.0, 1.0).toDouble();
    double opacity;
    const double fadeIn = 0.5;
    const double fadeHold = 0.2;
    const double blurFrom = 0.3;
    const double fadeOut = 1.0 - (fadeIn + fadeHold);
    if (secondsElapsed < fadeIn) {
      opacity = secondsElapsed / fadeIn;
    } else if (secondsElapsed < fadeHold) {
      opacity = 1.0;
    } else {
      opacity = (1.0 - ((secondsElapsed - fadeIn - fadeHold) / fadeOut))
          .clamp(0.0, 1.0)
          .toDouble();
    }
    double blur = (secondsElapsed - blurFrom).clamp(0.0, 1.0).toDouble() * 10.0;

    ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontFamily: "MontserratRegular",
        fontSize: ui.lerpDouble(
            40.0, 120.0, Curves.easeInOut.transform(secondsElapsed))))
      ..pushStyle(ui.TextStyle(
          foreground: Paint()
            ..color = Colors.white.withOpacity(opacity)
            ..maskFilter =
                blur == 0 ? null : MaskFilter.blur(BlurStyle.normal, blur)));
    builder.addText(label);
    paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: maxWidth));
    List<ui.TextBox> boxes = paragraph.getBoxesForRange(0, label.length);
    size = Size(boxes.last.right - boxes.first.left,
        boxes.last.bottom - boxes.first.top);

    return secondsElapsed >= 1.0;
  }
}
