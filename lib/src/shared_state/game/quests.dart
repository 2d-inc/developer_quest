import 'dart:collection';

import 'package:dev_rpg/src/shared_state/game/quest.dart';
import 'package:flutter/foundation.dart';

/// A container of [Quest]s. There is only one of this per world.
///
/// This is better that `List<Quest>` because we can attach behavior
/// to this (like [updateAll]) and only update the widgets once.
class Quests extends ChangeNotifier with ListMixin<Quest> {
  static const _seedQuestNames = [
    "Refactor state management",
    "Add animations",
    "Add tutorial",
    "Find bug #34412",
    "Shorten build time",
    "Add CI",
    "Deploy to TestFlight",
  ];

  final List<Quest> list;

  Quests() : list = _seedQuestNames.map((name) => Quest(name)).toList();

  @override
  int get length => list.length;

  @override
  set length(int newLength) => list.length = newLength;

  @override
  Quest operator [](int index) => list[index];

  @override
  void operator []=(int index, Quest value) => list[index] = value;

  void updateAll() {
    for (final quest in this) {
      quest.update();
    }

    // Notify all widgets that depend on the state of the list.
    notifyListeners();
  }
}
