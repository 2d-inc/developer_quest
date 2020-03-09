library task_tree;

import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_prerequisite.dart';
import 'package:dev_rpg/src/shared_state/game/task_tree/tree_hierarchy.dart';

part 'animations.dart';
part 'backend_infrastructure.dart';
part 'beta.dart';
part 'design.dart';
part 'geolocation.dart';
part 'image_messaging.dart';
part 'launch.dart';
part 'natural_language.dart';
part 'pre_alpha.dart';
part 'pre_launch.dart';
part 'responsive_design.dart';
part 'theme.dart';
part 'ux_testing.dart';

/// The set of all tasks.
const Set<TaskBlueprint> taskTree = {
  // animations.dart
  _basicAnimations,
  _advancedMotionDesign,
  // backend_infrastructure.dart
  _backendInfrastructure,
  _fastBackend,
  _scalableBackend,
  // beta.dart
  _beta,
  // design.dart
  _basicDesign,
  _dinosaurMascot,
  _birdMascot,
  _catMascot,
  _retroDesign,
  _scifiDesign,
  _mainstreamDesign,
  // geolocation.dart
  _geolocation,
  _arMessages,
  // image_messaging.dart
  _simpleImageMessaging,
  _animatedGifSupport,
  _backendImageProcessing,
  _memeGenerator,
  _imageFilters,
  // launch.dart
  _launch,
  // natural_language.dart
  _naturalLanguageGeneration,
  _naturalLanguageUnderstanding,
  _automatedBots,
  _conversationalChatbots,
  // pre_alpha.dart
  _prototype,
  _basicUI,
  _basicBackend,
  _programmerArtUI,
  _alpha,
  // pre_launch.dart
  _backendPerformanceOptimization,
  _backendScalabilityOptimization,
  _prelaunchMarketing,
  _backendHardening,
  _uiPerformanceOptimization,
  _uiPolish,
  // responsive_design.dart
  _responsiveDesign,
  _tabletUI,
  _desktopUI,
  _iOSDesign,
  _webVersion,
  _desktopVersion,
  // theme.dart
  _basicTheme,
  _greenTheme,
  _redTheme,
  _blueTheme,
  // ux_testing.dart
  _uxTesting,
  _foreignLanguageUx,
  _accessibilityUx,
  _internationalization,
  _accessibility,
};

// Store which tasks have been processed as we go to avoid finding
// multiple dependencies which would cause a stack overflow.
// Automatically exclude top level nodes from being found as dependencies
// to other nodes.
Set<TaskBlueprint> _processedTaskTree = {_prototype, _alpha, _beta, _launch};

// Build the top down top level categories.
class TaskNode implements TreeData {
  final TaskBlueprint blueprint;
  @override
  final List<TaskNode> children = [];

  TaskNode(this.blueprint, [bool isTop = false]) {
    _processedTaskTree.add(blueprint);
    // Find tasks that are direct dependents of this task.
    for (final otherBlueprint in taskTree) {
      if (_processedTaskTree.contains(otherBlueprint) ||
          otherBlueprint == blueprint ||
          !otherBlueprint.requirements.isSatisfiedIn([blueprint])) {
        continue;
      }
      children.add(TaskNode(otherBlueprint));
    }

    if (isTop) {
      // Patch remaining items that are satisfied by this full set.
      // We have to do this because some items (like _advancedMotionDesign)
      // are only satisfied when multiple non-direct descendent items in the
      // tree are satisfied.
      //
      // ignore: literal_only_boolean_expressions
      while (true) {
        var patched = false;

        final allPrereqs = allPrerequisites;
        for (final otherBlueprint in taskTree) {
          if (_processedTaskTree.contains(otherBlueprint) ||
              otherBlueprint == blueprint ||
              !otherBlueprint.requirements.isSatisfiedIn(allPrereqs)) {
            continue;
          }
          // This changes the full list of prereqs, so patch again.
          children.add(TaskNode(otherBlueprint));
          patched = true;
          break;
        }
        if (!patched) {
          break;
        }
      }
    }

    children.sort((TaskNode a, TaskNode b) =>
        a.blueprint.priority.compareTo(b.blueprint.priority));
  }

  List<Prerequisite> get allPrerequisites => [blueprint]
    ..addAll(children.expand((child) => child.allPrerequisites).toList());
}

TaskNode prototypeTaskNode = TaskNode(_prototype, true);
TaskNode alphaTaskNode = TaskNode(_alpha, true);
TaskNode betaTaskNode = TaskNode(_beta, true);
TaskNode launchTaskNode = TaskNode(_launch, true);
