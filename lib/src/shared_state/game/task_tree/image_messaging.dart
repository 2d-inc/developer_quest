part of task_tree;

const _simpleImageMessaging = TaskBlueprint(
  'Simple Image Messaging',
  {Skill.engineering: 100, Skill.coding: 50, Skill.ux: 50},
  coinReward: 200,
  requirements: AllOf([_alpha]),
);

const _animatedGifSupport = TaskBlueprint(
  'Animated GIF Support',
  {Skill.engineering: 50, Skill.coding: 100},
  coinReward: 200,
  requirements: AllOf([_simpleImageMessaging]),
);

const _backendImageProcessing = TaskBlueprint(
  'Backend Image Processing',
  {Skill.engineering: 50, Skill.coding: 100},
  coinReward: 200,
  requirements: AllOf([_simpleImageMessaging, _backendInfrastructure]),
);

const _memeGenerator = TaskBlueprint(
  'Meme Generator',
  {Skill.coding: 50, Skill.ux: 50, Skill.coordination: 50},
  coinReward: 200,
  requirements: AllOf([_simpleImageMessaging, _backendImageProcessing]),
);

const _imageFilters = TaskBlueprint(
  'Image Filters',
  {Skill.coding: 50, Skill.ux: 50},
  coinReward: 200,
  requirements: AllOf([_backendImageProcessing, _backendInfrastructure]),
);
