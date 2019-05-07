import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/services.dart';

const _filesToWarmup = [
  "assets/flare/CodeIcon.flr",
  "assets/flare/Coin.flr",
  "assets/flare/CoordinationIcon.flr",
  "assets/flare/CowboyCoder.flr",
  "assets/flare/Designer.flr",
  "assets/flare/EngineeringIcon.flr",
  "assets/flare/Joy.flr",
  "assets/flare/NotificationIcon.flr",
  "assets/flare/ProgramManager.flr",
  "assets/flare/SelectArrow.flr",
  "assets/flare/Sourcerer.flr",
  "assets/flare/Tester.flr",
  "assets/flare/TheArchitect.flr",
  "assets/flare/TheHacker.flr",
  "assets/flare/TheJack.flr",
  "assets/flare/TheRefactorer.flr",
  "assets/flare/Users.flr",
  "assets/flare/UxIcon.flr",
  "assets/flare/UXResearcher.flr",
];

/// Ensure all Flare assets used by this app are cached and ready to
/// be displayed as quickly as possible.
Future<void> warmupFlare() async {
  for (final filename in _filesToWarmup) {
    await cachedActor(rootBundle, filename);
    await Future<void>.delayed(const Duration(milliseconds: 16));
  }
}
