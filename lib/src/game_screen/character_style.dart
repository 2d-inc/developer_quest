import 'dart:math';
import 'dart:ui';

import 'package:dev_rpg/src/shared_state/game/character.dart';

/// UI style properties for [Character]s. [Character] to [CharacterStyle]
/// mapping is done via [Character.id] values.
class CharacterStyle {
  final String flare;
  final Color accent;
  final String name;
  final String description;

  static final Map<String, CharacterStyle> _all = {
    "refactorer": CharacterStyle(
        name: "The Refactorer",
        flare: "assets/flare/TheRefactorer.flr",
        accent: const Color.fromRGBO(75, 58, 185, 1.0),
        description:
            "Digital Druid-type. She is so at-one with the code that 1s and 0s "
            "are falling from her hair. Her skin is partially a mesh wireframe "
            "as she becomes ever-closer to the code."),
    "architect": CharacterStyle(
        name: "The Architect",
        flare: "assets/flare/TheArchitect.flr",
        accent: const Color.fromRGBO(236, 41, 117, 1.0),
        description:
            "Helps provide structure and improve code health ​when with other "
            '''characters​. Probably has a ton of books and a head full of ideas. '''
            "A real wizard."),
    "tpm": CharacterStyle(
        name: "TPM",
        flare: "assets/flare/TheArchitect.flr",
        accent: const Color.fromRGBO(75, 58, 185, 1.0),
        description: "The good ol' bard. Promotes group harmony and increases "
            "everyone else's abilities if sent on a task with others."),
    "avant_garde_designer": CharacterStyle(
        name: "Avant Garde Designer",
        flare: "assets/flare/TheRefactorer.flr",
        accent: const Color.fromRGBO(236, 41, 117, 1.0),
        description:
            "Super stylish, always wears chic glasses. Improves team execution "
            "by inspiring them with great designs for the app."),
    "leo": CharacterStyle(
        name: "Leonardo",
        flare: "assets/flare/TheRefactorer.flr",
        accent: const Color.fromRGBO(75, 58, 185, 1.0)),
    "hacker": CharacterStyle(
        name: "The Hacker",
        flare: "assets/flare/TheHacker.flr",
        accent: const Color.fromRGBO(236, 41, 117, 1.0),
        description:
            "A reasonable coder on her own, but excels at finding and fixing "
            "security flaws and discovering unique solutions to problems. She "
            '''may have sniffed your email password while you read this description.'''),
  };

  CharacterStyle(
      {this.flare, this.accent, this.name, this.description = "N/A"});

  static CharacterStyle from(Character character) {
    return _all[character.id];
  }

  static CharacterStyle random() {
    Random rand = Random();
    return _all.values.elementAt(rand.nextInt(_all.values.length));
  }
}
