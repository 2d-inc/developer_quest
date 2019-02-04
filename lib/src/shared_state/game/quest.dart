import 'dart:math';

final _random = Random();

/// A single task for the player and her team to complete.
class Quest {
  final String name;

  double percentComplete = 0;

  Quest(this.name);

  void update() {
    if (percentComplete == 1) return;

    percentComplete += _random.nextDouble() / 100;

    if (percentComplete > 1) percentComplete = 1;
  }
}
