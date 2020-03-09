import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// The company the user is playing on behalf of.
///
/// The company owns [coin], and generates [joy] for its [users].
class Company extends AspectContainer {
  static const int _initialCoin = 540;

  final StatValue<double> users;

  final StatValue<double> joy;

  final StatValue<int> coin;

  Company()
      : users = StatValue<double>(0),
        joy = StatValue<double>(0),
        coin = StatValue<int>(_initialCoin) {
    addAspect(users);
    addAspect(joy);
    addAspect(coin);
  }

  double maxUsers = 0;

  /// Star rating out of 5. Based on users lost, which is a consequence of
  /// bugs not resolved in a timely manner.
  /// Since it's inevitable to lose some, we consider losing 5%
  /// exceptional.
  int get starRating =>
      ((users.number / maxUsers / 0.95).clamp(0, 1) * 4).round();

  void award(int newUsers, int coinReward) {
    users.number += newUsers;
    coin.number += coinReward;
  }

  bool spend(int cost) {
    if (cost > coin.number) {
      return false;
    }
    coin.number -= cost;
    markDirty();
    return true;
  }

  @override
  void update() {
    super.update();

    // Generous denorm.
    if (joy.number.abs() < 0.01) {
      joy.number = 0;
    }

    users.number = max(0, users.number + joy.number);
    maxUsers = max(maxUsers, users.number);
  }

  void reset() {
    joy.number = 0;
    users.number = 0;
    maxUsers = 0;
    coin.number = _initialCoin;
  }
}

/// A value that is shown to the user. It is backed by a [number], and for
/// the purposes of UI repainting it is represented by a [String]
/// (via [string]).
class StatValue<V extends num> extends Aspect
    implements ValueListenable<String> {
  /// The default formatter of stats. It uses `package:intl`'s
  /// [NumberFormat.compact].
  static final Formatter<num> defaultFormatter = NumberFormat.compact().format;

  /// The current value.
  V _number;

  /// The value that listeners have been provided with most recently.
  ///
  /// This field is used to make sure we don't notify listeners when they're
  /// already showing the most recent value.
  String _shownValue;

  /// The formatter to be used to convert [number] into a String [string].
  final String Function(V) formatter;

  StatValue(this._number, {Formatter statFormatter})
      : assert(_number != null),
        formatter = statFormatter ?? StatValue.defaultFormatter {
    _shownValue = formatter(_number);
  }

  V get number => _number;

  set number(V newValue) {
    if ((newValue == 0 && _number != 0) || (newValue.sign != _number.sign)) {
      // Special case for significant value changes.
      _number = newValue;
      _shownValue = formatter(newValue);
      notifyListeners();
      return;
    }

    var newShownValue = formatter(newValue);

    if (newShownValue == _shownValue) {
      // Only update value, don't notify listeners.
      _number = newValue;
      return;
    }

    _number = newValue;
    _shownValue = newShownValue;
    notifyListeners();
  }

  @override
  String get value => _shownValue;
}

/// A function that takes a number and returns its string representation.
typedef Formatter<T extends num> = String Function(T);
