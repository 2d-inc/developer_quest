import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/quests.dart';
import 'package:dev_rpg/src/shared_state/game/teams.dart';
import 'package:flutter/foundation.dart';

/// The state of the game world.
///
/// Widgets should subscribe to aspects of the world (such as [quests])
/// instead of this whole world unless they really care about every change.
class World extends ChangeNotifier {
  Timer timer;

  final Quests quests;

  final Teams teams;

  World()
      : quests = Quests(),
        teams = Teams();

  void pause() {
    timer.cancel();
  }

  void start() {
    timer = Timer.periodic(const Duration(milliseconds: 200), update);
  }

  void update(Timer _) {
    teams.updateAll();
    quests.updateAll();

    notifyListeners();
  }
}
