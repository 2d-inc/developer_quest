import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';

/// A list of [Npc]s.
class NpcPool extends AspectContainer<Npc> with ChildAspect {
  NpcPool() {
    addAspects([
      Npc("The Refactorer", {Skill.coding: 1}, true),
      Npc("The Architect", {Skill.coding: 3, Skill.coordination: 1}),
      Npc("TPM", {Skill.coordination: 3}, true),
      Npc("Avant Garde Designer", {Skill.engineering: 1}),
      Npc("Leonardo", {Skill.ux: 2}, true),
      Npc("Michelangelo", {Skill.engineering: 2}),
    ]);
  }

  // get the set of available skills available with the player's hired team
  Set<Skill> get availableSkills => children
      .expand<Skill>((npc) =>
          npc.isHired ? npc.prowess.keys : const Iterable<Skill>.empty())
      .toSet();

  // Mark this Aspect dirty when any child is dirty.
  @override
  bool get inheritsDirt => true;
}
