part of task_tree;

const _basicTheme = TaskBlueprint(
  'Basic Theme',
  {Skill.ux: 100, Skill.coordination: 50},
  requirements: AllOf([_alpha]),
  coinReward: 250,
  priority: 50,
);

const _greenTheme = TaskBlueprint(
  'Green Theme',
  {Skill.ux: 50},
  requirements: AllOf([_basicTheme]),
  mutuallyExclusive: ['Red Theme', 'Blue Theme'],
  coinReward: 250,
  priority: 10,
);

const _redTheme = TaskBlueprint(
  'Red Theme',
  {Skill.ux: 50},
  requirements: AllOf([_basicTheme]),
  mutuallyExclusive: ['Green Theme', 'Blue Theme'],
  coinReward: 250,
  priority: 10,
);

const _blueTheme = TaskBlueprint(
  'Blue Theme',
  {Skill.ux: 50},
  requirements: AllOf([_basicTheme]),
  mutuallyExclusive: ['Green Theme', 'Red Theme'],
  coinReward: 250,
  priority: 10,
);
