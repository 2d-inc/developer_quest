import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

/// The company the user is playing on behalf of.
/// The company owns resources like experience and coin.
class Company extends Aspect {
  int _xp = 0;
  int _coin = 0;
  int get xp => _xp;
  int get coin => _coin;
  void award(int xpReward, int coinReward) {
    _xp += xpReward;
    _coin += coinReward;
    markDirty();
  }

  bool spend(int cost) {
    if (cost > _coin) {
      return false;
    }
    _coin -= cost;
    markDirty();
    return true;
  }
}
