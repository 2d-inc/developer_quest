import 'dart:ui' as ui;
import 'package:flare_dart/actor_image.dart';
import 'package:flare_flutter/flare.dart';

class DesaturatedActor extends FlutterActor {
  @override
  ActorImage makeImageNode() {
    return DesaturatedActorImage();
  }
}

// This is the custom actor shape we create with mount options
class DesaturatedActorImage extends FlutterActorImage {
  @override
  void onPaintUpdated(ui.Paint paint) {
// SkPaint paint;
// paint.setColorFilter(SkColorFilter::MakeMatrixFilterRowMajor255(grayscale));

    paint.colorFilter = const ui.ColorFilter.matrix([
      0.21,
      0.72,
      0.07,
      0.0,
      0.0,
      0.21,
      0.72,
      0.07,
      0.0,
      0.0,
      0.21,
      0.72,
      0.07,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0
    ]);
  }
}
