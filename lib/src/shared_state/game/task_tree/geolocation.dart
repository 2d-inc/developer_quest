part of task_tree;

const _geolocation = TaskBlueprint(
  'Geolocation',
  {Skill.engineering: 100, Skill.coding: 50},
  coinReward: 300,
  requirements: AllOf([_alpha]),
);

const _arMessages = TaskBlueprint(
  'AR Messages',
  {Skill.engineering: 50, Skill.coding: 100},
  coinReward: 300,
  requirements: AllOf([_geolocation]),
);
