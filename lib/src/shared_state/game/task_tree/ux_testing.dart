part of task_tree;

const _uxTesting = TaskBlueprint(
  'UX Testing',
  {Skill.ux: 100},
  coinReward: 120,
  requirements: AllOf([_alpha]),
);

const _foreignLanguageUx = TaskBlueprint(
  'Foreign Language UX',
  {Skill.ux: 100},
  coinReward: 120,
  requirements: AllOf([_uxTesting]),
);

const _accessibilityUx = TaskBlueprint(
  'Accessibility UX',
  {Skill.ux: 100},
  coinReward: 120,
  requirements: AllOf([_uxTesting]),
);

const _internationalization = TaskBlueprint(
  'Internationalization',
  {Skill.coding: 100, Skill.engineering: 100, Skill.coordination: 50},
  requirements: AllOf([_foreignLanguageUx]),
  coinReward: 120,
);

const _accessibility = TaskBlueprint(
  'Accessibility',
  {Skill.coding: 100, Skill.engineering: 10, Skill.coordination: 50},
  requirements: AllOf([_accessibilityUx]),
  coinReward: 120,
);
