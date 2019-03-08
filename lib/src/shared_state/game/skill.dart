import 'dart:math';

enum Skill { coding, design, ux, projectManagement }

// get a random set of skills and difficutly values
Map<Skill, double> randomDifficulty(Random randomizer,
    {double maxDifficulty = 100}) {
  Map<Skill, double> difficulty = {};

  for (Skill skill in Skill.values) {
    if (randomizer.nextBool()) {
      difficulty[skill] = randomizer.nextDouble() * maxDifficulty;
      if (difficulty.length == 2) {
        // don't allow more than 2 required skills
        break;
      }
    }
  }

  if (difficulty.isEmpty) {
    difficulty[Skill.coding] = 20.0;
  }
  return difficulty;
}
