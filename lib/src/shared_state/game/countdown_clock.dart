import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

class CountdownClock extends Aspect {
  Duration remainingTime = Duration(minutes: 10);

  void update() {
    remainingTime -= World.tickDuration;
    markDirty();
    super.update();
  }
}
