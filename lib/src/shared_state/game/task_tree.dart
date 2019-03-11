import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_prerequisite.dart';

/// The list of all tasks.
const List<TaskBlueprint> taskTree = [
  _0_pretendotype,
  _0_uiPrototype,
  _0_backendPrototype,
  _0_workingPrototype,
  _0_programmerArtUI,
  _0_basicUI,
  _0_scalableBackend,
  _0_fastBackend,
  _1_alpha,
  _1_basicAnimations,
];

// ignore_for_file: constant_identifier_names

const _0_backendPrototype = TaskBlueprint(
  "Backend Prototype",
  {Skill.coding: 100},
  requirements: AllOf([_0_pretendotype]),
);

const _0_basicUI = TaskBlueprint(
  "Basic UI",
  {Skill.design: 100},
  requirements: AllOf([_0_workingPrototype, Not("Programmer Art UI")]),
);

const _0_fastBackend = TaskBlueprint(
  "Fast Backend",
  {Skill.coding: 100},
  requirements: AllOf([_0_backendPrototype]),
);

const _0_pretendotype = TaskBlueprint(
  "Pretendotype",
  {Skill.design: 50, Skill.ux: 20},
  requirements: none,
);

const _0_programmerArtUI = TaskBlueprint(
  "Programmer Art UI",
  {Skill.coding: 100},
  requirements: AllOf([_0_workingPrototype, Not("Basic UI")]),
);

const _0_scalableBackend = TaskBlueprint(
  "Scalable backend",
  {Skill.coding: 100},
  requirements: AllOf([_0_backendPrototype]),
);

const _0_uiPrototype = TaskBlueprint(
  "UI Prototype",
  {Skill.coding: 100},
  requirements: AllOf([_0_pretendotype]),
);

const _0_workingPrototype = TaskBlueprint(
  "Working Prototype",
  {Skill.coding: 100},
  requirements: AllOf([_0_uiPrototype, _0_backendPrototype]),
);

const _1_alpha = TaskBlueprint(
  "Alpha release",
  {Skill.projectManagement: 100, Skill.coding: 100},
  requirements: AllOf([
    AnyOf([_0_programmerArtUI, _0_basicUI]),
    AnyOf([_0_scalableBackend, _0_fastBackend]),
  ]),
);

const _1_basicAnimations = TaskBlueprint(
  "Basic Animations",
  {Skill.ux: 100, Skill.design: 100},
  requirements: AnyOf([_0_programmerArtUI, _0_basicUI]),
);
