import 'dart:ui' as ui;

import 'package:flare_dart/actor_artboard.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_dart/math/aabb.dart';

import 'flare_render_box.dart';

class StartScreenHero extends LeafRenderObjectWidget {
  final BoxFit fit;
  final Alignment alignment;
  final bool isPlaying;
  final String filename;
  final Color gradient;

  const StartScreenHero(
      {this.fit = BoxFit.contain,
      this.alignment = Alignment.center,
      this.isPlaying = true,
      this.filename,
      this.gradient});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return StartScreenHeroRenderObject()
      ..assetBundle = DefaultAssetBundle.of(context)
      ..filename = filename
      ..fit = fit
      ..alignment = alignment
      ..isPlaying = isPlaying
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
      ..isPlaying = isPlaying
      ..gradient = gradient;
  }

  @override
  void didUnmountRenderObject(
      covariant StartScreenHeroRenderObject renderObject) {
    renderObject.dispose();
  }
}

class StartScreenHeroRenderObject extends FlareRenderBox {
  FlutterActor _character;
  FlutterActor _nextCharacter;
  ActorAnimation _idle;
  double _animationTime = 0.0;
  String _filename;
  Color gradient;
  double _crossFade = 0.0;

  @override
  bool advance(double elapsedSeconds) {
    if (_idle != null) {
      _animationTime += elapsedSeconds;
      _idle.apply(_animationTime % _idle.duration, _character.artboard, 1.0);
      _character.artboard.advance(elapsedSeconds);
    }
    if (_crossFade > 0.0 || _nextCharacter != null) {
      _crossFade += _nextCharacter == null ? -elapsedSeconds : elapsedSeconds;
      if (_crossFade >= 1.0 && _nextCharacter != null) {
        _character = _nextCharacter;
        _idle = _character.artboard.getAnimation("idle");
        _character.artboard.initializeGraphics();
        _nextCharacter = null;
        advance(0.0);
      }
    }
    return true;
  }

  @override
  AABB get aabb => _character?.artboard?.artboardAABB();

  @override
  void paintFlare(Canvas canvas, Mat2D viewTransform) {
    // Make sure loading is complete.
    if (_character == null) {
      return;
    }
    (_character.artboard as FlutterActorArtboard).draw(canvas);

    ActorArtboard artboard = _character.artboard;

    // Get into artboard space to draw the gradient.
    double height = artboard.height * 2.0;
    double offsetTop = artboard.height / 2.0;
    List<Color> colors = <Color>[
      gradient.withOpacity(0),
      gradient.withOpacity(1.0),
      gradient.withOpacity(1.0),
    ];
    List<double> stops = <double>[
      0.0,
      (artboard.height - offsetTop) / height,
      1.0
    ];

    Offset start = Offset(-artboard.origin[0] * artboard.width,
        -artboard.origin[1] * artboard.height + artboard.height / 2.0);
    Offset end = Offset(start.dx, start.dy + height);
    Paint paint = Paint()
      ..shader = ui.Gradient.linear(start, end, colors, stops)
      ..style = PaintingStyle.fill;
    //canvas.drawRect(offset & size, paint);

    canvas.drawRect(start & Size(artboard.width, height), paint);

    if (_crossFade > 0.0) {
      Paint darken = Paint()
        ..style = PaintingStyle.fill
        ..color = gradient.withOpacity(_crossFade.clamp(0.0, 1.0));
      canvas.drawRect(
          Offset(-artboard.origin[0] * artboard.width,
                  -artboard.origin[1] * artboard.height - artboard.height) &
              Size(artboard.width, artboard.height * 3.0),
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
  void load() {
    if (assetBundle == null || _filename == null) {
      return;
    }
    FlutterActor character = FlutterActor();
    character.loadFromBundle(assetBundle, _filename).then((bool success) {
      if (_character != null) {
        _crossFade = double.minPositive;
        _nextCharacter = character;
        return;
      }

      character.artboard.initializeGraphics();
      _idle = character.artboard.getAnimation("idle");
      _character = character;

      advance(0.0);
    });
  }
}
