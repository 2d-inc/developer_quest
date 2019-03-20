part of task_tree;

const _basicTheme = TaskBlueprint(
  "Basic Theme",
  {Skill.ux: 100, Skill.coordination: 50},
  requirements: AllOf([_alpha]),
);

const _greenTheme = TaskBlueprint(
  "Green Theme",
  {Skill.ux: 50},
  requirements: AllOf([
    _basicTheme,
    Not("Red Theme"),
    Not("Blue Theme"),
  ]),
);

const _redTheme = TaskBlueprint(
  "Red Theme",
  {Skill.ux: 50},
  requirements: AllOf([
    _basicTheme,
    Not("Green Theme"),
    Not("Blue Theme"),
  ]),
);

const _blueTheme = TaskBlueprint(
  "Blue Theme",
  {Skill.ux: 50},
  requirements: AllOf([
    _basicTheme,
    Not("Green Theme"),
    Not("Red Theme"),
  ]),
);
