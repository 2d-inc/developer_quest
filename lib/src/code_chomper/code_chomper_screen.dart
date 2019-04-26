library chompy;

import 'dart:async';
import 'dart:math';
import "dart:ui" as ui;

import 'package:dev_rpg/src/code_chomper/code_chomper.dart';
import 'package:flare_dart/math/aabb.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_render_box.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const double _chompLineHeight = 32;
const double _padLeft = 15;
const double _padCodeLeft = 35;
const double _padTop = 15;
final _chompParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.left, fontFamily: "SpaceMonoRegular", fontSize: 16);

class CodeChomperScreen extends LeafRenderObjectWidget {
  final CodeChomperController controller;

  const CodeChomperScreen(this.controller);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CodeChomperScreenRenderObject(DefaultAssetBundle.of(context))
      ..controller = controller;
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant CodeChomperScreenRenderObject renderObject) {
    renderObject.controller = controller;
  }

  @override
  void didUnmountRenderObject(
      covariant CodeChomperScreenRenderObject renderObject) {
    renderObject.dispose();
  }
}

class CodeChomperController extends ValueNotifier<Offset> {
  CodeChomperController() : super(Offset.zero);

  void addCode(Offset gloalPosition) {
    value = gloalPosition;
  }
}

class CodeChomperScreenRenderObject extends FlareRenderBox {
  CodeChomperController _controller;
  double _scrollTarget = 0;
  double _scroll = 0;
  double _cursor = 0;
  double _chomped = 0;
  static const double _chompAppear = 0.6;
  double _chompTarget = 0;
  Timer _chompTimer;
  int _numVisibleLines = 0;
  final List<String> _lines = [];
  List<String> _templateLines;
  FlutterActorArtboard _chompy;
  ActorAnimation _chompyIdle;
  ActorAnimation _chompyChomp;
  ActorAnimation _chompyAppear;
  FlutterActorArtboard _fui;
  ActorAnimation _fuiTap;
  double _fuiTime = 0;
  Offset _fuiOffset;

  CodeChomperController get controller {
    return _controller;
  }

  CodeChomperScreenRenderObject(AssetBundle bundle) {
    assetBundle = bundle;
    rootBundle
        .loadString("assets/docs/code_chomper_example_code.dart")
        .then((code) {
      _templateLines = code.split("\n");
    });
    _chompTimer = Timer.periodic(Duration(milliseconds: 1600), _chompNext);

    loadFlare("assets/flare/Chomper.flr").then((FlutterActor actor) {
      _chompy = actor.artboard.makeInstance() as FlutterActorArtboard;
      _chompy.initializeGraphics();
      _chompyIdle = _chompy.getAnimation("Idle");
      _chompyChomp = _chompy.getAnimation("Chomp");
      _chompyAppear = _chompy.getAnimation("Appear");
    });

    loadFlare("assets/flare/Chomper FUI Type.flr").then((FlutterActor actor) {
      _fui = actor.artboard.makeInstance() as FlutterActorArtboard;
      _fui.initializeGraphics();
      _fuiTap = _fui.getAnimation("Tap");
    });
  }

  void _chompNext(Timer timer) {
    _chompTarget = min(_lines.length.toDouble(), _chompTarget + 1);
  }

  bool addSomeCode() {
    if (_templateLines.isEmpty) {
      return true;
    }
    _lines.add(_templateLines.first);
    _templateLines.removeAt(0);

    if (_lines.length > _scrollTarget + _numVisibleLines / 2) {
      _scrollTarget = _lines.length - _numVisibleLines / 2;
    }

    if (_controller != null) {
      _fuiOffset = _controller.value;
      _fuiTime = 0;
    }

    updatePlayState();
    return false;
  }

  set controller(CodeChomperController value) {
    if (_controller == value) {
      return;
    }
    _controller?.removeListener(addSomeCode);
    _controller = value;
    _controller?.addListener(addSomeCode);
    updatePlayState();
  }

  @override
  void dispose() {
    super.dispose();
    _chompTimer.cancel();
  }

  @override
  bool get isPlaying => attached;

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
    super.paint(context, offset);

    final Canvas canvas = context.canvas;
    canvas.save();
    canvas.clipRect(offset & size);
    double offsetY = _scroll * _chompLineHeight;

    // Draw one extra line back so that we don't prematurely cull visible
    // descenders.
    int firstLine = (offsetY / _chompLineHeight).floor() - 1;

    // Get offset in visible line space.
    offsetY = -(offsetY - firstLine * _chompLineHeight);

