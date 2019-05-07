import 'dart:math';

enum Skill { coding, engineering, ux, coordination }

// get a random set of skills and difficutly values
Map<Skill, double> randomDifficulty(
    Random randomizer, Set<Skill> availableSkills,
    {double maxDifficulty = 100}) {
  Map<Skill, double> difficulty = {};

  List<Skill> availableSkillList = availableSkills.toList();

  // Add one or two skills.
  do {
    var skill =
        availableSkillList[randomizer.nextInt(availableSkillList.length)];
    difficulty[skill] = randomizer.nextDouble() * maxDifficulty;
  } while (difficulty.length < 2 && randomizer.nextBool());

  return difficulty;
}
