import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:flutter/foundation.dart';

class CountdownClock extends ChangeNotifier {
  Duration remainingTime = Duration(minutes: 10);

  void update() {
    remainingTime -= World.tickDuration;
    notifyListeners();
  }
}
