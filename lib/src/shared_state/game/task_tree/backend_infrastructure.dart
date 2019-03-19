part of task_tree;

const _backendInfrastructure = TaskBlueprint(
  "Backend Infrastructure",
  {Skill.engineering: 100, Skill.coding: 100},
  requirements: AllOf([_alpha]),
);
