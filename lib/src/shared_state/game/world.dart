import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/quests.dart';
import 'package:flutter/foundation.dart';

/// The state of the game world.
///
/// Widgets should subscribe to aspects of the world (such as [quests])
/// instead of this whole world unless they really care about every change.
class World extends ChangeNotifier {
  Timer timer;

  final Quests quests;

  World() : quests = Quests();

  void pause() {
    timer.cancel();
  }

  void start() {
    timer = Timer.periodic(const Duration(milliseconds: 200), update);
  }

  void update(Timer _) {
    quests.updateAll();

    notifyListeners();
  }
}
