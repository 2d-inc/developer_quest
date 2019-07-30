import 'dart:ui' as ui;

import 'package:flare_dart/math/aabb.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_render_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Hero avatar for the start screen.
/// Has a gradient across the bottom.
class StartScreenHero extends LeafRenderObjectWidget {
  final BoxFit fit;
  final Alignment alignment;
  final String filename;
  final Color gradient;

  const StartScreenHero({
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.filename,
    this.gradient,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return StartScreenHeroRenderObject()
      ..assetBundle = DefaultAssetBundle.of(context)
      ..filename = filename
      ..fit = fit
      ..alignment = alignment
      ..gradient = gradient;
  }

  @override
  void updateRenderObject(BuildContext context,
      covariant StartScreenHeroRenderObject renderObject) {
    renderObject
      ..assetBundle = DefaultAssetBundle.of(context)
      ..filename = filename
      ..fit = fit
      ..alignment = alignment
      ..gradient = gradient;
  }

  @override
  void didUnmountRenderObject(
      covariant StartScreenHeroRenderObject renderObject) {
    renderObject.dispose();
  }
}

class StartScreenHeroRenderObject extends FlareRenderBox {
  FlutterActor _lastLoadedActor;
  FlutterActorArtboard _character;
  FlutterActorArtboard _nextCharacter;
  ActorAnimation _idle;
  double _animationTime = 0;
  String _filename;
  Color gradient;
  double _crossFade = 0;

  @override
  bool get isPlaying => true;

  @override
  bool advance(double elapsedSeconds) {
    if (_idle != null) {
      _animationTime += elapsedSeconds;
      _idle.apply(_animationTime % _idle.duration, _character, 1);
      _character.advance(elapsedSeconds);
    }
    if (_crossFade > 0 || _nextCharacter != null) {
      _crossFade += _nextCharacter == null ? -elapsedSeconds : elapsedSeconds;
      if (_crossFade >= 1 && _nextCharacter != null) {
        _character = _nextCharacter;
        _idle = _character.getAnimation('idle');
        _character.initializeGraphics();
        _nextCharacter = null;
        advance(0);
      }
    }
    return true;
  }

  @override
  AABB get aabb => _character?.artboardAABB();

  @override
  void paintFlare(Canvas canvas, Mat2D viewTransform) {
    // Make sure loading is complete.
    if (_character == null) {
      return;
    }

    double paddingArtboardSpace = _character.width;

    _character.draw(canvas);

    // Get into artboard space to draw the gradient.
    double height = _character.height * 2;
    double offsetTop = _character.height / 2;
    List<Color> colors = <Color>[
      gradient.withOpacity(0),
      gradient.withOpacity(1),
      gradient.withOpacity(1),
    ];
    List<double> stops = <double>[
      0,
      (_character.height - offsetTop) / height,
      1
    ];

    Offset start = Offset(
        -1 * _character.origin[0] * _character.width - paddingArtboardSpace,
        -1 * _character.origin[1] * _character.height + _character.height / 2);
    Offset end = Offset(start.dx, start.dy + height);
    Paint paint = Paint()
      ..shader = ui.Gradient.linear(start, end, colors, stops)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
        start & Size(_character.width + paddingArtboardSpace * 2, height),
        paint);

    if (_crossFade > 0) {
      Paint darken = Paint()
        ..style = PaintingStyle.fill
        ..color = gradient.withOpacity(_crossFade.clamp(0, 1).toDouble());
      canvas.drawRect(
          Offset(
                  -1 * _character.origin[0] * _character.width -
                      paddingArtboardSpace,
                  -1 * _character.origin[1] * _character.height -
                      _character.height) &
              Size(_character.width + paddingArtboardSpace * 2,
                  _character.height * 3),
          darken);
    }
  }

  String get filename => _filename;
  set filename(String value) {
    if (_filename == value) {
      return;
    }
    _filename = value;
    load();
  }

  @override
  Future<void> load() async {
    FlutterActor actor = await loadFlare(_filename);
    if (actor == null) {
      return;
    }
    bool sameActor = actor == _lastLoadedActor;
    _lastLoadedActor = actor;
    if (_character != null && !sameActor) {
      _crossFade = double.minPositive;
      _nextCharacter = actor.artboard.makeInstance() as FlutterActorArtboard;
      return;
    }
    _character = actor.artboard.makeInstance() as FlutterActorArtboard;
    _idle = _character.getAnimation('idle');
    _character.initializeGraphics();
    advance(0);
    markNeedsPaint();
  }
}
