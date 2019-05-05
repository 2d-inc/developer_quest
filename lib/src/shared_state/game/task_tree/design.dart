part of task_tree;

const _basicDesign = TaskBlueprint(
  'Basic Design',
  {Skill.ux: 100, Skill.coordination: 50},
  requirements: AllOf([_alpha]),
  priority: 50,
);

const _dinosaurMascot = TaskBlueprint(
  'Dinosaur Mascot & Icon',
  {Skill.coordination: 100, Skill.ux: 50},
  coinReward: 250,
  requirements: AllOf([_basicDesign]),
  mutuallyExclusive: ['Bird Mascot & Icon', 'Cat Mascot & Icon'],
  priority: 10,
);

const _birdMascot = TaskBlueprint(
  'Bird Mascot & Icon',
  {Skill.coordination: 100, Skill.ux: 50},
  coinReward: 250,
  requirements: AllOf([_basicDesign]),
  mutuallyExclusive: ['Cat Mascot & Icon', 'Dinosaur Mascot & Icon'],
  priority: 10,
);

const _catMascot = TaskBlueprint(
  'Cat Mascot & Icon',
  {Skill.coordination: 100, Skill.ux: 50},
  coinReward: 250,
  requirements: AllOf([_basicDesign]),
  mutuallyExclusive: ['Bird Mascot & Icon', 'Dinosaur Mascot & Icon'],
  priority: 10,
);

const _retroDesign = TaskBlueprint(
  'Retro Design',
  {Skill.ux: 100},
  coinReward: 250,
  requirements: AllOf([_basicDesign]),
  mutuallyExclusive: ['Sci-Fi Design', 'Mainstream Design'],
  priority: 10,
);

const _scifiDesign = TaskBlueprint(
  'Sci-Fi Design',
  {Skill.ux: 100},
  coinReward: 250,
  requirements: AllOf([_basicDesign]),
  mutuallyExclusive: ['Retro Design', 'Mainstream Design'],
  priority: 10,
);

const _mainstreamDesign = TaskBlueprint(
  'Mainstream Design',
  {Skill.ux: 50},
  coinReward: 250,
  requirements: AllOf([_basicDesign]),
  mutuallyExclusive: ['Sci-Fi Design', 'Retro Design'],
  priority: 10,
);
