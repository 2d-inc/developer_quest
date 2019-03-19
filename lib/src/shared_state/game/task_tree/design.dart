part of task_tree;

const _basicDesign = TaskBlueprint(
  "Basic Design",
  {Skill.ux: 100, Skill.coordination: 50},
  requirements: AllOf([_alpha]),
);

const _dinosaurMascot = TaskBlueprint(
  "Dinosaur Mascot & Icon",
  {Skill.coordination: 100, Skill.ux: 50},
  requirements: AllOf([
    _basicDesign,
    Not("Bird Mascot & Icon"),
    Not("Cat Mascot & Icon"),
  ]),
);

const _birdMascot = TaskBlueprint(
  "Bird Mascot & Icon",
  {Skill.coordination: 100, Skill.ux: 50},
  requirements: AllOf([
    _basicDesign,
    Not("Cat Mascot & Icon"),
    Not("Dinosaur Mascot & Icon"),
  ]),
);

const _catMascot = TaskBlueprint(
  "Cat Mascot & Icon",
  {Skill.coordination: 100, Skill.ux: 50},
  requirements: AllOf([
    _basicDesign,
    Not("Bird Mascot & Icon"),
    Not("Dinosaur Mascot & Icon"),
  ]),
);

const _retroDesign = TaskBlueprint(
  "Retro Design",
  {Skill.ux: 100},
  requirements: AllOf([
    _basicDesign,
    Not("Sci-Fi Design"),
    Not("Mainstream Design"),
  ]),
);

const _scifiDesign = TaskBlueprint(
  "Sci-Fi Design",
  {Skill.ux: 100},
  requirements: AllOf([
    _basicDesign,
    Not("Retro Design"),
    Not("Mainstream Design"),
  ]),
);

const _mainstreamDesign = TaskBlueprint(
  "Mainstream Design",
  {Skill.ux: 50},
  requirements: AllOf([
    _basicDesign,
    Not("Sci-Fi Design"),
    Not("Retro Design"),
  ]),
);
