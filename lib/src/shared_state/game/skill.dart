import 'dart:math';

enum Skill { coding, engineering, ux, coordination }

// get a random set of skills and difficutly values
Map<Skill, double> randomDifficulty(Random randomizer,
    {double maxDifficulty = 100}) {
  Map<Skill, double> difficulty = {};

  // Add one or two skills.
  do {
    var skill = Skill.values[randomizer.nextInt(Skill.values.length)];
    difficulty[skill] = randomizer.nextDouble() * maxDifficulty;
  } while (difficulty.length < 2 && randomizer.nextBool());

  return difficulty;
}
