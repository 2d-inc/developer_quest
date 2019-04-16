import 'package:dev_rpg/src/shared_state/game/npc.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

/// A list of [Npc]s.
class NpcPool extends AspectContainer<Npc> with ChildAspect {
  NpcPool() {
    addAspects([
      Npc("refactorer", {Skill.coding: 1}, true),
      Npc("architect", {Skill.coding: 3, Skill.coordination: 1}),
      Npc("hacker", {Skill.engineering: 2}),
      Npc("tpm", {Skill.coordination: 3}, true),
      Npc("avant_garde_designer", {Skill.engineering: 1}),
      Npc("leo", {Skill.ux: 2}, true),
    ]);
  }

  // get the set of available skills available with the player's hired team
  Set<Skill> get availableSkills => children
      .expand<Skill>((npc) =>
          npc.isHired ? npc.prowess.keys : const Iterable<Skill>.empty())
      .toSet();

  bool _isUpgradeAvailable = false;
  bool get isUpgradeAvailable => _isUpgradeAvailable;

  @override
  void update() {
    int coin = get<World>().company.coin.number;
    bool upgradeAvailable = children.any((npc) => npc.upgradeCost <= coin);
    if (upgradeAvailable != _isUpgradeAvailable) {
      _isUpgradeAvailable = upgradeAvailable;
      markDirty();
    }
    super.update();
  }

  // Mark this Aspect dirty when any child is dirty.
  @override
  bool get inheritsDirt => true;
}
