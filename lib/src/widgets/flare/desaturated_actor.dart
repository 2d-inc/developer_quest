import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flare_dart/actor_image.dart';
import 'package:flare_flutter/flare.dart';
import 'package:vector_math/vector_math.dart';

// This is the custom actor shape we create with custom painting
class DesaturatedActor extends FlutterActor {
  @override
  ActorImage makeImageNode() {
    return DesaturatedActorImage();
  }
}

class DesaturatedActorImage extends FlutterActorImage {
  @override
  void onPaintUpdated(ui.Paint paint) {
	  // Light blue tinge.
    //ui.Color tint = const ui.Color.fromRGBO(49*2, 49*2, 61*2, 1.0);
	ui.Color tint = const ui.Color.fromRGBO(222, 222, 255, 1.0);
    double rf = tint.red / 255.0;
    double gf = tint.green / 255.0;
    double bf = tint.blue / 255.0;

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
      0.0,
      0.0,

      0.0,
      gf,
      0.0,

      0.0,
      0.0,
      bf,
    ]);

	greyMatrix.multiply(tintMatrix);
    paint.colorFilter = ui.ColorFilter.matrix([
      greyMatrix[0],
      greyMatrix[1],
      greyMatrix[2],
      0.0,
      0.0,
      greyMatrix[3],
      greyMatrix[4],
      greyMatrix[5],
      0.0,
      0.0,
      greyMatrix[6],
      greyMatrix[7],
      greyMatrix[8],
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
