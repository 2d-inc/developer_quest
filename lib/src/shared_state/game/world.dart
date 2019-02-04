import 'dart:async';

import 'package:dev_rpg/src/shared_state/game/quests.dart';
import 'package:flutter/foundation.dart';

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
    quests.update();

    // We don't notifyListeners here because we changed nothing outside
    // quests (which is a ChangeNotifier itself). When we have some state
    // that changes outside quests, we'll call notifyListeners here as well.
  }
}
