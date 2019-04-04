import 'dart:math';
import 'dart:ui';

import 'package:dev_rpg/src/shared_state/game/npc.dart';

/// UI style properties for [Npc]s. [Npc] to [NpcStyle] mapping is done via
/// [Npc.id] values.
class NpcStyle {
  final String flare;
  final Color accent;
  final String name;

  static final Map<String, NpcStyle> _all = {
    "refactorer": NpcStyle(
        name: "The Refactorer",
        flare: "assets/flare/TheRefactorer.flr",
        accent: const Color.fromRGBO(75, 58, 185, 1.0)),
    "architect": NpcStyle(
        name: "The Architect",
        flare: "assets/flare/TheArchitect.flr",
        accent: const Color.fromRGBO(236, 41, 117, 1.0)),
    "tpm": NpcStyle(
        name: "TPM",
        flare: "assets/flare/TheRefactorer.flr",
        accent: const Color.fromRGBO(75, 58, 185, 1.0)),
    "avant_garde_designer": NpcStyle(
        name: "Avant Garde Designer",
        flare: "assets/flare/TheArchitect.flr",
        accent: const Color.fromRGBO(236, 41, 117, 1.0)),
    "leo": NpcStyle(
        name: "Leonardo",
        flare: "assets/flare/TheRefactorer.flr",
        accent: const Color.fromRGBO(75, 58, 185, 1.0)),
    "mike": NpcStyle(
        name: "Michelangelo",
        flare: "assets/flare/TheArchitect.flr",
        accent: const Color.fromRGBO(236, 41, 117, 1.0)),
  };

  NpcStyle({this.flare, this.accent, this.name});

  static NpcStyle from(Npc npc) {
    return _all[npc.id];
  }

  static NpcStyle random() {
    Random rand = Random();
    return _all.values.elementAt(rand.nextInt(_all.values.length));
  }
}
