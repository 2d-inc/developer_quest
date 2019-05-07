part of task_tree;

const _responsiveDesign = TaskBlueprint(
  'Responsive Design',
  {Skill.ux: 100, Skill.coordination: 50, Skill.engineering: 50},
  requirements: AllOf([_basicDesign]),
  coinReward: 150,
);

const _tabletUI = TaskBlueprint(
  'Tablet UI',
  {Skill.ux: 100, Skill.coding: 50},
  requirements: AllOf([_basicDesign]),
  coinReward: 150,
);

const _desktopUI = TaskBlueprint(
  'Desktop UI',
  {Skill.ux: 100, Skill.coding: 50},
  requirements: AllOf([_basicDesign]),
  coinReward: 250,
);

const _iOSDesign = TaskBlueprint(
  'Custom iOS Design',
  {Skill.ux: 100, Skill.coding: 50},
  requirements: AllOf([_basicDesign]),
  coinReward: 150,
);

const _webVersion = TaskBlueprint(
  'Web Version',
  {Skill.coding: 100, Skill.ux: 50},
  requirements: AllOf([_desktopUI]),
  coinReward: 350,
);

const _desktopVersion = TaskBlueprint(
  'Desktop Version',
  {Skill.coding: 100, Skill.ux: 50},
  requirements: AllOf([_desktopUI]),
  coinReward: 350,
);
