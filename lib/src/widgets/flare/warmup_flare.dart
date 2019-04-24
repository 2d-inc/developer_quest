import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/services.dart';

/// Ensure all Flare assets used by this app are cached and ready to
/// be displayed as quickly as possible.
void warmupFlare() {
  var warmup = [
    "assets/flare/CodeIcon.flr",
    "assets/flare/Coin.flr",
    "assets/flare/CoordinationIcon.flr",
    "assets/flare/CowboyCoder.flr",
    "assets/flare/Designer.flr",
    "assets/flare/EngineeringIcon.flr",
    "assets/flare/Joy.flr",
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
  warmup.forEach(
    (filename) => cachedActor(rootBundle, filename).then((_) {
          // Intentionally empty, Flare file is now in cache.
        }),
  );
}
