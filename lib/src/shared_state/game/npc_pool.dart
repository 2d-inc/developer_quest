import 'dart:collection';

import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

/// A list of [Npc]s.
class NpcPool extends Aspect with ListMixin<Npc> {
  static const _seedNames = [
    "Martin Aguinis",
    "Shams Zakhour",
    "Kathy Walrath",
    "Nilay Yener",
    "Brett Morgan",
  ];

  final List<Npc> list;

  NpcPool() : list = _seedNames.map((name) => Npc.sample(name)).toList();

  @override
  int get length => list.length;

  @override
  set length(int newLength) {
    list.length = newLength;
    markDirty();
  }

  @override
  Npc operator [](int index) => list[index];

  @override
  void operator []=(int index, Npc value) {
    list[index] = value;
    markDirty();
  }

  void update() {
    for (final npc in this) {
      if (npc.isDirty) markDirty();
      npc.update();
    }

    super.update();
  }
}