    // Pad three extra lines of visibility.
    _numVisibleLines = (size.height / _chompLineHeight).floor() + 3;
    var chevron = _MeasuredText(">", color: chompBlue.withOpacity(0.4));
    for (int i = 0; i < _numVisibleLines; i++) {
      canvas.drawParagraph(
          chevron.paragraph,
          Offset(offset.dx + _padLeft,
              offset.dy + offsetY + _padTop + i * _chompLineHeight));

      // make sure it's a valid code line...
      int renderLine = i + firstLine;

      if (renderLine > _cursor) {
        continue;
      }
      bool chomp = renderLine == _chomped.floor();
      var line = renderLine >= 0 && renderLine < _lines.length
          ? _MeasuredText(_lines[renderLine],
              color: chomp
                  ? Color.lerp(chompBlue, chompRed, _chomped - _chomped.floor())
                  : renderLine < _chomped ? chompRed : chompBlue)
          : null;
      var lineOffset = Offset(offset.dx + _padCodeLeft,
          offset.dy + offsetY + _padTop + i * _chompLineHeight);
      bool clip = renderLine == _cursor.floor();
      double lineEffectWidth =
          (line?.size?.width ?? 0).clamp(10, size.width).toDouble();
      if (clip) {
        double clipWidth = (_cursor - _cursor.floor()) * lineEffectWidth;
        canvas.drawRect(
            Rect.fromLTWH(offset.dx + _padCodeLeft + clipWidth,
                offset.dy + offsetY + _padTop + i * _chompLineHeight, 3, 31),
            Paint()
              ..style = PaintingStyle.fill
              // Fade the cursor in and out, and hold the out a little
              ..color = chompBlue.withOpacity(pow(
                      ((DateTime.now().millisecondsSinceEpoch % 1500) /
                                  1500 *
                                  2 -
                              1)
                          .abs(),
                      0.4)
                  .toDouble()));
      }

      // Draw the line of text
      if (line != null && line.text.isNotEmpty) {
        if (clip) {
          canvas.save();
          double clipWidth =
              (_cursor - _cursor.floor()) * min(size.width, line.size.width);
          canvas.clipRect(lineOffset & Size(clipWidth, line.size.height));
        }
        canvas.drawParagraph(line.paragraph, lineOffset);
        if (clip) {
          canvas.restore();
        }
      }

      // Draw the strikethrough
      if (renderLine < _chomped) {
        double chompWidth = chomp
            ? Curves.easeInOut
                    .transform(
                        max(0, (_chomped % 1) - _chompAppear) /
                            (1.0 - _chompAppear))
                    .toDouble() *
                lineEffectWidth
            : lineEffectWidth;
        canvas.drawRect(
            Rect.fromLTWH(
                offset.dx + _padCodeLeft,
                offset.dy +
                    offsetY +
                    _padTop +
                    i * _chompLineHeight +
                    _chompLineHeight / 2 -
                    3,
                chompWidth,
                1),
            Paint()
              ..style = PaintingStyle.fill
              ..color = chompRed);
        if (chomp) {
          canvas.save();
          canvas.translate(offset.dx + _padCodeLeft + chompWidth + 15,
              offset.dy + offsetY + _padTop + i * _chompLineHeight + 13);
          canvas.scale(0.5, 0.5);
          _chompy?.draw(canvas);
          canvas.restore();
        }
      }
    }
    canvas.restore();

	if(_fuiOffset != null)
	{
		canvas.save();
		canvas.translate(_fuiOffset.dx, _fuiOffset.dy);
		_fui?.draw(canvas);
		canvas.restore();
	}
  }

  // null bounds, makes the render box not call the paintFlare method
  // which we don't need to use in this case as we'll do custom painting
  @override
  AABB get aabb => null;

  @override
  void advance(double elapsedSeconds) {
    _scroll += (_scrollTarget - _scroll) * min(1, elapsedSeconds * 3);

    double diff = _lines.length - _cursor;
    if (diff < 0.03) {
      _cursor = _lines.length.toDouble();
    } else {
      _cursor += diff * min(1, elapsedSeconds * 5);
    }

    diff = _chompTarget - _chomped;
    if (diff < 0.03) {
      _chomped = _chompTarget;
    } else {
      _chomped += diff * min(1, elapsedSeconds * 1.2);
    }

    _chompyIdle?.apply(
        (DateTime.now().millisecondsSinceEpoch / 1000) % _chompyIdle.duration,
        _chompy,
        1.0);

    double chompTime = _chomped % 1;
    if (chompTime < _chompAppear && _chompyAppear != null) {
      double appear = chompTime / _chompAppear * _chompyAppear.duration;
      _chompyAppear.apply(appear, _chompy, 1.0);
    } else {
      _chompyChomp?.apply(
          max(0, (_chomped % 1) - _chompAppear) /
              (1.0 - _chompAppear) *
              _chompyChomp.duration,
          _chompy,
          1.0);
    }
    _chompy?.advance(elapsedSeconds);

    if (_fuiOffset != null) {
      _fuiTime += elapsedSeconds;
      _fuiTap?.apply(_fuiTime, _fui, 1.0);
	  _fui.advance(elapsedSeconds);
    }
  }

  @override
  void paintFlare(ui.Canvas canvas, Mat2D viewTransform) {
    // Intentionally empty as we override the base paint method.
  }
}

class _MeasuredText {
  static const double maxWidth = 4096;
  static const double fadeIn = 0.5;
  static const double fadeHold = 0.2;
  static const double blurFrom = 0.3;
  static const double fadeOut = 1 - (fadeIn + fadeHold);

  ui.Paragraph paragraph;
  Size size;
  Offset center;
  final String text;
  Color color;

  _MeasuredText(this.text, {this.color = chompBlue}) {
    compute();
  }

  void compute() {
    ui.ParagraphBuilder builder = ui.ParagraphBuilder(_chompParagraphStyle)
      ..pushStyle(
        ui.TextStyle(foreground: Paint()..color = color),
      );
    builder.addText(text);
    paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: maxWidth));
    List<ui.TextBox> boxes = paragraph.getBoxesForRange(0, text.length);
    size = boxes.isEmpty
        ? Size.zero
        : Size(boxes.last.right - boxes.first.left,
            boxes.last.bottom - boxes.first.top);
  }
}
