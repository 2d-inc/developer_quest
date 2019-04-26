part of task_tree;

const _responsiveDesign = TaskBlueprint(
  'Responsive Design',
  {Skill.ux: 100, Skill.coordination: 50, Skill.engineering: 50},
  requirements: AllOf([_basicDesign]),
);

const _tabletUI = TaskBlueprint(
  'Tablet UI',
  {Skill.ux: 100, Skill.coding: 50},
  requirements: AllOf([_basicDesign]),
);

const _desktopUI = TaskBlueprint(
  'Desktop UI',
  {Skill.ux: 100, Skill.coding: 50},
  requirements: AllOf([_basicDesign]),
);

const _iOSDesign = TaskBlueprint(
  'Custom iOS Design',
  {Skill.ux: 100, Skill.coding: 50},
  requirements: AllOf([_basicDesign]),
);

const _webVersion = TaskBlueprint(
  'Web Version',
  {Skill.coding: 100, Skill.ux: 50},
  requirements: AllOf([_desktopUI]),
);

const _desktopVersion = TaskBlueprint(
  'Desktop Version',
  {Skill.coding: 100, Skill.ux: 50},
  requirements: AllOf([_desktopUI]),
);
