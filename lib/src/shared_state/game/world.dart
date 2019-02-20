import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/countdown_clock.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/task_pool.dart';
import 'package:dev_rpg/src/shared_state/game/team_pool.dart';

/// The state of the game world.
///
/// Widgets should subscribe to aspects of the world (such as [taskPool])
/// instead of this whole world unless they really care about every change.
class World extends Aspect {
  static final tickDuration = const Duration(milliseconds: 200);

  Timer _timer;

  final TaskPool taskPool;

  final TeamPool teamPool;

  final CountdownClock countdown;

  World()
      : taskPool = TaskPool(),
        teamPool = TeamPool(),
        countdown = CountdownClock();

  void pause() {
    _timer.cancel();
  }

  void start() {
    _timer = Timer.periodic(tickDuration, _performTick);
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
