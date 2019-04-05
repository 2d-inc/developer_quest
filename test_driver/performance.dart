import 'package:dev_rpg/main.dart' as app;
import 'package:dev_rpg/src/shared_state/game/world.dart';
import 'package:flutter_driver/driver_extension.dart';

void main() {
  enableFlutterDriverExtension();
  // Make the simulation faster, about one update every 2 frames.
  World.tickDuration = const Duration(milliseconds: 1000 ~/ 30);
  app.main();
}
