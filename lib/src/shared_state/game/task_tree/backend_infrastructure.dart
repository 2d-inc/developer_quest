part of task_tree;

const _backendInfrastructure = TaskBlueprint(
  "Backend Infrastructure",
  {Skill.engineering: 100, Skill.coding: 100},
  requirements: AllOf([_alpha]),
);

const _fastBackend = TaskBlueprint(
  "Fast Backend",
  {Skill.coding: 100},
  requirements: AllOf([_backendInfrastructure]),
);

const _scalableBackend = TaskBlueprint(
  "Scalable backend",
  {Skill.coding: 100},
  requirements: AllOf([_backendInfrastructure]),
);
