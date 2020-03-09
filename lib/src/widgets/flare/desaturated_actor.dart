import 'dart:ui' as ui;
import 'package:flare_dart/actor_flags.dart';
import 'package:flare_dart/actor_image.dart';
import 'package:flare_flutter/flare.dart';
import 'package:vector_math/vector_math.dart';

// This is the custom actor shape we create with custom painting
class DesaturatedActor extends FlutterActor {
  bool _desaturate = true;
  bool get desaturate => _desaturate;
  set desaturate(bool value) {
    if (_desaturate == value) {
      return;
    }
    _desaturate = value;
    artboard.addDirt(artboard.root, DirtyFlags.paintDirty, true);
  }

  @override
  ActorImage makeImageNode() {
    return DesaturatedActorImage();
  }
}

/// Custom ActorImage to draw in place of regular Flare ActorImage
/// We use this to override the paint and do custom color filtering.
class DesaturatedActorImage extends FlutterActorImage {
  @override
  void onPaintUpdated(ui.Paint paint) {
    if (!(artboard.actor as DesaturatedActor).desaturate) {
      paint.colorFilter = null;
      return;
    }
    // Light blue tinge.
    ui.Color tint = const ui.Color.fromRGBO(222, 222, 255, 1);
    double rf = tint.red / 255;
    double gf = tint.green / 255;
    double bf = tint.blue / 255;

    Matrix3 greyMatrix = Matrix3.fromList([
      0.21,
      0.75,
      0.077,
      0.21,
      0.75,
      0.077,
      0.21,
      0.75,
      0.077,
    ]);

    Matrix3 tintMatrix = Matrix3.fromList([
      rf,
      0,
      0,
      0,
      gf,
      0,
      0,
      0,
      bf,
    ]);

    greyMatrix.multiply(tintMatrix);
    paint.colorFilter = ui.ColorFilter.matrix([
      greyMatrix[0],
      greyMatrix[1],
      greyMatrix[2],
      0,
      0,
      greyMatrix[3],
      greyMatrix[4],
      greyMatrix[5],
      0,
      0,
      greyMatrix[6],
      greyMatrix[7],
      greyMatrix[8],
      0,
      0,
      0,
      0,
      0,
      1,
      0
    ]);
  }
}
