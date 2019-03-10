import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

/// The company the user is playing on behalf of.
/// The company owns resources like experience and coin.
class Company extends Aspect {
  double _users = 0.0;
  double _joy = 0.0;

  int _coin = 100;
  int get coin => _coin;
  int get users => _users.floor();
  double get joy => _joy;
  set joy(double value) {
    if (value == _joy) {
      return;
    }
    _joy = value;

    // Generous denorm.
    if (_joy.abs() < 0.01) {
      _joy = 0.0;
    }
    markDirty();
  }

  void award(int newUsers, int coinReward) {
    _users += newUsers;
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

  @override
  update() {
    super.update();

    double oldUsers = _users;
    _users = max(0.0, _users + joy);

    if (oldUsers.floor() != _users.floor()) {
      // Mark dirty if we changed by at least a user.
      markDirty();
    }
  }
}
