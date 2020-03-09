import 'package:dev_rpg/src/shared_state/game/character.dart';
import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/src/aspect_container.dart';
import 'package:dev_rpg/src/shared_state/game/src/child_aspect.dart';
import 'package:dev_rpg/src/shared_state/game/world.dart';

/// A list of [Character]s.
class CharacterPool extends AspectContainer<Character> with ChildAspect {
  CharacterPool() {
    initializeCharacters();
  }

  void initializeCharacters() => setAspects([
        Character('jack', {Skill.coding: 1, Skill.coordination: 1, Skill.ux: 1},
            customHiringCost: 220, costMultiplier: 4),
        Character('sourcerer',
            {Skill.coding: 1, Skill.coordination: 1, Skill.engineering: 1},
            customHiringCost: 220, costMultiplier: 4, bugChanceOffset: -0.02),
        Character('refactorer', {Skill.coding: 1, Skill.engineering: 3}),
        Character('architect', {Skill.coding: 1, Skill.engineering: 4},
            bugChanceOffset: -0.09),
        Character('hacker', {Skill.coding: 3, Skill.engineering: 1},
            bugChanceOffset: 0.03),
        Character('cowboy', {Skill.coding: 4, Skill.engineering: 1},
            bugChanceOffset: 0.6, bugQuantity: 6),
        Character('pm', {Skill.coordination: 3, Skill.ux: 1}),
        Character('uxr', {Skill.coordination: 1, Skill.ux: 3}),
        Character('avant_garde_designer', {Skill.ux: 4}),
        Character('tester', {Skill.coding: 2, Skill.coordination: 1},
            bugChanceOffset: -0.05),
      ]);

  /// Get all the characters that have been hired and are part of the
  /// player's team!
  List<Character> get fullTeam => children.where((c) => c.isHired).toList();

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

  void reset() => initializeCharacters();
}
