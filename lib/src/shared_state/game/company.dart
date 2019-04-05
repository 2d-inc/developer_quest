import 'dart:math';

import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// The company the user is playing on behalf of.
/// The company owns resources like experience and coin.
class Company extends Aspect {
  final StatValue<double> joy = StatValue<double>(0);

  final StatValue<double> _users = StatValue<double>(0);

  final StatValue<int> coin = StatValue<int>(1000);

  ValueListenable<String> get users => _users;

  void award(int newUsers, int coinReward) {
    _users.number += newUsers;
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
      joy.number = 0.0;
    }

    _users.number = max(0.0, _users.number + joy.number);
  }
}

/// A value that is shown to the user. It is backed by a [number], and for
/// the purposes of UI repainting it is represented by a [String] (via [value]).
class StatValue<V extends num> extends ChangeNotifier
    implements ValueListenable<String> {
  /// The default formatter of stats. It uses `package:intl`'s
  /// [NumberFormat.compact].
  static final Formatter defaultFormatter = NumberFormat.compact().format;

  /// The current value.
  V _number;

  /// The value that listeners have been provided with most recently.
  ///
  /// This field is used to make sure we don't notify listeners when they're
  /// already showing the most recent value.
  String _shownValue;

  /// The formatter to be used to convert [number] into a String [value].
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

  /// This is the [value] from [ValueListenable]'s contract. The UI will
  /// typically only care about this field.
  @override
  String get value => _shownValue;
}

/// A function that takes a number and returns its string representation.
typedef Formatter = String Function(num);
