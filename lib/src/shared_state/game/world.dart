import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/countdown_clock.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/team_pool.dart';

/// The state of the game world.
///
/// Widgets should subscribe to aspects of the world (such as [taskPool])
/// instead of this whole world, unless they care about the most high-level
/// stuff (like whether the simulation is running).
class World extends Aspect {
  static final tickDuration = const Duration(milliseconds: 200);

  Timer _timer;

  final TaskPool taskPool;

  final TeamPool teamPool;

  final CountdownClock countdown;

  bool _isRunning = false;

  World()
      : taskPool = TaskPool(),
        teamPool = TeamPool(),
        countdown = CountdownClock();

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
    teamPool.update();
    taskPool.update();
    countdown.update();

    super.update();
  }

  void _performTick(Timer timer) {
    update();
  }
}
