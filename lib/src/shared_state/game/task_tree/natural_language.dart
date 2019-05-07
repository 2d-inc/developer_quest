part of task_tree;

const _naturalLanguageGeneration = TaskBlueprint(
  'Natural Language Generation',
  {Skill.engineering: 100, Skill.coding: 100},
  coinReward: 350,
  requirements: AllOf([_alpha]),
);

const _naturalLanguageUnderstanding = TaskBlueprint(
  'Natural Language Understanding',
  {Skill.engineering: 200, Skill.coding: 100},
  coinReward: 350,
  requirements: AllOf([_alpha]),
);

const _automatedBots = TaskBlueprint(
  'Automated Bots',
  {Skill.coding: 100, Skill.ux: 50},
  coinReward: 350,
  requirements: AllOf([_naturalLanguageGeneration]),
);

const _conversationalChatbots = TaskBlueprint(
  'Conversational Chatbots',
  {Skill.coding: 200, Skill.ux: 50},
  coinReward: 350,
  requirements:
      AllOf([_naturalLanguageGeneration, _naturalLanguageUnderstanding]),
);
