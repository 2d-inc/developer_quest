import 'dart:collection';

import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

/// A list of [Npc]s.
class NpcPool extends Aspect with ListMixin<Npc> {
  final List<Npc> list;

  NpcPool()
      : list = [
          Npc("The Refactorer", {Skill.coding: 1}),
          Npc("The Architect", {Skill.coding: 3, Skill.projectManagement: 1}),
          Npc("TPM", {Skill.projectManagement: 3}),
          Npc("Avant Garde Designer", {Skill.design: 1}),
          Npc("Leonardo", {Skill.ux: 2}),
          Npc("Michelangelo", {Skill.design: 2}),
        ];

  void update() {
    for (final npc in list) {
      if (npc.isDirty) markDirty();
      npc.update();
    }

    super.update();
  }

  @override
  int get length => list.length;

  @override
  set length(int value) {
    UnsupportedError("cannot set length of npc pool, wysiwyg");
  }

  @override
  Npc operator [](int index) {
    return list[index];
  }

  @override
  void operator []=(int index, Npc value) {
    UnsupportedError('cannot change a person, freud 3:20');
  }
}
