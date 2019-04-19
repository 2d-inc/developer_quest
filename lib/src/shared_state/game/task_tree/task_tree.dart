library task_tree;

import 'package:dev_rpg/src/shared_state/game/skill.dart';
import 'package:dev_rpg/src/shared_state/game/task_blueprint.dart';
import 'package:dev_rpg/src/shared_state/game/task_prerequisite.dart';

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
Set<TaskBlueprint> _processedTaskTree = {};

// Build the top down top level categories.
class TaskNode {
  final TaskBlueprint blueprint;
  final List<TaskNode> children = [];
  TaskNode(this.blueprint) {
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
  }

  void _output([int depth = 0]) {
    String line = "-";
    for (int i = 0; i < depth; i++) {
      line += "-";
    }
    print("$line ${blueprint.name}");
    for (final child in children) {
      child._output(depth + 1);
    }
  }
}

TaskNode prototypeTaskNode = TaskNode(_prototype);
TaskNode alphaTaskNode = TaskNode(_alpha);
TaskNode betaTaskNode = TaskNode(_beta);
TaskNode launchTaskNode = TaskNode(_launch);

//TaskNode r = TaskNode(_launch);
void outputTest() {
  print("");
  prototypeTaskNode._output();
  print("Launch Prototype Minigame");

  print("");
  alphaTaskNode._output();
  print("Launch Alpha Minigame");

  print("");
  betaTaskNode._output();
  print("Launch Beta Minigame");

  print("");
  launchTaskNode._output();
  print("Launch 1.0 Minigame");
}
