part of task_tree;

const _prototype = TaskBlueprint(
  'Prototype',
  {Skill.coding: 30},
  requirements: none,
);

const _basicBackend = TaskBlueprint(
  'Basic Backend',
  {Skill.coding: 100},
  coinReward: 100,
  requirements: AllOf([_prototype]),
  priority: 10,
);

const _basicUI = TaskBlueprint(
  'Basic UI',
  {Skill.ux: 100},
  coinReward: 100,
  requirements: AllOf([_prototype]),
  mutuallyExclusive: ['Programmer Art UI'],
);

const _programmerArtUI = TaskBlueprint(
  'Programmer Art UI',
  {Skill.coding: 100},
  requirements: AllOf([_prototype]),
  mutuallyExclusive: ['Basic UI'],
);

const _alpha =
    TaskBlueprint('Alpha release', {Skill.coordination: 100, Skill.coding: 100},
        requirements: AllOf([
          AnyOf([_programmerArtUI, _basicUI]),
          _basicBackend,
        ]),
        priority: 100,
        coinReward: 500,
        miniGame: MiniGame.chomp);
