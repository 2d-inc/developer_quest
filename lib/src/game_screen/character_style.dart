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
    'jack': CharacterStyle(
        name: 'The Jack-of-All-Trades',
        flare: 'assets/flare/TheJack.flr',
        accent: const Color.fromRGBO(29, 202, 34, 1),
        description: 'Got a problem? Jack can help! Carries a snorkel '
            'everywhere he goes since he\'s always prepared.'),
    'sourcerer': CharacterStyle(
        name: 'The Sourcerer',
        flare: 'assets/flare/Sourcerer.flr',
        accent: const Color.fromRGBO(82, 183, 216, 1),
        description:
            'Accomplished problem-solver and coder who is able to find the '
            'answer to any and all problems by traversing codebases.'),
    'refactorer': CharacterStyle(
        name: 'The Refactorer',
        flare: 'assets/flare/TheRefactorer.flr',
        accent: const Color.fromRGBO(75, 58, 185, 1),
        description:
            'A Digital Druid. She has a sixth sense when it comes to code '
            'health. Need to restructure your code? Is your code made up of a '
            'bunch of copy-paste snippets? Send in The Refactorer to clean up '
            'your codebase and make it shine!'),
    'architect': CharacterStyle(
        name: 'The Architect',
        flare: 'assets/flare/TheArchitect.flr',
        accent: const Color.fromRGBO(236, 41, 117, 1),
        description:
            'Helps provide structure in large codebases, which can improve '
            'code health. Has a ton of books and a head full of ideas.'),
    'pm': CharacterStyle(
        name: 'Program Manager',
        flare: 'assets/flare/ProgramManager.flr',
        accent: const Color.fromRGBO(84, 209, 88, 1),
        description:
            'Promotes communication and group harmony. He has the superpower '
            'of increasing everyone else\'s abilities if assigned to a task '
            'with others.'),
    'avant_garde_designer': CharacterStyle(
        name: 'Avant Garde Designer',
        flare: 'assets/flare/Designer.flr',
        accent: const Color.fromRGBO(236, 148, 0, 1),
        description:
            'Improves team execution by inspiring them with great designs for '
            'the app. Her designs win over more customers and spark joy when '
            'users interact with the app.'),
    'cowboy': CharacterStyle(
        name: 'The Cowboy Coder',
        flare: 'assets/flare/CowboyCoder.flr',
        accent: const Color.fromRGBO(75, 58, 185, 1),
        description:
            'An extremely prolific coder who doesn\'t like structure. He can '
            'write a whole lot of code very quickly... hopefully everyone else '
            'can read it. Yeehaw!'),
    'tester': CharacterStyle(
        name: 'The Test Engineer',
        flare: 'assets/flare/Tester.flr',
        accent: const Color.fromRGBO(75, 58, 185, 1),
        description:
            'An excellent developer in their own right, the Test Engineer '
            'creates invaluable frameworks for continuous integration testing '
            'and fixes bugs at lightning speed.'),
    'uxr': CharacterStyle(
        name: 'User Experience Researcher',
        flare: 'assets/flare/UXResearcher.flr',
        accent: const Color.fromRGBO(222, 165, 88, 1),
        description:
            'They design enlightening experiments to better understand user '
            'needs, resulting in a delightful user experience.'),
    'hacker': CharacterStyle(
        name: 'The Hacker',
        flare: 'assets/flare/TheHacker.flr',
        accent: const Color.fromRGBO(236, 41, 117, 1),
        description:
            'A strong coder on her own, but excels at finding and fixing '
            'security flaws and also discovering unique solutions to problems. '
            'She may have sniffed your email password while you read this '
            'description.'),
  };

  CharacterStyle(
      {this.flare, this.accent, this.name, this.description = 'N/A'});

  static CharacterStyle from(Character character) {
    return _all[character.id];
  }

  static CharacterStyle random() {
    Random rand = Random();
    return _all.values.elementAt(rand.nextInt(_all.values.length));
  }
}
