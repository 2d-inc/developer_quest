part of task_tree;

const _basicAnimations = TaskBlueprint(
  "Basic Animations",
  {Skill.ux: 100},
  requirements: AnyOf([_programmerArtUI, _basicUI]),
);

const _advancedMotionDesign = TaskBlueprint(
  "Advanced Motion Design",
  {Skill.ux: 200, Skill.coordination: 50},
  requirements: AllOf([_basicAnimations, _basicDesign, _uxTesting]),
);
