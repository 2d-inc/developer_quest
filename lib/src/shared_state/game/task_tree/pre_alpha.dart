part of task_tree;

const _backendPrototype = TaskBlueprint(
  "Backend Prototype",
  {Skill.coding: 100},
  requirements: AllOf([_pretendotype]),
);

const _basicUI = TaskBlueprint(
  "Basic UI",
  {Skill.ux: 100},
  requirements: AllOf([_workingPrototype, Not("Programmer Art UI")]),
);

const _fastBackend = TaskBlueprint(
  "Fast Backend",
  {Skill.coding: 100},
  requirements: AllOf([_backendPrototype]),
);

const _pretendotype = TaskBlueprint(
  "Pretendotype",
  {Skill.ux: 50, Skill.coordination: 20},
  requirements: none,
);

const _programmerArtUI = TaskBlueprint(
  "Programmer Art UI",
  {Skill.coding: 100},
  requirements: AllOf([_workingPrototype, Not("Basic UI")]),
);

const _scalableBackend = TaskBlueprint(
  "Scalable backend",
  {Skill.coding: 100},
  requirements: AllOf([_backendPrototype]),
);

const _uiPrototype = TaskBlueprint(
  "UI Prototype",
  {Skill.coding: 100},
  requirements: AllOf([_pretendotype]),
);

const _workingPrototype = TaskBlueprint(
  "Working Prototype",
  {Skill.coding: 100},
  requirements: AllOf([_uiPrototype, _backendPrototype]),
);

const _alpha = TaskBlueprint(
  "Alpha release",
  {Skill.coordination: 100, Skill.coding: 100},
  requirements: AllOf([
    AnyOf([_programmerArtUI, _basicUI]),
    AnyOf([_scalableBackend, _fastBackend]),
  ]),
);
