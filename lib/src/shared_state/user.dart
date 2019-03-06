import 'package:flutter/foundation.dart';

class User extends ChangeNotifier {
  final String name = "Daring Developer";
  int _xp = 0;
  int _coin = 0;
  int get xp => _xp;
  int get coin => _coin;

  @override
  String toString() => name;

  void award(int xpReward, int coinReward) {
    _xp += xpReward;
    _coin += coinReward;
    notifyListeners();
  }

  void spend(int cost) {
    _coin -= cost;
    notifyListeners();
  }
}
