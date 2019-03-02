import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/npc_pool.dart';
import 'package:dev_rpg/src/shared_state/game/project_pool.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

/// The state of the game world.
///
/// Widgets should subscribe to aspects of the world (such as [projectPool])
/// instead of this whole world, unless they care about the most high-level
/// stuff (like whether the simulation is running).
class World extends Aspect {
  static final tickDuration = const Duration(milliseconds: 200);

  Timer _timer;

  final ProjectPool projectPool;

  final NpcPool npcPool;
  bool _isRunning = false;

  World()
      : npcPool = NpcPool(),
        projectPool = ProjectPool();

  /// Returns `true` when the simulation is currently running.
  bool get isRunning => _isRunning;

  void pause() {
    _timer.cancel();
    _isRunning = false;
    markDirty();
  }

  void start() {
    _timer = Timer.periodic(tickDuration, _performTick);
    _isRunning = true;
    markDirty();
  }

  void update() {
    npcPool.update();
    projectPool.update();

    super.update();
  }

  void _performTick(Timer timer) {
    update();
  }
}
