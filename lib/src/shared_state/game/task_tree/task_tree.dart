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
