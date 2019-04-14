import 'package:dev_rpg/src/game_screen/npc_style.dart';
import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/work_item.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_dart/math/aabb.dart';

import 'package:flare_flutter/flare_render_box.dart';

/// Avatar displayed on the hiring page, has clipping and is desaturated.
class WorkTeam extends LeafRenderObjectWidget {
  final BoxFit fit;
  final Alignment alignment;
  final List<Npc> team;
  final WorkItem work;
  const WorkTeam({this.alignment, this.fit, this.team, this.work});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return WorkTeamRenderObject()
      ..fit = fit
      ..alignment = alignment
      ..team = team
      ..assetBundle = DefaultAssetBundle.of(context)
      ..work = work;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant WorkTeamRenderObject renderObject) {
    renderObject
      ..fit = fit
      ..alignment = alignment
      ..team = team
      ..assetBundle = DefaultAssetBundle.of(context)
      ..work = work;
  }

  @override
  void didUnmountRenderObject(covariant WorkTeamRenderObject renderObject) {
    renderObject.dispose();
  }
}

class _WorkTeamMember {
  final FlutterActorArtboard artboard;
  ActorAnimation _animation;
  ActorAnimation _incomingAnimation;
  double _incomingMix = 0.0;
  double _time = 0.0;

  _WorkTeamMember(FlutterActorArtboard sourceArtboard)
      : artboard = sourceArtboard.makeInstance() as FlutterActorArtboard {
    artboard.initializeGraphics();
    artboard.advance(0.0);
    _animation = artboard.getAnimation("idle");
  }

  void advance(double elapsed) {
    _time += elapsed;
    if (_animation != null) {
      _animation.apply(_time % _animation.duration, artboard, 1.0);
    }
    if (_incomingAnimation != null) {
      _incomingMix += elapsed;
      _incomingAnimation.apply(
          _time % _incomingAnimation.duration, artboard, _incomingMix);
      if (_incomingMix >= 1.0) {
        _incomingMix = 0.0;
        _animation = _incomingAnimation;
        _incomingAnimation = null;
      }
    }
    artboard.advance(elapsed);
  }

  void play(String name) {
    ActorAnimation animation = artboard.getAnimation(name);
    if (animation == null) {
      _animation = animation;
    } else {
      _incomingAnimation = animation;
      _incomingMix = 0.0;
    }
  }
}

/// A render object used by the WorkTeam to display a Flare file with clipping
/// around the head to isolate the bust. Also provides a shadow underneath the
/// bust and draws a particle effect when the [hiringState] is set to
/// [WorkTeamState.available]
class WorkTeamRenderObject extends FlareRenderBox {
  List<Npc> _team;
  final List<_WorkTeamMember> _currentTeam = [];
  WorkItem work;
  AABB _aabb;
  @override
  bool get isPlaying => _currentTeam.isNotEmpty;

  List<Npc> get team => _team;
  set team(List<Npc> value) {
    if (_team == value) {
      return;
    }
    _team = value;
    load();
  }

  @override
  bool advance(double elapsedSeconds) {
    if (_currentTeam == null) {
      return isPlaying;
    }

    for (final _WorkTeamMember teamMember in _currentTeam) {
      teamMember.advance(elapsedSeconds);
    }
    return isPlaying;
  }

  /// Provide the correct bounding box for the content we want to draw
  /// in this case it's simply the bounds of the artist defined artboard.
  /// The base FlareRenderBox will use this to compute the correct scale
  /// and translation to apply to the canvas before calling [paintFlare].
  @override
  AABB get aabb => _aabb;

  /// This is called before the canvas is translated and scaled for the
  /// bounds retuerned by the [aabb] getter.
  @override
  void prePaint(Canvas canvas, Offset offset) {
    canvas.clipRect(offset & size);
  }

  @override
  void paintFlare(Canvas canvas, Mat2D viewTransform) {
    if (_currentTeam == null) {
      return;
    }
    for (final _WorkTeamMember teamMember in _currentTeam) {
      teamMember.artboard.draw(canvas);
    }
  }

  /// This is called after we've painted the Flare content, the canvas
  /// is back in widget transform space.
  @override
  void postPaint(Canvas canvas, Offset offset) {}

  /// The FlareRenderBox leaves the responsibility of loading content
  /// to the implementation, so we need to load our content here.
  @override
  void load() {
    super.load();
    if (_team?.isEmpty ?? true) {
      return;
    }

    List<Future<FlutterActor>> futureActors = [];
    for (final Npc npc in _team) {
      final NpcStyle style = NpcStyle.from(npc);

      futureActors.add(loadFlare(style.flare));
    }
    Future.wait(futureActors).then((List<FlutterActor> actors) {
      _aabb = null;
      _currentTeam.clear();
      for (final FlutterActor actor in actors) {
        if (actor == null) {
          continue;
        }
        _currentTeam
            .add(_WorkTeamMember(actor.artboard as FlutterActorArtboard));
        AABB artboardAABB = actor.artboard.artboardAABB();
        if (_aabb == null) {
          _aabb = artboardAABB;
        } else {
          AABB.combine(_aabb, _aabb, artboardAABB);
        }
      }
      advance(0.0);
    });
    // loadFlare(_filename).then((FlutterActor actor) {
    //   if (actor == null) {
    //     return;
    //   }
    //   _actor = DesaturatedActor();
    //   _actor.copyFlutterActor(actor);
    //   _artboard = _actor.artboard as FlutterActorArtboard;
    //   // apply the bust animation state.
    //   _bust = _artboard.getAnimation("bust");
    //   _bust?.apply(0.0, _artboard, 1.0);
    //   _idleAnimation = _artboard.getAnimation("idle");
    //   _artboard.initializeGraphics();
    //   _actor.desaturate = _hiringState != WorkTeamState.hired;

    //   advance(0.0);
    //   markNeedsPaint();
    // });
  }
}
