part of task_tree;

const _basicAnimations = TaskBlueprint(
  'Basic Animations',
  {Skill.ux: 100},
  coinReward: 200,
  requirements: AllOf([_alpha]),
);

const _advancedMotionDesign = TaskBlueprint(
  'Advanced Motion Design',
  {Skill.ux: 200, Skill.coordination: 50},
  coinReward: 400,
  requirements: AllOf([_basicAnimations, _basicDesign, _uxTesting]),
);
