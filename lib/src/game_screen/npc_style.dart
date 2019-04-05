import 'dart:math';
import 'dart:ui';

import 'package:dev_rpg/src/shared_state/game/npc.dart';

/// UI style properties for [Npc]s. [Npc] to [NpcStyle] mapping is done via
/// [Npc.id] values.
class NpcStyle {
  final String flare;
  final Color accent;
  final String name;
  final String description;

  static final Map<String, NpcStyle> _all = {
    "refactorer": NpcStyle(
        name: "The Refactorer",
        flare: "assets/flare/TheRefactorer.flr",
        accent: const Color.fromRGBO(75, 58, 185, 1.0),
        description:
            "Digital Druid-type. She is so at-one with the code that 1s and 0s "
			"are falling from her hair. Her skin is partially a mesh wireframe "
			"as she becomes ever-closer to the code."),
    "architect": NpcStyle(
        name: "The Architect",
        flare: "assets/flare/TheArchitect.flr",
        accent: const Color.fromRGBO(236, 41, 117, 1.0),
        description:
            "Helps provide structure and improve code health ​when with other "
			"characters​. Probably has a ton of books and a head full of ideas. "
			"A real wizard."),
    "tpm": NpcStyle(
        name: "TPM",
        flare: "assets/flare/TheArchitect.flr",
        accent: const Color.fromRGBO(75, 58, 185, 1.0),
		description: 
			"The good ol' bard. Promotes group harmony and increases "
			"everyone else's abilities if sent on a task with others."),
    "avant_garde_designer": NpcStyle(
        name: "Avant Garde Designer",
        flare: "assets/flare/TheRefactorer.flr",
        accent: const Color.fromRGBO(236, 41, 117, 1.0),
		description: 
			"Super stylish, always wears chic glasses. Improves team execution "
			"by inspiring them with great designs for the app."),
    "leo": NpcStyle(
        name: "Leonardo",
        flare: "assets/flare/TheRefactorer.flr",
        accent: const Color.fromRGBO(75, 58, 185, 1.0)),
    "mike": NpcStyle(
        name: "Michelangelo",
        flare: "assets/flare/TheArchitect.flr",
        accent: const Color.fromRGBO(236, 41, 117, 1.0)),
  };

  NpcStyle({this.flare, this.accent, this.name, this.description = "N/A"});

  static NpcStyle from(Npc npc) {
    return _all[npc.id];
  }

  static NpcStyle random() {
    Random rand = Random();
    return _all.values.elementAt(rand.nextInt(_all.values.length));
  }
}
