import 'dart:collection';

import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';

/// A list of [Npc]s.
class NpcPool extends AspectContainer with ListMixin<Npc>, ChildAspect {
  NpcPool() {
    addAspects([
      Npc("The Refactorer", {Skill.coding: 1}),
      Npc("The Architect", {Skill.coding: 3, Skill.projectManagement: 1}),
      Npc("TPM", {Skill.projectManagement: 3}),
      Npc("Avant Garde Designer", {Skill.design: 1}),
      Npc("Leonardo", {Skill.ux: 2}),
      Npc("Michelangelo", {Skill.design: 2}),
    ]);
  }

  // Mark this Aspect dirty when any child is dirty.
  bool get inheritsDirt => true;

  @override
  int get length => children.length;

  @override
  set length(int value) {
    UnsupportedError("cannot set length of npc pool, wysiwyg");
  }

  @override
  Npc operator [](int index) {
    return children[index];
  }

  @override
  void operator []=(int index, Npc value) {
    UnsupportedError('cannot change a person, freud 3:20');
  }
}
