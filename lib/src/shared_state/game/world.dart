import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/countdown_clock.dart';
import 'package:dev_rpg/src/shared_state/game/quests.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/teams.dart';

/// The state of the game world.
///
/// Widgets should subscribe to aspects of the world (such as [quests])
/// instead of this whole world unless they really care about every change.
class World extends Aspect {
  static final tickDuration = const Duration(milliseconds: 200);

  Timer timer;

  final Quests quests;

  final Teams teams;

  final CountdownClock countdown;

  World()
      : quests = Quests(),
        teams = Teams(),
        countdown = CountdownClock();

  void pause() {
    timer.cancel();
  }

  void start() {
    timer = Timer.periodic(tickDuration, _performTick);
  }

  void update() {
    teams.update();
    quests.update();
    countdown.update();

    super.update();
  }

  void _performTick(Timer timer) {
    update();
  }
}
