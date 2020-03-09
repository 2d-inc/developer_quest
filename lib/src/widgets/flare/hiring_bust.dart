import 'dart:math';

import 'package:dev_rpg/src/widgets/flare/desaturated_actor.dart';
import 'package:dev_rpg/src/widgets/flare/hiring_particles.dart';
import 'package:dev_rpg/src/style.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_dart/math/aabb.dart';
import 'package:flare_flutter/flare_render_box.dart';

/// The HiringBust displays three different visual states.
/// [locked] is for when the character is not available for hire,
/// because presumably the user doesn't have the resources to hire them.
/// [available] is for when the character can be hired, but has not been yet.
/// [hired] is for when the character has been added to the team.
enum HiringBustState { locked, available, hired, working, success }

/// Avatar displayed on the hiring page, has clipping and is desaturated.
class HiringBust extends LeafRenderObjectWidget {
  final BoxFit fit;
  final Alignment alignment;
  final HiringBustState hiringState;
  final String filename;
  final bool isPlaying;
  final Color particleColor;

  const HiringBust(
      {this.fit = BoxFit.contain,
      this.alignment = Alignment.center,
      this.hiringState,
      this.filename,
      this.particleColor,
      this.isPlaying = false});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return HiringBustRenderObject()
      ..particleColor = particleColor
      ..assetBundle = DefaultAssetBundle.of(context)
      ..filename = filename
      ..fit = fit
      ..alignment = alignment
      ..hiringState = hiringState
      ..playIdleAnimation = isPlaying
      ..isPlaying = isPlaying || hiringState == HiringBustState.available;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant HiringBustRenderObject renderObject) {
    renderObject
      ..particleColor = particleColor
      ..assetBundle = DefaultAssetBundle.of(context)
      ..filename = filename
      ..fit = fit
      ..hiringState = hiringState
      ..alignment = alignment
      ..playIdleAnimation = isPlaying
      ..isPlaying = isPlaying || hiringState == HiringBustState.available;
  }

  @override
  void didUnmountRenderObject(covariant HiringBustRenderObject renderObject) {
    renderObject.dispose();
  }
}

/// A render object used by the HiringBust to display a Flare file with clipping
/// around the head to isolate the bust. Also provides a shadow underneath the
/// bust and draws a particle effect when the [hiringState] is set to
/// [HiringBustState.available]
class HiringBustRenderObject extends FlareRenderBox {
  FlutterActorArtboard _artboard;
  String _filename;
  HiringBustState _hiringState;
  DesaturatedActor _actor;
  HiringParticles _particles;
  bool _isPlaying;
  @override
  bool get isPlaying => _isPlaying;

  set isPlaying(bool value) {
    if (value == _isPlaying) {
      return;
    }
    _isPlaying = value;
    updatePlayState();
  }

  ActorAnimation _idleAnimation;
  double _idleTime = 0;
  Color particleColor;
  bool playIdleAnimation = false;

  ActorAnimation _bust;

  HiringBustState get hiringState => _hiringState;
  set hiringState(HiringBustState value) {
    if (_hiringState == value) {
      return;
    }
    _hiringState = value;
    _updateState();
    if (value == HiringBustState.available) {
      _particles = HiringParticles(color: particleColor);
      markNeedsLayout();
    } else {
      _particles = null;
    }
  }

  void _updateState() {
    if (_artboard != null) {
      switch (_hiringState) {
        case HiringBustState.working:
          _idleAnimation = _artboard.getAnimation('working');
          break;
        case HiringBustState.success:
          _idleAnimation = _artboard.getAnimation('success');
          break;
        default:
          _idleAnimation = _artboard.getAnimation('idle');
          break;
      }
    }

    _actor?.desaturate = _hiringState == HiringBustState.locked ||
        _hiringState == HiringBustState.available;
    advance(0);
    markNeedsPaint();
  }

  double get shadowWidth => min(size.width, size.height) * 0.85;
  double get shadowHeight => shadowWidth * 0.22;

  @override
  bool advance(double elapsedSeconds) {
    if (playIdleAnimation && _idleAnimation != null) {
      _idleTime += elapsedSeconds;
      _idleAnimation.apply(_idleTime % _idleAnimation.duration, _artboard, 1);
      _bust?.apply(0, _artboard, 1);
    }
    _artboard?.advance(elapsedSeconds);
    _particles?.advance(elapsedSeconds, Size(shadowWidth, size.height));
    return isPlaying;
  }

  @override
  void performLayout() {
    super.performLayout();
    _particles?.particleSize =
        (size.width / idealCharacterWidth) * idealParticleSize;
  }

  /// Provide the correct bounding box for the content we want to draw
  /// in this case it's simply the bounds of the artist defined artboard.
  /// The base FlareRenderBox will use this to compute the correct scale
  /// and translation to apply to the canvas before calling [paintFlare].
  @override
  AABB get aabb => _artboard?.artboardAABB();

  /// This is called before the canvas is translated and scaled for the
  /// bounds retuerned by the [aabb] getter.
  @override
  void prePaint(Canvas canvas, Offset offset) {
    // Use this opportunity to draw the shadow under the bust.

    double shadowDiameter = shadowWidth;

    canvas.drawOval(
        Offset(offset.dx + size.width / 2 - shadowDiameter / 2,
                offset.dy + size.height - shadowHeight) &
            Size(shadowDiameter, shadowHeight),
        Paint()
          ..color = _hiringState == HiringBustState.available
              ? const Color.fromRGBO(84, 114, 239, 0.26)
              : Colors.black.withOpacity(0.15)
          ..style = PaintingStyle.fill);

    canvas.translate(0, -shadowHeight / 1.5);
    Path clip = Path();
    double clipDiameter = min(size.width, size.height);
    clip.addOval(Offset(offset.dx + size.width / 2 - clipDiameter / 2,
            offset.dy + size.height / 2 - clipDiameter / 2) &
        Size(clipDiameter, clipDiameter));

    // There's something about using a large clipping area that seems to
    // negatively affect performance. Keeping this here as reference for the
    // intended look of the app.
    // clip.addRect(const Offset(0, 0) &
    //     Size(ui.window.physicalSize.width, offset.dy + size.height / 1.25));
    canvas.clipPath(clip);
  }

  @override
  void paintFlare(Canvas canvas, Mat2D viewTransform) {
    _artboard?.draw(canvas);
  }

  /// This is called after we've painted the Flare content, the canvas
  /// is back in widget transform space.
  @override
  void postPaint(Canvas canvas, Offset offset) {
    _particles?.paint(canvas,
        offset + Offset((size.width - shadowWidth) / 2, -shadowHeight / 2));
  }

  String get filename => _filename;
  set filename(String value) {
    if (_filename == value) {
      return;
    }
    _filename = value;
    load();
  }

  /// The FlareRenderBox leaves the responsibility of loading content
  /// to the implementation, so we need to load our content here.
  @override
  Future<void> load() async {
    FlutterActor actor = await loadFlare(_filename);
    if (actor == null) {
      return;
    }
    _actor = DesaturatedActor();
    _actor.copyFlutterActor(actor);
    _artboard = _actor.artboard as FlutterActorArtboard;
    // apply the bust animation state.
    _bust = _artboard.getAnimation('bust');
    _bust?.apply(0, _artboard, 1);

    _artboard.initializeGraphics();
    _updateState();

    advance(0);
    markNeedsPaint();
  }
}
