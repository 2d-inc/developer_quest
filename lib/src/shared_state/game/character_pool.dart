import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

/// A list of [Character]s.
class CharacterPool extends AspectContainer<Character> with ChildAspect {
  CharacterPool() {
    addAspects([
      Character("refactorer", {Skill.coding: 1}, true),
      Character("architect", {Skill.coding: 3, Skill.coordination: 1}),
      Character("hacker", {Skill.engineering: 2}),
      Character("tpm", {Skill.coordination: 3}, true),
      Character("avant_garde_designer", {Skill.engineering: 1}),
      Character("leo", {Skill.ux: 2}, true),
    ]);
  }

  // get the set of available skills available with the player's hired team
  Set<Skill> get availableSkills => children
      .expand<Skill>((character) => character.isHired
          ? character.prowess.keys
          : const Iterable<Skill>.empty())
      .toSet();

  bool _isUpgradeAvailable = false;
  bool get isUpgradeAvailable => _isUpgradeAvailable;

  @override
  void update() {
    int coin = get<World>().company.coin.number;
    bool upgradeAvailable =
        children.any((character) => character.upgradeCost <= coin);
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
