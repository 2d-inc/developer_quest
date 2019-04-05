import 'dart:math';
import 'dart:ui' as ui;

import 'package:dev_rpg/src/widgets/flare/desaturated_actor.dart';
import 'package:dev_rpg/src/widgets/flare/flare_cache.dart';
import 'package:flare_dart/actor_artboard.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_dart/math/aabb.dart';

import 'flare_render_box.dart';

enum HiringBustState { locked, available, hired }

/// Avatar displayed on the hiring page, has clipping and is desaturated.
class HiringBust extends LeafRenderObjectWidget {
  final BoxFit fit;
  final Alignment alignment;
  final HiringBustState hiringState;
  final String filename;

  const HiringBust(
      {this.fit = BoxFit.contain,
      this.alignment = Alignment.center,
      this.hiringState,
      this.filename});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return HiringBustRenderObject()
      ..assetBundle = DefaultAssetBundle.of(context)
      ..filename = filename
      ..fit = fit
      ..alignment = alignment
      ..hiringState = hiringState
      ..isPlaying = true;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant HiringBustRenderObject renderObject) {
    renderObject
      ..assetBundle = DefaultAssetBundle.of(context)
      ..filename = filename
      ..fit = fit
      ..hiringState = hiringState
      ..alignment = alignment;
  }

  @override
  void didUnmountRenderObject(covariant HiringBustRenderObject renderObject) {
    renderObject.dispose();
  }
}

class HiringBustRenderObject extends FlareRenderBox {
  FlutterActorArtboard _artboard;
  String _filename;
  HiringBustState _hiringState;

  HiringBustState get hiringState => _hiringState;
  set hiringState(HiringBustState value) {
    if (_hiringState == value) {
      return;
    }
    _hiringState = value;
  }

  @override
  bool advance(double elapsedSeconds) {
    _artboard?.advance(elapsedSeconds);
    return false;
  }

  @override
  AABB get aabb => _artboard?.artboardAABB();

  @override
  void prePaint(Canvas canvas, Offset offset) {
    // Draw shadow

    double shadowDiameter = min(size.width, size.height) * 0.85;
    double shadowHeight = shadowDiameter * 0.22;

    canvas.drawOval(
        Offset(offset.dx + size.width / 2.0 - shadowDiameter / 2.0,
                offset.dy + size.height - shadowHeight) &
            Size(shadowDiameter, shadowHeight),
        Paint()
          ..color = Colors.black.withOpacity(0.15)
          ..style = PaintingStyle.fill);

	canvas.translate(0.0, -shadowHeight/1.5);
    Path clip = Path();
    double clipDiameter = min(size.width, size.height);
    clip.addOval(Offset(offset.dx + size.width / 2.0 - clipDiameter / 2.0,
            offset.dy + size.height / 2.0 - clipDiameter / 2.0) &
        Size(clipDiameter, clipDiameter));

    clip.addRect(const Offset(0.0, 0.0) &
        Size(ui.window.physicalSize.width, offset.dy + size.height / 1.25));
    canvas.clipPath(clip);
  }

  @override
  void paintFlare(Canvas canvas, Mat2D viewTransform) {
    _artboard?.draw(canvas);
  }

  @override
  void postPaint(Canvas canvas, Offset offset) {
    if (_artboard == null) {
      return;
    }

    //_artboard.width/2.0
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

    cachedActor(assetBundle, _filename).then((FlutterActor actor) {
      //DesaturatedActor
      //actor.artboard.makeInstance()
      DesaturatedActor desaturatedActor = DesaturatedActor();
      desaturatedActor.copyFlutterActor(actor);
      _artboard = desaturatedActor.artboard
          as FlutterActorArtboard; //(DesaturatedActor());
      //_artboard.copyArtboard(actor.artboard);
      //_artboard = actor.artboard.makeInstance() as FlutterActorArtboard;
	  _artboard.getAnimation("bust")?.apply(0.0, _artboard, 1.0);
      _artboard.initializeGraphics();
      advance(0.0);
      markNeedsPaint();
    });
  }
}
