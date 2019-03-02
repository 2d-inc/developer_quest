import 'dart:collection';

import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect.dart';

/// A list of [Npc]s.
class NpcPool extends Aspect with ListMixin<Npc> {
  final List<Npc> list;

  NpcPool()
      : list = [
          Npc("The Refactorer", {Skill.Coding: 1}),
          Npc("The Architect", {Skill.Coding: 3, Skill.ProjectManagement: 1}),
          Npc("TPM", {Skill.ProjectManagement: 3}),
          Npc("Avant Garde Designer", {Skill.Design: 1}),
          Npc("Leonardo", {Skill.UX: 2}),
          Npc("Michelangelo", {Skill.Design: 2})
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
  set length(int value) { UnsupportedError("cannot set length of npc pool, wysiwyg"); }

  @override
  Npc operator [](int index) {
    return list[index];
  }

  @override
  void operator []=(int index, Npc value) {
    UnsupportedError("cannot change a person, freud 3:20");
  }
}
